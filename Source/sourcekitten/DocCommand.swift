//
//  DocCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import SourceKittenFramework

struct DocCommand: CommandProtocol {
    let verb = "doc"
    let function = "Print Swift or Objective-C docs as JSON"

    struct Options: OptionsProtocol {
        let singleFile: Bool
        let moduleName: String
        let spm: Bool
        let objc: Bool
        let arguments: [String]

        static func create(singleFile: Bool) ->
            (_ moduleName: String) ->
            (_ spm: Bool) ->
            (_ objc: Bool) ->
            (_ spmModule: String) ->
            (_ arguments: [String]) -> Options {
            return { moduleName in { spm in { objc in { spmModule in { arguments in
                self.init(singleFile: singleFile,
                          moduleName: moduleName.isEmpty ? spmModule : moduleName,
                          spm: spm || !spmModule.isEmpty,
                          objc: objc,
                          arguments: arguments)
                }}}}}
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "single-file", defaultValue: false,
                                   usage: "only document one file")
                <*> mode <| Option(key: "module-name", defaultValue: "",
                                   usage: "name of Swift module to document (can't be used with `--single-file`)")
                <*> mode <| Option(key: "spm", defaultValue: false,
                                   usage: "document a Swift Package Manager module")
                <*> mode <| Option(key: "objc", defaultValue: false,
                                   usage: "document Objective-C headers instead of Swift code")
                <*> mode <| Option(key: "spm-module", defaultValue: "",
                                   usage: "equivalent to --spm --module-name (string)")
                <*> mode <| Argument(defaultValue: [],
                                     usage: "Arguments passed to `xcodebuild` or `swift build`. If `-` prefixed argument exists, place ` -- ` before that.")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        let args = options.arguments
        let moduleName: String? = options.moduleName.isEmpty ? nil : options.moduleName
        if options.spm {
            return runSPMModule(moduleName: moduleName, args: args)
        } else if options.objc {
            return runObjC(options: options, args: args)
        } else if options.singleFile {
            return runSwiftSingleFile(args: args)
        }
        return runSwiftModule(moduleName: moduleName, args: args)
    }

    func runSPMModule(moduleName: String?, args: [String]) -> Result<(), SourceKittenError> {
        if let docs = Module(spmArguments: args, spmName: moduleName)?.docs {
            print(docs)
            return .success(())
        }
        return .failure(.docFailed)
    }

    func runSwiftModule(moduleName: String?, args: [String]) -> Result<(), SourceKittenError> {
        let module = Module(xcodeBuildArguments: args, name: moduleName)

        if let docs = module?.docs {
            print(docs)
            return .success(())
        }
        return .failure(.docFailed)
    }

    func runSwiftSingleFile(args: [String]) -> Result<(), SourceKittenError> {
        if args.isEmpty {
            return .failure(.invalidArgument(description: "at least 5 arguments are required when using `--single-file`"))
        }
        let sourcekitdArguments = Array(args.dropFirst(1))
        if let file = File(path: args[0]),
           let docs = SwiftDocs(file: file, arguments: sourcekitdArguments) {
            print(docs)
            return .success(())
        }
        return .failure(.readFailed(path: args[0]))
    }

    func runObjC(options: Options, args: [String]) -> Result<(), SourceKittenError> {
        #if os(Linux)
        fatalError("unsupported")
        #else
        if args.isEmpty {
            return .failure(.invalidArgument(description: "at least 5 arguments are required when using `--objc`"))
        }
        let translationUnit = ClangTranslationUnit(headerFiles: [args[0]], compilerArguments: Array(args.dropFirst(1)))
        print(translationUnit)
        return .success(())
        #endif
    }
}
