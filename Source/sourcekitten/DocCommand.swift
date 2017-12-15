//
//  DocCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct DocCommand: CommandProtocol {
    let verb = "doc"
    let function = "Print Swift or Objective-C docs as JSON"

    struct Options: OptionsProtocol {
        let spmModule: String
        let singleFile: Bool
        let moduleName: String
        let objc: Bool
        let objcXcodebuild: Bool
        let umbrellaHeader: String
        let arguments: [String]

        static func create(spmModule: String) -> (_ singleFile: Bool) -> (_ moduleName: String) ->
            (_ objc: Bool) -> (_ objcXcodebuild: Bool) -> (_ objcUmbrellaHeader: String) -> (_ arguments: [String]) -> Options {
            return { singleFile in { moduleName in { objc in { objcXcodebuild in { umbrellaHeader in { arguments in
            self.init(spmModule: spmModule,
                      singleFile: singleFile,
                      moduleName: moduleName,
                      objc: objc,
                      objcXcodebuild: objcXcodebuild,
                      umbrellaHeader: umbrellaHeader,
                      arguments: arguments)
            }}}}}}
        }

        var moduleNameOrNil: String? {
            return moduleName.isEmpty ? nil : moduleName
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> mode <| Option(key: "spm-module", defaultValue: "",
                                   usage: "Document a Swift Package Manager module")
                <*> mode <| Option(key: "single-file", defaultValue: false,
                                   usage: "Document only one Swift file")
                <*> mode <| Option(key: "module-name", defaultValue: "",
                                   usage: "Name of module to document (can't be used with `--single-file` or `--objc`)")
                <*> mode <| Option(key: "objc", defaultValue: false,
                                   usage: "Document Objective-C headers. Pass all clang arguments in the arguments list.")
                <*> mode <| Option(key: "objc-xcodebuild", defaultValue: false,
                                   usage: "Document Objective-C headers. Use xcodebuild to guess clang arguments. " +
                                          "Pass additional xcodebuild arguments in the arguments list.")
                <*> mode <| Option(key: "umbrella-header", defaultValue: "",
                                   usage: "Path to the top-level Objective-C header file for use with `--objc-xcodebuild`.")
                <*> mode <| Argument(defaultValue: [],
                                     usage: "Arguments list passed to xcodebuild/clang. If `-` prefixed argument exists, place ` -- ` before that.")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        let args = options.arguments
        if !options.spmModule.isEmpty {
            return runSPMModule(moduleName: options.spmModule)
        } else if options.objc {
            return runObjCDirect(options: options, args: args)
        } else if options.objcXcodebuild {
            return runObjCXcodebuild(umbrellaHeader: options.umbrellaHeader, moduleName: options.moduleNameOrNil, args: args)
        } else if options.singleFile {
            return runSwiftSingleFile(args: args)
        }
        return runSwiftModule(moduleName: options.moduleNameOrNil, args: args)
    }

    func runSPMModule(moduleName: String) -> Result<(), SourceKittenError> {
        if let docs = Module(spmName: moduleName)?.docs {
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

    func runObjCDirect(options: Options, args: [String]) -> Result<(), SourceKittenError> {
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

    func runObjCXcodebuild(umbrellaHeader: String, moduleName: String?, args: [String]) -> Result<(), SourceKittenError> {
        #if os(Linux)
        fatalError("unsupported")
        #else
        print("module: \(moduleName ?? "(default module)")")
        print("umbrella: " + umbrellaHeader)
        print("args: \(args)")
        return .success(())
        #endif
    }
}
