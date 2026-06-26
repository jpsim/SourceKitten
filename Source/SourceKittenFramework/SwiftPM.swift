import Foundation
import Yams

/// Namespace for utilities to decode Swift Package Manager build directories with the goal
/// of finding source files and Swift compiler arguments required to run SourceKit doc generation
/// over a module.
enum SwiftPM {
    // MARK: debug.yaml

    private static func debugYamlPath(inPath path: String) -> String {
        return URL(fileURLWithPath: path).appendingPathComponent(".build/debug.yaml").path
    }

    /// Is there a `debug.yaml` file in the .bulid directory
    static func hasDebugYaml(inPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: debugYamlPath(inPath: path))
    }

    /**
     Get module build flags and optionally name from the `debug.yaml` file produced by the default SwiftPM build
     system earlier than Swift 6.4.

     - parameter moduleName: Module name to build, or `nil` to pick one
     - parameter inPath: Directory containing `.build`
     - returns: tuple of module name and compiler args, or `nil` on failure - errors reported
     */
    static func fromDebugYaml(moduleName: String?, inPath path: String) -> (String, [String])? {
        let yamlPath = debugYamlPath(inPath: path)
        guard let yaml = try? Yams.compose(yaml: String(contentsOfFile: yamlPath, encoding: .utf8)),
              let commands = (yaml as Node?)?["commands"]?.mapping?.values else {
            fputs("SPM build manifest does not exist at `\(yamlPath)` or does not match expected format.\n", stderr)
            return nil
        }

        func matchModuleName(node: Node) -> Bool {
            guard let nodeModuleName = node.swiftModuleName else { return false }
            if let spmModuleName = moduleName {
                return nodeModuleName == spmModuleName
            }
            let inputs = node["inputs"]?.array(of: String.self) ?? []
            return inputs.allSatisfy({ !$0.contains(".build/checkouts/") }) && !nodeModuleName.hasSuffix("Tests")
        }

        guard let moduleCommand = commands.first(where: matchModuleName) else {
            fputs("Could not find SPM module '\(moduleName ?? "(any)")'. Here are the modules available:\n", stderr)
            let availableModules = commands.compactMap(\.swiftModuleName)
            fputs("\(availableModules.map({ "  - " + $0 }).joined(separator: "\n"))\n", stderr)
            return nil
        }

        guard let foundModuleName = moduleCommand.swiftModuleName,
              let compilerArguments = moduleCommand.swiftCompilerArguments else {
            fputs("SPM build manifest '\(yamlPath)` does not match expected format.\n", stderr)
            return nil
        }

        return (foundModuleName, compilerArguments)
    }

    // MARK: Build commands

    /**
     Run a build command.  If it works then return the results otherwise report the error and save the output.

     - parameter arguments: Program name and arguments
     - parameter path: Working directory for program
     - parameter msgName: name of the program to report to user if it fails
     */
    private static func runCheckedCommand(arguments: [String], inPath path: String, msgName: String) -> Exec.Results? {
        let results = Exec.run("/usr/bin/env", arguments, currentDirectory: path, stderr: .merge)
        guard results.terminationStatus == 0 else {
            let path = results.save(prefix: "swift-build")
            fputs("Build failed, saved `\(msgName)` log file: \(path)\n", stderr)
            return nil
        }
        return results
    }

    /// Run `swift build`. Return the successful results or `nil` and report the error.
    static func runBuild(arguments: [String], inPath path: String) -> Exec.Results? {
        return runCheckedCommand(arguments: ["swift", "build"] + arguments, inPath: path, msgName: "swift build")
    }

    /// Run `swift build -v`. Return the successful results or `nil` and report the error.
    static func runVerboseBuild(arguments: [String], inPath path: String) -> Exec.Results? {
        return runBuild(arguments: ["-v"] + arguments, inPath: path)
    }

    /// Run `swift package clean`. Return the successful results or `nil` and report the error.
    static func runClean(inPath path: String) -> Exec.Results? {
        return runCheckedCommand(arguments: ["swift", "package", "clean"], inPath: path, msgName: "swift package clean")
    }

    // MARK: Build output parsing

    /**
     Given some results from `swift build -v`, find the compiler arguments for the module.

     - parameter swiftBuildOutput: Output of `swift build -v
     - parameter moduleName: Module of interest, `nil` to use any
     - returns: tuple of module name and compiler args, or `nil` on failure
     */
    static func fromBuildResults(_ results: Exec.Results, moduleName: String?) -> (String, [String])? {
        guard let buildOutput = results.string,
              let swiftArgs = SourceKittenFramework.parseCompilerArguments(
                xcodebuildOutput: buildOutput,
                language: .swift,
                moduleName: moduleName),
              let actualModuleName = SourceKittenFramework.moduleName(fromArguments: swiftArgs) else {
            return nil
        }
        return (actualModuleName, swiftArgs)
    }
}

// MARK: Yams.Node helpers for SwiftPM's debug.yaml

// The yaml structure changed in Xcode 15.3 / SwiftPM 5.10.  This extension decodes both formats.
private extension Node {
    // SwiftPM < 5.10: 'module-name' string
    // SwiftPM   5.10: buried inside compiler args
    var swiftModuleName: String? {
        if let moduleNameNode = self["module-name"] {
            return moduleNameNode.string
        }
        if let description = self["description"]?.string,
           description.hasPrefix("Compiling Swift Module"),
           let arguments = self["args"]?.array(of: String.self) {
            return moduleName(fromArguments: arguments)
        }
        return nil
    }

    // SwiftPM < 5.10: 'sources' array of Swift files
    // SwiftPM   5.10: 'inputs' array of various things including Swift files
    var swiftSources: [String]? {
        (self["sources"] ?? self["inputs"])?
            .array(of: String.self)
            .filter { $0.isSwiftFile() }
    }

    // SwiftPM < 5.10: 'other-args' and 'import-paths' arrays
    // SwiftPM   5.10: 'args' is the entire command line that needs filtering
    //   for SourceKit.  Additionally it contains a response file that may or
    //   may not contain the list of source files - guessing a window in the
    //   way we use this unofficial interface to SwiftPM.  Use the separate
    //   'inputs' node, but we must remove the response file in case it *does*
    //   contain the files which would cause duplicate file processing...
    var swiftOtherCompilerArguments: [String]? {
        if let buildCommandArguments = self["args"]?
            .array(of: String.self)
            .filter({ !$0.hasPrefix("@") }) {
            // Drop the initial "/usr/bin/swiftc"
            return filterForSourceKit(arguments: Array(buildCommandArguments.dropFirst()))
        }

        guard let imports = self["import-paths"]?.array(of: String.self),
              let otherArguments = self["other-args"]?.array(of: String.self),
              let moduleName = swiftModuleName else {
            return nil
        }

        var arguments = ["-module-name", moduleName]
        arguments.append(contentsOf: otherArguments)
        arguments.append(contentsOf: ["-I"])
        arguments.append(contentsOf: imports)
        return arguments
    }

    var swiftCompilerArguments: [String]? {
        guard let sources = swiftSources,
              let otherCompilerArguments = swiftOtherCompilerArguments else {
            return nil
        }

        return sources + otherCompilerArguments
    }
}
