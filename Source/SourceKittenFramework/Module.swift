import Foundation
import Yams

/// Represents source module to be documented.
public struct Module {
    /// Module Name.
    public let name: String
    /// Compiler arguments required by SourceKit to process the source files in this Module.
    public let compilerArguments: [String]
    /// Source files to be documented in this Module.
    public let sourceFiles: [String]

    private let eventHook: EventHook

    /// Documentation for this Module. Typically expensive computed property.
    public var docs: [SwiftDocs] {
        var fileIndex = 1
        let sourceFilesCount = sourceFiles.count
        return sourceFiles.sorted().compactMap {
            let filename = $0.bridge().lastPathComponent
            if let file = File(path: $0, eventHook: eventHook) {
                eventHook.emit("Parsing \(filename) (\(fileIndex)/\(sourceFilesCount))\n")
                fileIndex += 1
                return SwiftDocs(file: file, arguments: compilerArguments, eventHook: eventHook)
            }
            eventHook.emit("Could not parse `\(filename)`. Please open an issue at https://github.com/jpsim/SourceKitten/issues with the file contents.\n")
            return nil
        }
    }

    /**
     Failable initializer to create a Module from a Swift Package Manager build record.

     Use this initializer when the package has already been built and the `.build` directory exists
     and the build system is not Swift Build.

     This initializer does not work with the Swift Build backend that is the default in Swift PM 6.4.
     Use `init(spmArguments:spmName:inPath:)` instead, which will build the package.

     - parameter spmName: Module name.  Will use some non-Test module that is part of the
                          package if `nil`.
     - parameter path:    Path of the directory containing the SPM `.build` directory.
                          Uses the current directory by default.
     */
    @available(*, deprecated, message: """
                Use init(spmArguments:spmName:inPath:) instead.
                This initializer does not support the Swift Build backend that is the default for SwiftPM 6.4
                """)
    public init?(spmName: String? = nil, inPath path: String = FileManager.default.currentDirectoryPath) {
        self.init(spmName: spmName, inPath: path, eventHook: .standardError)
    }

    /// Creates a module from a SwiftPM build record, routing diagnostics to `eventHook`.
    @available(*, deprecated, message: """
                Use init(spmArguments:spmName:inPath:eventHook:) instead.
                This initializer does not support the Swift Build backend that is the default for SwiftPM 6.4
                """)
    public init?(spmName: String? = nil, inPath path: String = FileManager.default.currentDirectoryPath, eventHook: EventHook) {
        guard let results = SwiftPM.fromDebugYaml(moduleName: spmName, inPath: path, eventHook: eventHook) else {
            return nil
        }
        eventHook.emit("Using module data from debug.yaml\n")
        self.init(name: results.0, compilerArguments: results.1, eventHook: eventHook)
    }

    /**
     Failable initializer to create a Module by building a Swift Package Manager project.

     As of SwiftPM 6.4 this is likely to build the package even it has been previously built because
     of the build system changing to Swift Build.

     - parameter spmArguments: Additional arguments to pass to `swift build`
     - parameter spmName: Module name.  Will use some non-Test module that is part of the
                          package if `nil`.
     - parameter path:    Path of the directory containing the `Package.swift` file.
                          Uses the current directory by default.
     */
    public init?(spmArguments: [String], spmName: String? = nil, inPath path: String = FileManager.default.currentDirectoryPath) {
        self.init(spmArguments: spmArguments, spmName: spmName, inPath: path, eventHook: .standardError)
    }

