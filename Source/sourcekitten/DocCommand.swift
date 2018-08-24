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
import Yams

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
        return parallelMap(transform: transform).compactMap { $0 }
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

func filterBadArgs(_ args: [String]) -> [String] {
    let filteredArguments = args[4...]
        .filter { $0 != "-incremental" }
        .filter { $0 != "-parseable-output" }
        .filter { $0 != "-output-file-map" }
        .filter { !$0.hasSuffix("OutputFileMap.json") }
    return Array(filteredArguments)
}

func parseXCBuildLog(_ data: Data) -> [String: [String]] {
    let str = String(data: data, encoding: .utf8)!
    let yaml = try! Yams.load(yaml: str) as! [String: Any]
    let commands = yaml["commands"] as! [String: Any]
    var fileToArgs = [String: [String]]()
    for (key, value) in commands where key.contains("com.apple.xcode.tools.swift.compiler") {
        let valueDictionary = value as! [String: Any]
        let inputs = valueDictionary["inputs"] as! [String]
        let args = valueDictionary["args"] as! [String]
        let filteredArgs = filterBadArgs(args)
        assert(filteredArgs.first!.hasSuffix("swiftc"))
        for input in inputs {
            if input.hasSuffix(".swift") {
                fileToArgs[input] = filteredArgs
            }
        }
    }

    return fileToArgs
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
        return runFinUnusedDeclarations()
    }

    func runFinUnusedDeclarations() -> Result<(), SourceKittenError> {
        let logPath = "/Users/jsimard/Projects/Lyft-iOS/build.noindex/Build/Intermediates.noindex/XCBuildData/6654a23a6ba306fae1d55daa7088d259-manifest.xcbuild"
        guard let data = FileManager.default.contents(atPath: logPath) else {
            fatalError("couldn't read log file at path '\(logPath)'")
        }

        let log = parseXCBuildLog(data)
        // Find `internal`, `private` or `fileprivate` declarations that aren't used within that module
        // FIXME: declarations used in string interpolation not counted
        // e.g. in SuggestedStopPresenter.swift (557)
        var fileIndex = 1
        let files = Array(log.keys)
        let allCursorInfo = files.parallelMap { path -> [[String: SourceKitRepresentable]] in
            DispatchQueue.main.async {
                let progress = "(\(fileIndex)/\(files.count))"
                fileIndex += 1
                print("getting all cursor info in '\(path)' \(progress)")
            }
            let file = File(path: path)!
            return file.allCursorInfo(compilerArguments: log[path]!)
        }
        let allDeclarations = allCursorInfo.flatMap { allCursorInfo in
            return File.declarationUSRs(allCursorInfo: allCursorInfo, acls: ["internal", "private", "fileprivate"])
        }
        let allReferences = allCursorInfo.flatMap(File.allRefUSRs)
        let unusedDeclarations = Set(allDeclarations.map({$0.0})).subtracting(allReferences)
        for cursorInfo in allDeclarations where unusedDeclarations.contains(cursorInfo.0) {
            print(cursorInfo.1)
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
        let editorOpen = try! Request.editorOpen(file: self).send()
        let syntaxMap = SyntaxMap(sourceKitResponse: editorOpen)
        return syntaxMap.tokens.compactMap { token in
            var cursorInfo = try! Request.cursorInfo(file: path!, offset: Int64(token.offset),
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
        let syntaxMap = SyntaxMap(sourceKitResponse: try! Request.editorOpen(file: self).send())
        var usrs = [String]()
        for token in syntaxMap.tokens where !syntaxTypesToSkip.contains(token.type) {
            let cursorInfo = try! Request.cursorInfo(file: path!, offset: Int64(token.offset),
                                                     arguments: compilerArguments).send()
            if let usr = cursorInfo["key.usr"] as? String {
                print(toJSON(cursorInfo))
                usrs.append(usr)
            }
        }
        return usrs
    }

    fileprivate func unusedImports(compilerArguments: [String]) -> [String] {
        let syntaxMap = SyntaxMap(sourceKitResponse: try! Request.editorOpen(file: self).send())
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
            let cursorInfo = try! Request.cursorInfo(file: path!, offset: Int64(token.offset),
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
