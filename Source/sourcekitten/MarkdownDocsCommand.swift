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
//        let args = options.arguments
//        if !options.spmModule.isEmpty {
//            return runSPMModule(moduleName: options.spmModule)
//        } else if options.objc {
//            return runObjC(options: options, args: args)
//        } else if options.singleFile {
//            return runSwiftSingleFile(args: args)
//        }
//        let moduleName: String? = options.moduleName.isEmpty ? nil : options.moduleName
//        return runSwiftModule(moduleName: moduleName, args: args)
        print("Generating some awesome docs...")
        print("Done 🎉")
        return .success(())
    }

}

