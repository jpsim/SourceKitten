//
//  UIDNamespaceTests.swift
//  SourceKitten
//
//  Created by Norio Nomura on 10/22/16.
//  Copyright (c) 2016 SourceKitten. All rights reserved.
//

import Foundation
import XCTest
@testable import SourceKittenFramework

class UIDNamespaceTests: XCTestCase {

    func testExpressibleByStringLiteral() {
        let keyRequest: UID.key = "key.request"
        XCTAssertEqual(keyRequest, UID.key.request)
        let keyKind: UID.key = ".kind"
        XCTAssertEqual(UID.key.kind, keyKind)

        do {
            let longNameByString: UID.source.lang.swift.keyword = "source.lang.swift.keyword.Any"
            XCTAssertEqual(longNameByString, UID.source.lang.swift.keyword.Any)

            let shortName: UID.source.lang.swift.keyword = .Any
            XCTAssertEqual(shortName, UID.source.lang.swift.keyword.Any)
        }

        do {
            // Use nested members with Fully Qualified Name
            let longNameByString: UID.source.lang.swift.decl = "source.lang.swift.decl.extension.class"
            XCTAssertEqual(longNameByString, UID.source.lang.swift.decl.extension.class)

            // We can't use short name by inference if nested
//            let shortName: UID.source.lang.swift.decl = .extension.class
//            XCTAssertEqual(shortNameByString, UID.source.lang.swift.decl.extension.class)

            // If string starting `.`, it is infered as member of namespace
            let shortNameByString: UID.source.lang.swift.decl = ".extension.class"
            XCTAssertEqual(shortNameByString, UID.source.lang.swift.decl.extension.class)

            // Equatable
            XCTAssertEqual(UID.source.lang.swift.decl.extension.class, ".extension.class")

            // `==` operator
            XCTAssertTrue(UID.source.lang.swift.decl.extension.class == ".extension.class")
        }
    }

//    func testUnknownUIDCausesPreconditionFailureOnDebugBuild() {
//        XCTAssertTrue(UID.key.request == ".unknown")
//    }

    func testUIDNamespaceAreUpToDate() {
        #if os(macOS)
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
            let uidNamespacePath = "\(projectRoot)/Source/SourceKittenFramework/UIDNamespace+generated.swift"
            let existingUIDNamespace = try! String(contentsOfFile: uidNamespacePath)

            XCTAssertEqual(existingUIDNamespace, generatedUIDNamespace)

            // set this to true to overwrite existing UIDNamespace+generated.swift with the generated ones
            let overwrite = false
            if existingUIDNamespace != generatedUIDNamespace && overwrite {
                try! generatedUIDNamespace.data(using: .utf8)?.write(to: URL(fileURLWithPath: uidNamespacePath))
            }
        #endif
    }
}

#if os(macOS)

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
    let uidStrings = output
        .components(separatedBy: .newlines)
        .filter { ($0.hasPrefix("source.") || $0.hasPrefix("key.")) && !$0.contains(" ") }
    return Set(uidStrings).sorted()
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
        root.renderExtensions() +
        renderKnownUIDs(from: uidStrings)
        ).joined(separator: "\n") + "\n"
}

func renderKnownUIDs(from UIDs: [String]) -> [String] {
    return ["#if DEBUG","let knownUIDs = [",] +
        UIDs.map({"    UID(\"\($0)\"),"}) +
        ["]","#endif"]
}

