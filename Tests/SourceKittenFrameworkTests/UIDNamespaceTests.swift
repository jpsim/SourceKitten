//
//  UIDNamespaceTests.swift
//  SourceKitten
//
//  Created by Norio Nomura on 10/22/16.
//  Copyright (c) 2016 SourceKitten. All rights reserved.
//

#if os(Linux)
import Glibc
#endif
import Foundation
import XCTest
@testable import SourceKittenFramework

class UIDNamespaceTests: XCTestCase {

    func testExpressibleByStringLiteral() {
        let keyRequest: UID.Key = "key.request"
        XCTAssertEqual(keyRequest, .request)
        let keyKind: UID.Key = ".kind"
        XCTAssertEqual(UID.Key.kind, keyKind)

        // Equatable
        do {
            // Use Fully Qualified Name
            XCTAssertEqual(UID.SourceLangSwiftDecl.extensionClass, "source.lang.swift.decl.extension.class")

            // Use short name with infering prefix
            XCTAssertEqual(UID.SourceLangSwiftDecl.extensionClass, ".extension.class")
        }

        // `==` operator
        do {
            // Compare with StringLiteral(Fully Qualified Name)
            XCTAssertTrue(UID.SourceLangSwiftDecl.extensionClass == "source.lang.swift.decl.extension.class")

            // Compare with StringLiteral(infering prefix)
            XCTAssertTrue(UID.SourceLangSwiftDecl.extensionClass == ".extension.class")

            // Compare with UID
            XCTAssertTrue(UID.SourceLangSwiftDecl.extensionClass == UID("source.lang.swift.decl.extension.class"))
        }
    }

//    func testUnknownUIDCausesPreconditionFailureOnDebugBuild() {
//        XCTAssertTrue(UID.Key.request == ".unknown")
//    }

