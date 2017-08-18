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
        let args = ["-workspace", "Lyft.xcworkspace", "-scheme", "Lyft"]
        if let module = Module(xcodeBuildArguments: args, name: "Lyft") {
            // Find unused imports
//            for file in module.sourceFiles {
//                let unusedImports = File(path: file)!.unusedImports(compilerArguments: module.compilerArguments)
//                if !unusedImports.isEmpty {
//                    print("Unused imports in \(file.bridge().lastPathComponent):")
//                    for module in unusedImports {
//                        print("- \(module)")
//                    }
//                }
//            }

            // Find `private` or `fileprivate` declarations that aren't used within that file
//            var fileIndex = 1
//            for file in module.sourceFiles where
//                file != "/Users/jp/Projects/SourceKitten/Source/SourceKittenFramework/File.swift" &&
//                file != "/Users/jp/Projects/SourceKitten/Source/SourceKittenFramework/String+SourceKitten.swift" &&
//                file != "/Users/jp/Projects/SourceKitten/.build/checkouts/Yams.git-8068124914099325722/Sources/Yams/Resolver.swift" &&
//                file != "/Users/jp/Projects/SwiftLint/Source/SwiftLintFramework/Extensions/File+SwiftLint.swift" &&
//                file != "/Users/jp/Projects/SwiftLint/Source/SwiftLintFramework/Models/LinterCache.swift" &&
//                file != "/Users/jp/Projects/SwiftLint/Source/SwiftLintFramework/Models/RuleList.swift" &&
//                file != "/Users/jp/Projects/SwiftLint/Source/SwiftLintFramework/Rules/NimbleOperatorRule.swift" {
//                let progress = "(\(fileIndex)/\(module.sourceFiles.count))"
//                fileIndex += 1
//                print("checking for unused private/fileprivate declarations in '\(file)' \(progress)")
//                let file = File(path: file)!
//                let allCursorInfo = file.allCursorInfo(compilerArguments: module.compilerArguments)
//                let privateDeclarationUSRs = File.privateDeclarationUSRs(allCursorInfo: allCursorInfo)
//                let refUSRs = File.allRefUSRs(allCursorInfo: allCursorInfo)
//                let unusedPrivateDeclarations = Set(privateDeclarationUSRs).subtracting(refUSRs)
//                if !unusedPrivateDeclarations.isEmpty {
//                    print("Unused private declarations in \(file.path!.bridge().lastPathComponent):")
//                    print(unusedPrivateDeclarations)
//                }
//            }

            // Find `internal` declarations that should be `private` or `fileprivate`
            var internalDeclarationsPerFile = [String: [String]]()
            var refsPerFile = [String: [String]]()
            var idx = 0
            for file in module.sourceFiles {
                idx += 1
                print("\(file.bridge().lastPathComponent) (\(idx)/\(module.sourceFiles.count))")
                let filesToSkip = [
                    ""
                ]
                if filesToSkip.contains(file) {
                    print("skipping")
                    continue
                }
                let allCursorInfo = File(path: file)!.allCursorInfo(compilerArguments: module.compilerArguments)
                internalDeclarationsPerFile[file] = File.internalDeclarationUSRs(allCursorInfo: allCursorInfo)
                refsPerFile[file] = File.allRefUSRs(allCursorInfo: allCursorInfo)
            }
            if let testsModule = Module(spmName: moduleName + "Tests") {
                idx = 0
                for file in testsModule.sourceFiles {
                    idx += 1
                    print("\(file.bridge().lastPathComponent) (\(idx)/\(testsModule.sourceFiles.count))")
                    let filesToSkip = [
                        ""
                    ]
                    if filesToSkip.contains(file) {
                        print("skipping")
                        continue
                    }
                    let allCursorInfo = File(path: file)!.allCursorInfo(compilerArguments: testsModule.compilerArguments)
                    refsPerFile[file] = File.allRefUSRs(allCursorInfo: allCursorInfo)
                }
            }
            for (file, internalDeclarations) in internalDeclarationsPerFile {
                var copy = refsPerFile
                copy.removeValue(forKey: file)
                let nonFileRefs = Array(copy.values).flatMap({ $0 })
                for decl in internalDeclarations where !nonFileRefs.contains(decl) {
                    print("\(file.bridge().lastPathComponent) decl is internal but not referenced in other files " +
                          "from the module or its tests:")
                    print(decl)
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
    fileprivate func allCursorInfo(compilerArguments: [String]) -> [[String: SourceKitRepresentable]] {
        // swiftlint:disable number_separator
        // swiftlint:disable line_length
        let filesToSkip = [
            "": [0]
        ]
        let editorOpen = Request.editorOpen(file: self).send()
        let syntaxMap = SyntaxMap(sourceKitResponse: editorOpen)
        return syntaxMap.tokens.flatMap { token in
            guard !syntaxTypesToSkip.contains(token.type) else {
                return nil
            }
            if let offsetsToSkip = filesToSkip[path!], offsetsToSkip.contains(token.offset) {
                return nil
            }
            var cursorInfo = Request.cursorInfo(file: path!, offset: Int64(token.offset),
                                                arguments: compilerArguments).send()
            if let acl = File.aclAtOffset(Int64(token.offset), editorOpen: editorOpen) {
                cursorInfo["key.accessibility"] = acl
            }
            return cursorInfo
        }
    }

    fileprivate static func privateDeclarationUSRs(allCursorInfo: [[String: SourceKitRepresentable]]) -> [String] {
        var usrs = [String]()
        let privateACLs = ["source.lang.swift.accessibility.private", "source.lang.swift.accessibility.fileprivate"]
        for cursorInfo in allCursorInfo {
            if let usr = cursorInfo["key.usr"] as? String,
                let kind = cursorInfo["key.kind"] as? String,
                kind.contains("source.lang.swift.decl"),
                let accessibility = cursorInfo["key.accessibility"] as? String,
                privateACLs.contains(accessibility) {
                usrs.append(usr)
            }
        }
        return usrs
    }

    fileprivate static func internalDeclarationUSRs(allCursorInfo: [[String: SourceKitRepresentable]]) -> [String] {
        var usrs = [String]()
        for cursorInfo in allCursorInfo {
            if let usr = cursorInfo["key.usr"] as? String,
                let kind = cursorInfo["key.kind"] as? String,
                kind.contains("source.lang.swift.decl"),
                let accessibility = cursorInfo["key.accessibility"] as? String,
                accessibility == "source.lang.swift.accessibility.internal" {
                usrs.append(usr)
            }
        }
        return usrs
    }

    fileprivate static func aclAtOffset(_ offset: Int64, editorOpen: [String: SourceKitRepresentable]) -> String? {
        if let nameOffset = editorOpen["key.nameoffset"] as? Int64,
            nameOffset == offset,
            let acl = editorOpen["key.accessibility"] as? String {
            return acl
        }
        if let sub = editorOpen[SwiftDocKey.substructure.rawValue] as? [SourceKitRepresentable] {
            let sub2 = sub.map({ $0 as! [String: SourceKitRepresentable] })
            for subsub in sub2 {
                if let acl = File.aclAtOffset(offset, editorOpen: subsub) {
                    return acl
                }
            }
        }
        return nil
    }

    fileprivate static func allRefUSRs(allCursorInfo: [[String: SourceKitRepresentable]]) -> [String] {
        var usrs = [String]()
        for cursorInfo in allCursorInfo {
            if let usr = cursorInfo["key.usr"] as? String,
                let kind = cursorInfo["key.kind"] as? String,
                kind.contains("source.lang.swift.ref") {
                usrs.append(usr)
            }
        }
        return usrs
    }

    fileprivate func allUSRs(compilerArguments: [String]) -> [String] {
        let syntaxMap = SyntaxMap(sourceKitResponse: Request.editorOpen(file: self).send())
        var usrs = [String]()
        for token in syntaxMap.tokens where !syntaxTypesToSkip.contains(token.type) {
            let cursorInfo = Request.cursorInfo(file: path!, offset: Int64(token.offset),
                                                arguments: compilerArguments).send()
            if let usr = cursorInfo["key.usr"] as? String {
                print(toJSON(cursorInfo))
                usrs.append(usr)
            }
        }
        return usrs
    }

    fileprivate func unusedImports(compilerArguments: [String]) -> [String] {
        if (path ?? "").contains("File.swift") ||
            (path ?? "").contains("String+SourceKitten.swift") {
            return []
        }
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
