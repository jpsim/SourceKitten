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
        if let module = Module(spmName: moduleName) {
            for file in module.sourceFiles {
                let unusedImports = File(path: file)!.unusedImports(compilerArguments: module.compilerArguments)
                if !unusedImports.isEmpty {
                    print("Unused imports in \(file.bridge().lastPathComponent):")
                    for module in unusedImports {
                        print("- \(module)")
                    }
                }
            }
        }
        return .success(())
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

private let syntaxTypesToSkip = [
    "source.lang.swift.syntaxtype.attribute.builtin",
    "source.lang.swift.syntaxtype.keyword",
    "source.lang.swift.syntaxtype.number",
    "source.lang.swift.syntaxtype.doccomment",
    "source.lang.swift.syntaxtype.string",
    "source.lang.swift.syntaxtype.string_interpolation_anchor",
    "source.lang.swift.syntaxtype.attribute.id",
    "source.lang.swift.syntaxtype.buildconfig.keyword",
    "source.lang.swift.syntaxtype.buildconfig.id",
    "source.lang.swift.syntaxtype.comment.url",
    "source.lang.swift.syntaxtype.comment",
    "source.lang.swift.syntaxtype.doccomment.field"
]

extension File {
    fileprivate func unusedImports(compilerArguments: [String]) -> [String] {
        let syntaxMap = SyntaxMap(sourceKitResponse: Request.editorOpen(file: self).send())
        var imports = [String]()
        var usrs = [String]()
        var nextIsModuleImport = false
        for token in syntaxMap.tokens {
            if token.type == "source.lang.swift.syntaxtype.keyword",
                let substring = contents.bridge()
                    .substringWithByteRange(start: token.offset, length: token.length),
                substring == "import" {
                nextIsModuleImport = true
                continue
            }
            if syntaxTypesToSkip.contains(token.type) {
                continue
            }
            let cursorInfo = Request.cursorInfo(file: path!, offset: Int64(token.offset),
                                                arguments: compilerArguments).send()
            if nextIsModuleImport {
                if let importedModule = cursorInfo["key.modulename"] as? String,
                    cursorInfo["key.kind"] as? String == "source.lang.swift.ref.module" {
                    imports.append(importedModule)
                    nextIsModuleImport = false
                }
            } else {
                nextIsModuleImport = false
            }
            if let usr = cursorInfo["key.usr"] as? String {
                usrs.append(usr)
            }
        }
        return imports.filter { module in
            return !["Foundation", "Swift", "Dispatch"].contains(module) &&
                usrs.filter({ $0.contains(module) }).isEmpty
        }
    }
}
