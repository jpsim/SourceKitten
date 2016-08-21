//
//  Module.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import Yaml

/// Represents source module to be documented.
public struct Module {
    /// Module Name.
    public let name: String
    /// Compiler arguments required by SourceKit to process the source files in this Module.
    public let compilerArguments: [String]
    /// Source files to be documented in this Module.
    public let sourceFiles: [String]

    /// Documentation for this Module. Typically expensive computed property.
    public var docs: [SwiftDocs] {
        var fileIndex = 1
        let sourceFilesCount = sourceFiles.count
        return sourceFiles.flatMap {
            let filename = $0.bridge().lastPathComponent
            if let file = File(path: $0) {
                fputs("Parsing \(filename) (\(fileIndex)/\(sourceFilesCount))\n", stderr)
                fileIndex += 1
                return SwiftDocs(file: file, arguments: compilerArguments)
            }
            fputs("Could not parse `\(filename)`. Please open an issue at https://github.com/jpsim/SourceKitten/issues with the file contents.\n", stderr)
            return nil
        }
    }

    public init?(spmName: String) {
        let yamlPath = ".build/debug.yaml"
        guard let yamlContents = try? String(contentsOfFile: yamlPath),
              let yamlCommands = Yaml.load(yamlContents).value?.dictionary?["commands"]?.dictionary?.values else {
                return nil
        }
        guard let moduleCommand = yamlCommands.filter({ command in
            command.dictionary?["module-name"]?.string == spmName
        }).first?.dictionary else {
            fputs("Could not find SPM module '\(spmName)'. Here are the modules available:\n", stderr)
            let availableModules = yamlCommands.flatMap({ $0.dictionary?["module-name"]?.string })
            fputs("\(availableModules.map({ "  - " + $0 }).joined(separator: "\n"))\n", stderr)
            return nil
        }
        func stringArray(_ key: Yaml) -> [String]? {
            return moduleCommand[key]?.array?.flatMap { $0.string }
        }
        guard let imports = stringArray("import-paths"),
              let otherArguments = stringArray("other-args"),
              let sources = stringArray("sources") else {
                return nil
        }
        name = spmName
        compilerArguments = sources + otherArguments + ["-I"] + imports
        sourceFiles = sources
    }

#if !os(Linux)
    /**
    Failable initializer to create a Module by the arguments necessary pass in to `xcodebuild` to build it.
    Optionally pass in a `moduleName` and `path`.

    - parameter xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to build this Module.
    - parameter name:                Module name. Will be parsed from `xcodebuild` output if nil.
    - parameter path:                Path to run `xcodebuild` from. Uses current path by default.
    */
    public init?(xcodeBuildArguments: [String], name: String? = nil, inPath path: String = defaultFileManager.currentDirectoryPath) {
        let xcodeBuildOutput = runXcodeBuild(arguments: xcodeBuildArguments, inPath: path) ?? ""
        guard let arguments = parseCompilerArguments(xcodebuildOutput: xcodeBuildOutput as NSString, language: .Swift, moduleName: name ?? moduleNameFromArguments(arguments: xcodeBuildArguments)) else {
            fputs("Could not parse compiler arguments from `xcodebuild` output.\n", stderr)
            fputs("Please confirm that `xcodebuild` is building a Swift module.\n", stderr)
            let file = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("xcodebuild-\(NSUUID().uuidString).log")
            try! xcodeBuildOutput.data(using: .utf8)?.write(to: file!, options: .atomicWrite)
            fputs("Saved `xcodebuild` log file: \(file!.path)\n", stderr)
            return nil
        }
        guard let moduleName = moduleNameFromArguments(arguments: arguments) else {
            fputs("Could not parse module name from compiler arguments.\n", stderr)
            return nil
        }
        self.init(name: moduleName, compilerArguments: arguments)
    }
#endif

    /**
    Initializer to create a Module by name and compiler arguments.

    - parameter name:              Module name.
    - parameter compilerArguments: Compiler arguments required by SourceKit to process the source files in this Module.
    */
    public init(name: String, compilerArguments: [String]) {
        self.name = name
        self.compilerArguments = compilerArguments
        sourceFiles = compilerArguments.filter({
            $0.bridge().isSwiftFile() && $0.isFile
        }).map {
            #if os(Linux)
            return try! URL(fileURLWithPath: $0).resolvingSymlinksInPath().path!
            #else
            return URL(fileURLWithPath: $0).resolvingSymlinksInPath().path
            #endif
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
