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

fileprivate let tab = "    "
func indent(_ string: String) -> String {
    return tab + string
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

fileprivate let desiredTypes = [
    "key",
    "source.availability.platform",
    "source.codecompletion",
    "source.decl.attribute",
    "source.diagnostic.severity",
    "source.diagnostic.stage.swift",
    "source.lang.swift",
    "source.lang.swift.accessibility",
    "source.lang.swift.attribute",
    "source.lang.swift.codecomplete",
    "source.lang.swift.decl",
    "source.lang.swift.expr",
    "source.lang.swift.import.module",
    "source.lang.swift.keyword",
    "source.lang.swift.literal",
    "source.lang.swift.ref",
    "source.lang.swift.stmt",
    "source.lang.swift.structure.elem",
    "source.lang.swift.syntaxtype",
    "source.notification",
    "source.request",
]

func createUIDNamespace(from uidStrings: [String]) -> String {
    let keywordPrefix = "source.lang.swift.keyword."
    Node.keywords = uidStrings
        .filter { $0.hasPrefix(keywordPrefix) }
        .map { $0.replacingOccurrences(of: keywordPrefix, with: "") }

    let root = Node(name: "")
    uidStrings.forEach(root.add)
    desiredTypes.forEach(root.setDesiredType)

    return (["extension UID {"] +
        root.renderStructs().map(indent) +
        ["}",""] +
        root.renderExtensions()
        ).joined(separator: "\n")
}

fileprivate class Node {
    weak var parent: Node? = nil
    let name: String
    var children: [String:Node] = [:]
    var isDesiredType = false

    init(name: String = "", parent: Node? = nil) {
        self.name = name
        self.parent = parent
    }

    var escapedName: String {
        return type(of: self).escape(name)
    }

    var namespaces: [String] {
        let parents = parent?.namespaces ?? []
        let current = name.isEmpty ? [] : [name]
        return parents + current
    }

    var fullyQualifiedName: String {
        return namespaces.joined(separator: ".")
    }

    var escapedFullyQualifiedName: String {
        return namespaces.map(type(of:self).escape).joined(separator: ".")
    }

    var sortedChildren: [Node] {
        return children.keys.sorted().flatMap { children[$0] }
    }

    /// Parse uid string
    ///
    /// - Parameter uidString: String
    func add(uidString string: String) {
        _ = node(for: string)
    }

    func setDesiredType(for uidString: String) {
        node(for: uidString).isDesiredType = true
    }

    func node(for uidString: String) -> Node {
        return uidString.components(separatedBy: ".").reduce(self) { parent, name in
            parent.checkChild(for: name)
        }
    }

    private func checkChild(for name: String) -> Node {
        return children[name] ?? addChild(for: name)
    }

    private func addChild(for name: String) -> Node {
        let child = Node(name: name, parent: self)
        children[name] = child
        return child
    }

    /// Render Structs
    func renderStructs() -> [String] {
        if name.isEmpty { return sortedChildren.flatMap { $0.renderStructs() } }

        let beginning = isDesiredType ? [
            "public struct \(escapedName): UIDNamespace {",
            indent("public let uid: UID"),
            indent("public init(uid: UID) { self.uid = uid }"),
            indent("public static func ==(lhs: UID, rhs: \(escapedName)) -> Bool { return lhs == rhs.uid }"),
            indent("public static func ==(lhs: \(escapedName), rhs: UID) -> Bool { return rhs == lhs }"),
            indent("public static func ==(lhs: UID?, rhs: \(escapedName)) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }"),
            indent("public static func ==(lhs: \(escapedName), rhs: UID?) -> Bool { return rhs == lhs }"),
            // FIXME: Remove following when https://bugs.swift.org/browse/SR-3173 will be resolved.
            indent("public init(stringLiteral value: String) { self.init(uid: UID(value)) }"),
            indent("public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }"),
            indent("public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }"),
            ] : ["public struct \(escapedName) {"]
        let renderedChildren =  sortedChildren.flatMap { $0.renderStructs().map(indent) }
        let ending = ["}"]

        if isDesiredType || !renderedChildren.isEmpty {
            return beginning + renderedChildren + ending
        } else {
            return []
        }
    }

    /// Render Extensions
    func renderExtensions() -> [String] {
        if name.isEmpty { return sortedChildren.flatMap { $0.renderExtensions() } }

        var result = [String]()
        if isDesiredType {
            let renderedProperties = sortedChildren.flatMap {
                $0.renderProperties().map(indent)
            }
            result.append(contentsOf: ["extension UID.\(escapedFullyQualifiedName) {"])
            result.append(contentsOf: renderedProperties)
            result.append(contentsOf: ["}"])
        }

        let renderedChildren = sortedChildren.flatMap { $0.renderExtensions() }
        result.append(contentsOf: renderedChildren)

        return result
    }

    var desiredType: Node {
        guard let parent = parent else {
            fatalError("Can't find desired type!")
        }
        return parent.isDesiredType ? parent : parent.desiredType
    }

    func renderProperties() -> [String] {
        if name.isEmpty { return sortedChildren.flatMap { $0.renderProperties() } }

        if isDesiredType { return [] }

        if children.isEmpty {
            return ["public static let \(escapedName): UID.\(desiredType.escapedFullyQualifiedName) = \"\(fullyQualifiedName)\""]
        } else {
            let renderedProperties = sortedChildren.flatMap {
                $0.renderProperties().map(indent)
            }
            return renderedProperties.isEmpty ? [] : ["public struct \(escapedName) {"] + renderedProperties + ["}"]
        }
    }

    // escaping keywords with "`"
    static var keywords: [String] = []
    static func escape(_ name: String) -> String {
        return keywords.contains(name) ? "`\(name)`" : name
    }
}

#endif