    /// Builds a Swift package and creates its module, routing diagnostics to `eventHook`.
    public init?(spmArguments: [String], spmName: String? = nil,
                 inPath path: String = FileManager.default.currentDirectoryPath, eventHook: EventHook) {
        /*
         1. `build -v` to get a build directory and maybe some compile commands for (3).
             Fast if already built.
         2. If there is a `debug.yaml` file then use it -- pre-6.4 / swiftbuild back-end.  Done.
         3. Check for compiler flags in the build log from (1) -- if successful then Done.
         4. `package clean` and `build -v` --- hope that (3) failed because module already built
            before (1) so it did not rebuild anything.
         5. Check for compiler flags in the build log from (4) -- if successful then Done.
         6. Fail.

         The swiftbuild backend uses a proprietary binary-ish msgpack format instead of the debug.yaml.
         We could decode it and save the extra clean-build-verbose step but would mean heavier
         dependencies and more fragility.

         The swiftbuild backend produces an XCBuildData/manifest.json that looks promising but does not
         contain compiler arguments.
        */

        // 1. Initial build check
        eventHook.emit("Running swift build\n")
        guard let buildResults = SwiftPM.runVerboseBuild(arguments: spmArguments, inPath: path, eventHook: eventHook) else {
            return nil
        }

        // 2. Use the SwiftPM debug.yaml manifest where available.
        if SwiftPM.hasDebugYaml(inPath: path) {
            if let info = SwiftPM.fromDebugYaml(moduleName: spmName, inPath: path, eventHook: eventHook) {
                eventHook.emit("Using module data from debug.yaml\n")
                self.init(name: info.0, compilerArguments: info.1, eventHook: eventHook)
                return
            }
            return nil
        }

        // 3. See if the (1) build built our module
        if let info = SwiftPM.fromBuildResults(buildResults, moduleName: spmName) {
            eventHook.emit("Using module data from build output\n")
            self.init(name: info.0, compilerArguments: info.1, eventHook: eventHook)
            return
        }

        // 4. Clean & Build
        eventHook.emit("Running swift package clean and build\n")
        guard SwiftPM.runClean(inPath: path, eventHook: eventHook) != nil,
              let secondBuildResults = SwiftPM.runVerboseBuild(arguments: spmArguments, inPath: path, eventHook: eventHook) else {
            return nil
        }

        // 5. Should have our module now
        if let info = SwiftPM.fromBuildResults(secondBuildResults, moduleName: spmName) {
            eventHook.emit("Using module data from clean build output\n")
            self.init(name: info.0, compilerArguments: info.1, eventHook: eventHook)
            return
        }

        let path = secondBuildResults.save(prefix: "swift-build")
        eventHook.emit("Could not parse module name '\(spmName ?? "(any)")' from swift build output: \(path)\n")
        return nil
    }

    /**
    Failable initializer to create a Module by the arguments necessary pass in to `xcodebuild` to build it.
    Optionally pass in a `moduleName` and `path`.

    - parameter xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to build this Module.
    - parameter name:                Module name. Will be parsed from `xcodebuild` output if nil.
    - parameter path:                Path to run `xcodebuild` from. Uses current path by default.
    */
    public init?(xcodeBuildArguments: [String], name: String? = nil, inPath path: String = FileManager.default.currentDirectoryPath) {
        self.init(xcodeBuildArguments: xcodeBuildArguments, name: name, inPath: path, eventHook: .standardError)
    }

