//
//  UIDNamespaceTests.swift
//  SourceKitten
//
//  Created by Norio Nomura on 10/22/16.
//  Copyright (c) 2016 SourceKitten. All rights reserved.
//

#if !os(Linux)
import Foundation
import XCTest
@testable import SourceKittenFramework

class UIDNamespaceTests: XCTestCase {

    func testUIDNamespaceAreUpToDate() {
        guard let sourcekitdPath = loadedSourcekitdPath() else {
            XCTFail("fail to get sourcekitd image path")
            return
        }
        let imagePaths = [sourcekitdPath, getSourceKitServicePath(from: sourcekitdPath)]
        guard let uidStrings = extractUIDStrings(from: imagePaths) else {
            XCTFail("fail to get uid strings")
            return
        }
        let generatedUIDNamespace = createUIDNamespace(from: uidStrings)
        print(generatedUIDNamespace)
        let uidNamespacePath = "\(projectRoot)/Source/SourceKittenFramework/UIDNamespace+generated.swift"
        let existingUIDNamespace = try! String(contentsOfFile: uidNamespacePath)

        XCTAssertEqual(existingUIDNamespace, generatedUIDNamespace)

        // set this to true to overwrite existing UIDNamespace+generated.swift with the generated ones
        let overwrite = false
        if existingUIDNamespace != generatedUIDNamespace && overwrite {
            try! generatedUIDNamespace.data(using: .utf8)?.write(to: URL(fileURLWithPath: uidNamespacePath))
        }
    }
}

func loadedSourcekitdPath() -> String? {
    let library = toolchainLoader.load(path: "sourcekitd.framework/Versions/A/sourcekitd")
    let symbol = dlsym(library.handle, "sourcekitd_initialize")
    var info = dl_info()
    guard 0 != dladdr(symbol, &info) else { return nil }
    return String(cString: info.dli_fname)
}

func getSourceKitServicePath(from sourcekitdPath: String) -> String {
    let component = "XPCServices/SourceKitService.xpc/Contents/MacOS/SourceKitService"
    return URL(fileURLWithPath: sourcekitdPath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent(component)
        .path
}

func extractUIDStrings(from images: [String]) -> [String]? {
    let task = Process()
    task.launchPath = "/usr/bin/strings"
    task.arguments = images
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: .utf8) else {
        return nil
    }
    return output
        .components(separatedBy: .newlines)
        .filter { ($0.hasPrefix("source.") || $0.hasPrefix("key.")) && !$0.contains(" ") }
        .sorted()
}

func createUIDNamespace(from uidStrings: [String]) -> String {
    class Node {
        let name: String
        var children: [String:Node] = [:]

        init(name: String) { self.name = name }

        func checkChild(for name: String) -> Node {
            return children[name] ?? addChild(for: name)
        }

        func addChild(for name: String) -> Node {
            let child = Node(name: name)
            children[name] = child
            return child
        }

        func render(withIndent count: Int, namespaces: [String] = []) -> [String] {
            func tabs(_ count: Int) -> String { return String(repeating: "    ", count: count) }

            func escape(_ name: String) -> String {
                if type(of:self).keywords.contains(name) {
                    return "`\(name)`"
                }
                return name
            }

            let sortedChildren = children.keys.sorted().flatMap { children[$0] }

            if name.isEmpty {
                return Array(sortedChildren.flatMap{
                    $0.render(withIndent: count)
                })
            }

            let escapedName = escape(name)

            if children.isEmpty {
                let fullName = (namespaces + [name]).joined(separator: ".")
                return [tabs(count) + "public static let \(escapedName) = leaf(\"\(fullName)\")"]
            } else {
                let isNamespace = nil != sortedChildren.first { $0.children.isEmpty }
                let begining = isNamespace ? [
                    tabs(count) + "public struct \(escapedName): UIDNamespace {",
                    tabs(count + 1) + "public let uid: UID",
                    tabs(count + 1) + "public init(uid: UID) { self.uid = uid }",
                    tabs(count + 1) + "public static func ==(lhs: UID, rhs: \(escapedName)) -> Bool { return lhs == rhs.uid }",
                    tabs(count + 1) + "public static func ==(lhs: \(escapedName), rhs: UID) -> Bool { return rhs == lhs }",
                    tabs(count + 1) + "public static func ==(lhs: UID?, rhs: \(escapedName)) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }",
                    tabs(count + 1) + "public static func ==(lhs: \(escapedName), rhs: UID?) -> Bool { return rhs == lhs }",
                ] : [
                    tabs(count) + "public struct \(escapedName) {",
                ]
                let body =  Array(sortedChildren.flatMap{
                    $0.render(withIndent: count + 1, namespaces: namespaces + [name])
                })
                let ending = [tabs(count) + "}"]
                return begining + body + ending
            }
        }
        static var keywords: [String] = []
    }

    let keywordPrefix = "source.lang.swift.keyword."
    Node.keywords = uidStrings
        .filter { $0.hasPrefix(keywordPrefix) }
        .map { $0.replacingOccurrences(of: keywordPrefix, with: "") }

    let root = Node(name: "")
    uidStrings.forEach {
        let components = $0.components(separatedBy: ".")
        _ = components.reduce(root) { parent, name in
            parent.checkChild(for: name)
        }
    }
    return (["extension UID {"] + root.render(withIndent: 1) + ["}",""]).joined(separator: "\n")
}

#endif
