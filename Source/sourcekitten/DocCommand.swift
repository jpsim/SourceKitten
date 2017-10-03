//
//  DocCommand.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import Dispatch
import Foundation
import Result
import SourceKittenFramework

private extension Array {
    func parallelForEach(block: @escaping (Int, Element) -> Void) {
        DispatchQueue.concurrentPerform(iterations: count) { index in
            block(index, self[index])
        }
    }

    func parallelFlatMap<T>(transform: @escaping ((Element) -> [T])) -> [T] {
        return parallelMap(transform: transform).flatMap { $0 }
    }

    func parallelFlatMap<T>(transform: @escaping ((Element) -> T?)) -> [T] {
        return parallelMap(transform: transform).flatMap { $0 }
    }

    func parallelMap<T>(transform: @escaping ((Element) -> T)) -> [T] {
        var result = [(Int, T)]()
        result.reserveCapacity(count)

        let queueLabelPrefix = "io.realm.SwiftLintFramework.map.\(NSUUID().uuidString)"
        let resultAccumulatorQueue = DispatchQueue(label: "\(queueLabelPrefix).resultAccumulator")
        DispatchQueue.concurrentPerform(iterations: count) { index in
            let jobIndexAndResults = (index, transform(self[index]))
            resultAccumulatorQueue.sync {
                result.append(jobIndexAndResults)
            }
        }
        return result.sorted { $0.0 < $1.0 }.map { $0.1 }
    }
}

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
        let schemes = [
//            "API",
//            "CoreAPI-iOS",
//            "LocationFeedbackNotification",
            "Lyft",
//            "LyftAnalytics",
//            "LyftKit-iOS",
//            "LyftNetworking-iOS",
//            "LyftUI",
//            "Models",
//            "RideUpdateNotification",
//            "Siri",
//            "SiriUI"
        ]
        for scheme in schemes {
            autoreleasepool {
                print("Building \(scheme)")
                let moduleName = String(scheme.split(separator: "-")[0])
                let args = ["-workspace", "Lyft.xcworkspace", "-scheme", scheme]
                if let module = Module(xcodeBuildArguments: args, name: moduleName) {
                    // Find `internal`, `private` or `fileprivate` declarations that aren't used within that module
                    // FIXME: declarations used in string interpolation not counted
                    // e.g. in SuggestedStopPresenter.swift (557)
                    var fileIndex = 1
                    let files = module.sourceFiles
                    let allCursorInfo = files.parallelMap { file -> [[String: SourceKitRepresentable]] in
                        DispatchQueue.main.async {
                            let progress = "(\(fileIndex)/\(files.count))"
                            fileIndex += 1
                            print("getting all cursor info in '\(file)' \(progress)")
                        }
                        let file = File(path: file)!
                        return file.allCursorInfo(compilerArguments: module.compilerArguments)
                    }
                    let allDeclarations = allCursorInfo.flatMap { allCursorInfo in
                        return File.declarationUSRs(allCursorInfo: allCursorInfo, acls: ["internal", "private", "fileprivate"])
                    }
                    let allReferences = allCursorInfo.flatMap { allCursorInfo in
                        return File.allRefUSRs(allCursorInfo: allCursorInfo)
                    }
                    let unusedDeclarations = Set(allDeclarations.map({$0.0})).subtracting(allReferences)
                    print("Unused declarations in \(moduleName):")
                    for cursorInfo in allDeclarations where unusedDeclarations.contains(cursorInfo.0) {
                        print(cursorInfo.1)
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
    fileprivate func allCursorInfo(compilerArguments: [String]) -> [[String: SourceKitRepresentable]] {
        let editorOpen = Request.editorOpen(file: self).send()
        let syntaxMap = SyntaxMap(sourceKitResponse: editorOpen)
        return syntaxMap.tokens.flatMap { token in
            var cursorInfo = Request.cursorInfo(file: path!, offset: Int64(token.offset),
                                                arguments: compilerArguments).send()
            if let acl = File.aclAtOffset(Int64(token.offset), editorOpen: editorOpen) {
                cursorInfo["key.accessibility"] = acl
            }
            cursorInfo["jp.offset"] = Int64(token.offset)
            return cursorInfo
        }
    }

    fileprivate static func declarationUSRs(allCursorInfo: [[String: SourceKitRepresentable]],
                                            acls: [String]) -> [(String, String)] {
        var usrs = [(String, String)]()
        let fullACLs = acls.map { "source.lang.swift.accessibility.\($0)" }
        for cursorInfo in allCursorInfo {
            if let usr = cursorInfo["key.usr"] as? String,
                let kind = cursorInfo["key.kind"] as? String,
                kind.contains("source.lang.swift.decl"),
                // Skip initializers since we can't reliably detect if they're used.
                kind != "source.lang.swift.decl.function.constructor",
                // Skip `deinit` methods since those are never invoked directly anyway.
                kind != "source.lang.swift.decl.function.destructor",
                // Skip enum cases since those are listed as 'internal' even when they're public
                kind != "source.lang.swift.decl.enumelement",
                let accessibility = cursorInfo["key.accessibility"] as? String,
                fullACLs.contains(accessibility) {
                // Skip declarations marked as @IBOutlet, @IBAction or @IBInspectable
                // since those might not be referenced in code, but only in Interface Builder
                if let annotatedDecl = cursorInfo["key.annotated_decl"] as? String,
                    ["@IBOutlet", "@IBAction", "@IBInspectable", "@objc"].contains(where: annotatedDecl.contains) {
                    continue
                }
                // Skip declarations that override another. This works for both subclass overrides &
                // protocol extension overrides.
                if cursorInfo["key.overrides"] != nil {
                    continue
                }
                // Skip declarations with related declarations, since those might be protocol declarations
                if cursorInfo["key.related_decls"] != nil {
                    continue
                }
                usrs.append((usr, toJSON(cursorInfo)))
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
                    continue
                }
            } else {
                nextIsModuleImport = false
            }
            if let usr = cursorInfo["key.modulename"] as? String {
                if usr.contains("UIImage") {
//                    print("cursorInfo: \(toJSON(cursorInfo))")
                }
                usrs += usr.split(separator: ".").map({ String($0) })
            }
        }
        return imports.filter { module in
            return !["Foundation", "Swift", "Dispatch"].contains(module) &&
                !usrs.contains(module)
        }
    }
}