    func testUIDNamespaceAreUpToDate() {
        guard let sourcekitdPath = loadedSourcekitdPath() else {
            XCTFail("fail to get sourcekitd image path")
            return
        }
        #if os(Linux)
            let imagePaths = [sourcekitdPath]
        #else
            let imagePaths = [sourcekitdPath, getSourceKitServicePath(from: sourcekitdPath)]
        #endif
        guard let uidStrings = extractUIDStrings(from: imagePaths) else {
            XCTFail("fail to get uid strings")
            return
        }
        let generatedUIDNamespace = createExtensionOfUID(from: uidStrings)
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


extension UIDNamespaceTests {
    static var allTests: [(String, (UIDNamespaceTests) -> () throws -> Void)] {
        return [
            ("testExpressibleByStringLiteral", testExpressibleByStringLiteral),
            // FIXME: https://bugs.swift.org/browse/SR-3250
//            ("testUIDNamespaceAreUpToDate", testUIDNamespaceAreUpToDate),
        ]
    }
}

// MARK: - testUIDNamespaceAreUpToDate helper

fileprivate func loadedSourcekitdPath() -> String? {
    #if os(Linux)
        // FIXME: https://bugs.swift.org/browse/SR-3250
        fatalError()
//        let library = toolchainLoader.load(path: "libsourcekitdInProc.so")
//        let symbol = dlsym(library.handle, "sourcekitd_initialize")
//        var info = dl_info()
//        guard 0 != dladdr(symbol, &info) else { return nil }
//        return String(cString: info.dli_fname)
    #else
        let library = toolchainLoader.load(path: "sourcekitd.framework/Versions/A/sourcekitd")
        let symbol = dlsym(library.handle, "sourcekitd_initialize")
        var info = dl_info()
        guard 0 != dladdr(symbol, &info) else { return nil }
        return String(cString: info.dli_fname)
    #endif
}

fileprivate func getSourceKitServicePath(from sourcekitdPath: String) -> String {
    let component = "XPCServices/SourceKitService.xpc/Contents/MacOS/SourceKitService"
    return URL(fileURLWithPath: sourcekitdPath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent(component)
        .path
}

fileprivate let tab = "    "
fileprivate func indent(_ string: String) -> String {
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

fileprivate func createExtensionOfUID(from uidStrings: [String]) -> String {
    let keywordPrefix = "source.lang.swift.keyword."
    Namespace.keywords = uidStrings
        .filter { $0.hasPrefix(keywordPrefix) }
        .map { $0.replacingOccurrences(of: keywordPrefix, with: "") }

    let namespaces = desiredTypes.sorted(by: >).map(Namespace.init)
    uidStrings.forEach { uidString in
        XCTAssertTrue(
            namespaces.contains { $0.append(child: uidString) },
            "Unkown uid detected: \(uidString)"
        )
    }

    let sortedNamespaces = namespaces.sorted(by: { $0.name < $1.name })
    let enums = ["extension UID {"] +
        sortedNamespaces.flatMap({$0.renderEnum()}).map(indent) +
        ["}",""]
    let extensions = sortedNamespaces.flatMap({$0.renderExtension()})
    let knownUIDs = renderKnownUIDs(from: uidStrings)
    return (enums + extensions + knownUIDs).joined(separator: "\n") + "\n"
}

fileprivate class Namespace {
    let name: String

    static var keywords: [String] = []

    init(name: String) {
        self.name = name
    }

    func append(child uidString: String) -> Bool {
        if uidString.hasPrefix(name + ".") {
            children.append(uidString)
            return true
        }
        return false
    }

    func renderEnum() -> [String] {
        return ["public struct \(name.upperCamelCase) {",
            indent("public let uid: UID")] +
            children.flatMap(render).map(indent) +
            ["}"]
    }

    func renderExtension() -> [String] {
        return ["extension UID.\(typeName): UIDNamespace {",
            indent("public static let __uid_prefix = \"\(name)\"")] +
            renderMethods().map(indent) +
            ["}"]
    }

    // Private

    private var children: [String] = []

    private func removePrefix(from uidString: String) -> String {
        return uidString.replacingOccurrences(of: name + ".", with: "")
    }

    private func render(child: String) -> [String] {
        let property = type(of: self).escape(removePrefix(from: child).lowerCamelCase)
        return [
            "/// \(child)",
            "public static let \(property): \(name.upperCamelCase) = \"\(child)\"",
        ]
    }

    private func renderMethods() -> [String] {
        return [
            "public static func ==(lhs: UID.\(typeName), rhs: UID.\(typeName)) -> Bool { return lhs.uid == rhs.uid }",
            "public static func ==(lhs: UID, rhs: UID.\(typeName)) -> Bool { return lhs == rhs.uid }",
            "public static func ==(lhs: UID.\(typeName), rhs: UID) -> Bool { return rhs == lhs }",
            "public static func ==(lhs: UID?, rhs: UID.\(typeName)) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }",
            "public static func ==(lhs: UID.\(typeName), rhs: UID?) -> Bool { return rhs == lhs }",
            // FIXME: Remove following when https://bugs.swift.org/browse/SR-3173 will be resolved.
            "public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }",
            "public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }",
            "public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }",
        ]
    }

    private var typeName: String {
        return name.upperCamelCase
    }

    // escaping keywords with "`"
    private static func escape(_ name: String) -> String {
        return keywords.contains(name) ? "`\(name)`" : name
    }
}

fileprivate func renderKnownUIDs(from UIDs: [String]) -> [String] {
    return ["#if DEBUG","let knownUIDs = [",] +
        UIDs.map({"    UID(\"\($0)\"),"}) +
        ["]","#endif"]
}

extension String {
    fileprivate var lowerCamelCase: String {
        let comp = components(separatedBy: ".")
        return comp.first! + comp.dropFirst().map { $0.capitalized }.joined()
    }

    fileprivate var upperCamelCase: String {
        return components(separatedBy: ".").map { $0.capitalized }.joined()
    }
}
