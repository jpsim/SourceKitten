//
//  DocCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import CSass
import Commandant
import Foundation
import Result
import SourceKittenFramework

extension FileManager {
    func isFile(path: String) -> Bool {
        var isDirectoryObjC: ObjCBool = false
        if fileExists(atPath: path, isDirectory: &isDirectoryObjC) {
            #if os(Linux)
                return !isDirectoryObjC
            #else
                return !isDirectoryObjC.boolValue
            #endif
        }
        return false
    }

    func allFiles(inPath path: String) -> [String] {
        let rootPath = currentDirectoryPath
        let absolutePath = path.bridge()
            .absolutePathRepresentation(rootDirectory: rootPath).bridge()
            .standardizingPath

        // if path is a file, it won't be returned in `enumerator(atPath:)`
        if isFile(path: absolutePath) {
            return [absolutePath]
        }

        return enumerator(atPath: absolutePath)?.flatMap { element in
            if let element = element as? String {
                return absolutePath.bridge().appendingPathComponent(element)
            }
            return nil
        } ?? []
    }
}

private func sass2css(path: String) -> String {
    let context = sass_make_file_context(path)
    defer { sass_delete_file_context(context) }
    sass_compile_file_context(context)
    if let errorCString = sass_context_get_error_message(context) {
        fatalError(String(cString: errorCString))
    }
    return String(cString: sass_context_get_output_string(context)!)
}

struct DocCommand: CommandProtocol {
    let verb = "doc"
    let function = "Print Swift or Objective-C docs as JSON or HTML"

    struct Options: OptionsProtocol {
        let spmModule: String
        let singleFile: Bool
        let moduleName: String
        let objc: Bool
        let html: Bool
        let arguments: [String]

        // swiftlint:disable:next line_length
        static func create(spmModule: String) -> (_ singleFile: Bool) -> (_ moduleName: String) -> (_ objc: Bool) -> (_ html: Bool) -> (_ arguments: [String]) -> Options {
            return { singleFile in { moduleName in { objc in { html in { arguments in
                self.init(spmModule: spmModule, singleFile: singleFile, moduleName: moduleName, objc: objc, html: html, arguments: arguments)
            }}}}}
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
                <*> mode <| Option(key: "html", defaultValue: false,
                                   usage: "generate static HTML documentation site rather than output JSON")
                <*> mode <| Argument(defaultValue: [],
                                     usage: "Arguments list that passed to xcodebuild. If `-` prefixed argument exists, place ` -- ` before that.")
        }
    }

    func run(_ options: Options) -> Result<(), SourceKittenError> {
        let themeDir = "/Users/jp/Projects/jazzy/lib/jazzy/themes/apple"
        let assetsDir = themeDir + "/assets"
        let outputDir = "docs"
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(atPath: outputDir)
            try fileManager.copyItem(atPath: assetsDir, toPath: outputDir)
            for file in fileManager.allFiles(inPath: outputDir) {
                if file.contains(".css.scss"), let cssData = sass2css(path: file).data(using: .utf8) {
                    try cssData.write(to: URL(fileURLWithPath: file).deletingPathExtension())
                    try fileManager.removeItem(atPath: file)
                }
            }
        } catch {
            fatalError("\(error)")
        }
        return .success()
    }

    func runSPMModule(moduleName: String) -> Result<(), SourceKittenError> {
        if let docs = Module(spmName: moduleName)?.docs {
            print(docs)
            return .success()
        }
        return .failure(.docFailed)
    }

    func runSwiftModule(moduleName: String?, args: [String]) -> Result<(), SourceKittenError> {
        let module = Module(xcodeBuildArguments: args, name: moduleName)

        if let docs = module?.docs {
            print(docs)
            return .success()
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
            return .success()
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
        return .success()
        #endif
    }
}