fileprivate class Node {
    weak var parent: Node? = nil
    let name: String
    var children: [String:Node] = [:]
    private var isDesiredType = false

    static var keywords: [String] = []

    init(name: String = "", parent: Node? = nil) {
        self.name = name
        self.parent = parent
    }

    /// Parse uid string
    ///
    /// - Parameter uidString: String
    func add(uidString string: String) {
        _ = node(for: string)
    }

    /// Set desired type by uid string
    ///
    /// - Parameter uidString: String
    func setDesiredType(for uidString: String) {
        node(for: uidString).isDesiredType = true
    }

    /// Render Structs
    ///
    /// - Returns: [String]
    func renderStructs() -> [String] {
        if name.isEmpty { return sortedChildren.flatMap { $0.renderStructs() } }

        let renderedChildren =  sortedChildren.flatMap { $0.renderStructs().map(indent) }

        if isDesiredType {
            let renderedProperties = sortedChildren.flatMap {
                $0.renderProperties().map(indent)
            }
            return [
                "public struct \(escapedName): UIDNamespace {",
                indent("public let uid: UID"),
                ] + renderedProperties + renderedChildren + ["}"]
        } else if !renderedChildren.isEmpty {
            return ["public struct \(escapedName) {"] + renderedChildren + ["}"]
        }
        return []
    }

    /// Render Extensions
    ///
    /// - Returns: [String]
    func renderExtensions() -> [String] {
        if name.isEmpty { return sortedChildren.flatMap { $0.renderExtensions() } }

        var result = [String]()
        if isDesiredType {
            result.append(contentsOf: ["extension UID.\(escapedFullyQualifiedName) {"])
            result.append(contentsOf: renderMethods().map(indent))
            result.append(contentsOf: ["}"])
        }

        let renderedChildren = sortedChildren.flatMap { $0.renderExtensions() }
        result.append(contentsOf: renderedChildren)

        return result
    }
    
    // MARK: - Private

    // escaping keywords with "`"
    private static func escape(_ name: String) -> String {
        return keywords.contains(name) ? "`\(name)`" : name
    }

    // MARK: - Model operations

    private func node(for uidString: String) -> Node {
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

    // MARK: - Renderer
    private func renderMethods() -> [String] {
        return [
            "public static func ==(lhs: UID.\(escapedFullyQualifiedName), rhs: UID.\(escapedFullyQualifiedName)) -> Bool { return lhs.uid == rhs.uid }",
            "public static func ==(lhs: UID, rhs: UID.\(escapedFullyQualifiedName)) -> Bool { return lhs == rhs.uid }",
            "public static func ==(lhs: UID.\(escapedFullyQualifiedName), rhs: UID) -> Bool { return rhs == lhs }",
            "public static func ==(lhs: UID?, rhs: UID.\(escapedFullyQualifiedName)) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }",
            "public static func ==(lhs: UID.\(escapedFullyQualifiedName), rhs: UID?) -> Bool { return rhs == lhs }",
            // FIXME: Remove following when https://bugs.swift.org/browse/SR-3173 will be resolved.
            "public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }",
            "public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }",
            "public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }",
        ]
    }

    private func renderProperties() -> [String] {
        if name.isEmpty { return sortedChildren.flatMap { $0.renderProperties() } }

        if isDesiredType { return [] }

        if children.isEmpty {
            return [
                "/// \"\(fullyQualifiedName)\"",
                "public static let \(escapedName): UID.\(desiredType.escapedFullyQualifiedName) = \"\(fullyQualifiedName)\"",
            ]
        } else {
            let renderedProperties = sortedChildren.flatMap {
                $0.renderProperties().map(indent)
            }
            return renderedProperties.isEmpty ? [] : ["public struct \(escapedName) {"] + renderedProperties + ["}"]
        }
    }

    // MARK: - Computed properties

    private var desiredType: Node {
        guard let parent = parent else {
            fatalError("Can't find desired type!")
        }
        return parent.isDesiredType ? parent : parent.desiredType
    }

    private var escapedFullyQualifiedName: String {
        return namespaces.map(type(of:self).escape).joined(separator: ".")
    }

    private var escapedName: String {
        return type(of: self).escape(name)
    }

    private var fullyQualifiedName: String {
        return namespaces.joined(separator: ".")
    }

    private var namespaces: [String] {
        let parents = parent?.namespaces ?? []
        let current = name.isEmpty ? [] : [name]
        return parents + current
    }

    private var sortedChildren: [Node] {
        return children.keys.sorted().flatMap { children[$0] }
    }
}

#endif