    /// Builds an Xcode module, routing framework diagnostics to `eventHook`.
    public init?(xcodeBuildArguments: [String], name: String? = nil,
                 inPath path: String = FileManager.default.currentDirectoryPath, eventHook: EventHook) {
        let buildSettings = XcodeBuild.showBuildSettings(arguments: xcodeBuildArguments, inPath: path)

        let name = name
            // Check for user-defined "SWIFT_MODULE_NAME", otherwise use "PRODUCT_MODULE_NAME".
            ?? buildSettings?.firstBuildSettingValue { $0.SWIFT_MODULE_NAME ?? $0.PRODUCT_MODULE_NAME }
            ?? moduleName(fromArguments: xcodeBuildArguments)

        // Executing normal build
        let results = XcodeBuild.build(arguments: xcodeBuildArguments, inPath: path, eventHook: eventHook)
        if results.terminationStatus != 0 {
            eventHook.emit("Could not successfully run `xcodebuild`.\n")
            eventHook.emit("Please check the build arguments.\n")
            let path = results.save(prefix: "xcodebuild")
            eventHook.emit("Saved `xcodebuild` log file: \(path)\n")
            return nil
        }
        if let output = results.string,
            let arguments = parseCompilerArguments(xcodebuildOutput: output, language: .swift, moduleName: name),
            let moduleName = moduleName(fromArguments: arguments) {
            self.init(name: moduleName, compilerArguments: arguments, eventHook: eventHook)
            return
        }
        // Check New Build System is used
        eventHook.emit("Checking xcodebuild -showBuildSettings\n")
        if let projectTempRoot = buildSettings?.firstBuildSettingValue(for: { $0.PROJECT_TEMP_ROOT }),
            let arguments = checkNewBuildSystem(in: projectTempRoot, moduleName: name, eventHook: eventHook),
            let moduleName = moduleName(fromArguments: arguments) {
            self.init(name: moduleName, compilerArguments: arguments, eventHook: eventHook)
            return
        }
        // Executing `clean build` is a fallback.
        let xcodeBuildOutput = XcodeBuild.cleanBuild(arguments: xcodeBuildArguments, inPath: path, eventHook: eventHook).string ?? ""
        guard let arguments = parseCompilerArguments(xcodebuildOutput: xcodeBuildOutput, language: .swift, moduleName: name) else {
            eventHook.emit("Could not parse compiler arguments from `xcodebuild` output.\n")
            eventHook.emit("Please confirm that `xcodebuild` is building a Swift module.\n")
            let file = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("xcodebuild-\(NSUUID().uuidString).log")
            _ = try? xcodeBuildOutput.data(using: .utf8)?.write(to: file)
            eventHook.emit("Saved `xcodebuild` log file: \(file.path)\n")
            return nil
        }
        guard let moduleName = moduleName(fromArguments: arguments) else {
            eventHook.emit("Could not parse module name from compiler arguments.\n")
            return nil
        }
        self.init(name: moduleName, compilerArguments: arguments, eventHook: eventHook)
    }

    /**
    Initializer to create a Module by name and compiler arguments.

    - parameter name:              Module name.
    - parameter compilerArguments: Compiler arguments required by SourceKit to process the source files in this Module.
    */
    public init(name: String, compilerArguments: [String]) {
        self.init(name: name, compilerArguments: compilerArguments, eventHook: .standardError)
    }

    /// Creates a module whose deferred documentation diagnostics use `eventHook`.
    public init(name: String, compilerArguments: [String], eventHook: EventHook) {
        self.name = name
        self.eventHook = eventHook
        self.compilerArguments = compilerArguments.expandingResponseFiles
        sourceFiles = self.compilerArguments.filter({
            $0.bridge().isSwiftFile() && $0.isFile
        }).map {
            return URL(fileURLWithPath: $0).resolvingSymlinksInPath().path
        }
    }
}

// MARK: CustomStringConvertible

extension Module: CustomStringConvertible {
    /// A textual representation of `Module`.
    public var description: String {
        return "Module(name: \(name), compilerArguments: \(compilerArguments), sourceFiles: \(sourceFiles))"
    }
}

// MARK: XcodeBuildSetting Conveniences

private extension Collection where Element == XcodeBuildSetting {
    /// Iterates through the `XcodeBuildSetting`s and returns the first value returned by the getter closure.
    ///
    /// For example, if we want the value of the first `XcodeBuildSetting` with a `"PROJECT_TEMP_ROOT"` value:
    ///
    ///     let buildSettings: [XcodeBuildSetting] = ...
    ///     let projectTempRoot = buildSettings.firstBuildSettingValue { $0.projectTempRoot }
    ///
    /// - Parameter getterClosure: A closure that returns a dynamic member.
    /// - Returns: The first value returned by the getter closure.
    func firstBuildSettingValue(for getterClosure: (XcodeBuildSetting) -> String?) -> String? {
        return lazy.compactMap(getterClosure).first
    }
}
