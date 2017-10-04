//
//  MarkdownDocsCommand.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/2/17.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct MarkdownDocsCommand: CommandProtocol {
    let verb = "mdocs"
    let function = "Generate Swift or Objective-C docs in Markdown format"

    /// Base path for generated Markdown reference documentation (not including trailing slash)
    /// Note: Constant for now, could be parametrized later on
    let docsPath = "docs/reference"

//    /// Map of Markdown files to be
//    var markdownFiles = [String: MarkdownFile]()

    struct Options: OptionsProtocol {
        let spmModule: String
        let singleFile: Bool
        let moduleName: String
        let objc: Bool
        let arguments: [String]

        static func create(spmModule: String) -> (_ singleFile: Bool) -> (_ moduleName: String) -> (_ objc: Bool) -> (_ arguments: [String]) -> Options {
            return { singleFile in { moduleName in { objc in { arguments in
                self.init(spmModule: spmModule, singleFile: singleFile, moduleName: moduleName, objc: objc, arguments: arguments)
                }}}}
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "spm-module", defaultValue: "",
                                   usage: "document a Swift Package Manager module")
                <*> mode <| Option(key: "single-file", defaultValue: false,
                                   usage: "only document one file")
                <*> mode <| Option(key: "module-name", defaultValue: "",
                                   usage: "name of module to document (can't be used with `--single-file` or `--objc`)")
                <*> mode <| Option(key: "objc", defaultValue: false,
                                   usage: "document Objective-C headers")
                <*> mode <| Argument(defaultValue: [],
                                     usage: "Arguments list that passed to xcodebuild. If `-` prefixed argument exists, place ` -- ` before that.")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        print("Generating some awesome docs at: \(FileManager.default.currentDirectoryPath)/\(docsPath)")
        defer { print("Done.") }

        let args = options.arguments
        if !options.spmModule.isEmpty {
            return runSPMModule(moduleName: options.spmModule)
        } else if options.objc {
            return runObjC(options: options, args: args)
        } else if options.singleFile {
            return runSwiftSingleFile(args: args)
        }
        let moduleName: String? = options.moduleName.isEmpty ? nil : options.moduleName
        return runSwiftModule(moduleName: moduleName, args: args)
    }

    func runSPMModule(moduleName: String) -> Result<(), SourceKittenError> {
        guard let docs = Module(spmName: moduleName)?.docs else {
            return .failure(.docFailed)
        }
        process(docs: docs)
        return .success(())
    }

    func runSwiftModule(moduleName: String?, args: [String]) -> Result<(), SourceKittenError> {
        guard let docs = Module(xcodeBuildArguments: args, name: moduleName)?.docs else {
            return .failure(.docFailed)
        }
        process(docs: docs)
        return .success(())
    }

    func runSwiftSingleFile(args: [String]) -> Result<(), SourceKittenError> {
        if args.isEmpty {
            return .failure(.invalidArgument(description: "at least 5 arguments are required when using `--single-file`"))
        }
        let sourcekitdArguments = Array(args.dropFirst(1))
        guard let file = File(path: args[0]), let docs = SwiftDocs(file: file, arguments: sourcekitdArguments) else {
            return .failure(.readFailed(path: args[0]))
        }
        process(docs: [docs])
        return .success(())
    }

    func runObjC(options: Options, args: [String]) -> Result<(), SourceKittenError> {
        fatalError("unsupported")
    }

    private func process(docs: [SwiftDocs]) {
        let dictionaries = docs.flatMap { $0.docsDictionary.bridge() as? SwiftDocDictionary }
        process(dictionaries: dictionaries)
    }

    private func process(dictionaries: [SwiftDocDictionary]) {
        dictionaries.forEach { process(dictionary: $0) }
    }

    private func process(dictionary: SwiftDocDictionary) {
        if let value: String = dictionary.get(.kind), let kind = SwiftDeclarationKind(rawValue: value) {
            switch kind {
            case .struct:
                try? writeFile(content: MarkdownObject(dictionary: dictionary), subdirectory: "structs")
            case .class:
                try? writeFile(content: MarkdownObject(dictionary: dictionary), subdirectory: "classes")
            case .extension, .extensionProtocol, .extensionStruct, .extensionClass, .extensionEnum:
                try? writeFile(content: MarkdownExtension(dictionary: dictionary), subdirectory: "extensions")
            case .enum:
                try? writeFile(content: MarkdownEnum(dictionary: dictionary), subdirectory: "enums")
            case .protocol:
                try? writeFile(content: MarkdownProtocol(dictionary: dictionary), subdirectory: "protocols")
            case .typealias:
                try? writeFile(content: MarkdownTypealias(dictionary: dictionary), subdirectory: "typealiases")
            default:
                break
            }
        }

        if let substructure = dictionary[SwiftDocKey.substructure.rawValue] as? [[String: Any]] {
            process(dictionaries: substructure)
        }
    }

    private func writeFile(content item: MarkdownConvertible?, subdirectory: String) throws {
        guard let item = item, let filename = (item as? SwiftDocDictionaryInitializable)?.name else {
            return
        }
        let basePath = "\(FileManager.default.currentDirectoryPath)/\(docsPath)"
        try MarkdownFile(filename: filename, content: [item]).write(basePath: "\(basePath)/\(subdirectory)/")
    }

}
