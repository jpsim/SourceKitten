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
        // Use Fully Qualified Name
        let keyRequest: UID.Key = "key.request"
        XCTAssertEqual(keyRequest, .request)

        // Use short name with infering prefix
        let keyKind: UID.Key = ".kind"
        XCTAssertEqual(UID.Key.kind, keyKind)
    }

    func testCompareToSelf() {
        // Equatable
        XCTAssertEqual(UID.SourceLangSwiftDecl.extensionClass, ".extension.class")
        XCTAssertNotEqual(UID.SourceLangSwiftDecl.extensionClass, ".extension.enum")

        // `==` operator
        XCTAssertTrue(UID.SourceLangSwiftDecl.extensionClass == ".extension.class")
        XCTAssertFalse(UID.SourceLangSwiftDecl.extensionClass == ".extension.enum")

        // `!=` operator
        XCTAssertFalse(UID.SourceLangSwiftDecl.extensionClass != ".extension.class")
        XCTAssertTrue(UID.SourceLangSwiftDecl.extensionClass != ".extension.enum")
    }

    func testUseOperatorsForComparingToUID() {
        let uidExtensionClass = UID("source.lang.swift.decl.extension.class")
        let uidExtensionEnum = UID("source.lang.swift.decl.extension.enum")

        // `==` operator
        XCTAssertTrue(UID.SourceLangSwiftDecl.extensionClass == uidExtensionClass)
        XCTAssertFalse(UID.SourceLangSwiftDecl.extensionClass == uidExtensionEnum)
        XCTAssertTrue(uidExtensionClass == UID.SourceLangSwiftDecl.extensionClass)
        XCTAssertFalse(uidExtensionEnum == UID.SourceLangSwiftDecl.extensionClass)

        XCTAssertTrue(UID.SourceLangSwiftDecl.extensionClass == Optional(uidExtensionClass))
        XCTAssertFalse(UID.SourceLangSwiftDecl.extensionClass == Optional(uidExtensionEnum))
        XCTAssertTrue(Optional(uidExtensionClass) == UID.SourceLangSwiftDecl.extensionClass)
        XCTAssertFalse(Optional(uidExtensionEnum) == UID.SourceLangSwiftDecl.extensionClass)

        // `!=` operator
        XCTAssertFalse(UID.SourceLangSwiftDecl.extensionClass != uidExtensionClass)
        XCTAssertTrue(UID.SourceLangSwiftDecl.extensionClass != uidExtensionEnum)
        XCTAssertFalse(uidExtensionClass != UID.SourceLangSwiftDecl.extensionClass)
        XCTAssertTrue(uidExtensionEnum != UID.SourceLangSwiftDecl.extensionClass)

        XCTAssertFalse(UID.SourceLangSwiftDecl.extensionClass != Optional(uidExtensionClass))
        XCTAssertTrue(UID.SourceLangSwiftDecl.extensionClass != Optional(uidExtensionEnum))
        XCTAssertFalse(Optional(uidExtensionClass) != UID.SourceLangSwiftDecl.extensionClass)
        XCTAssertTrue(Optional(uidExtensionEnum) != UID.SourceLangSwiftDecl.extensionClass)
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
            ("testCompareToSelf", testCompareToSelf),
            ("testUseOperatorsForComparingToUID", testUseOperatorsForComparingToUID),
//            ("testUnknownUIDCausesPreconditionFailureOnDebugBuild", testUnknownUIDCausesPreconditionFailureOnDebugBuild),
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

    var lines = [String]()
    // enums
    lines.append("extension UID {")
    lines.append(contentsOf: sortedNamespaces.flatMap({ $0.renderEnum() }).map(indent))
    lines.append(contentsOf: ["}",""])
    // extensions
    lines.append(contentsOf: sortedNamespaces.flatMap { $0.renderExtension() })
    // isMemberPropertiesExtension
    lines.append("extension UID {")
    lines.append(contentsOf: sortedNamespaces.map({ $0.renderIsMemberProperty() }).map(indent))
    lines.append("}")
    // knownUIDOfContents
    lines.append(contentsOf: sortedNamespaces.flatMap { $0.renderKnownUIDOf() })
    // knownUIDs
    lines.append("let knownUIDsSets: [Set<UID>] = [")
    lines.append(contentsOf: sortedNamespaces.map({ "knownUIDsOf\($0.typeName)," }).map(indent))
    lines.append(indent("knownUIDsOfCustomKey,"))
    lines.append("]")

    return lines.joined(separator: "\n") + "\n"
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
        var result = [String]()
        result.append("public struct \(name.upperCamelCase) {")
        result.append(indent("public let uid: UID"))
        result.append(contentsOf: children.flatMap(render).map(indent))
        result.append("}")
        return result
    }

    func renderExtension() -> [String] {
        var result = [String]()
        result.append("extension UID.\(typeName): UIDNamespace {")
        result.append(indent("public static let __uid_prefix = \"\(name)\""))
        result.append(contentsOf: renderMethods().map(indent))
        result.append("}")
        return result
    }

    func renderIsMemberProperty() -> String {
        return "public var isMemberOf\(typeName): Bool { return knownUIDsOf\(typeName).contains(self) }"
    }

    func renderKnownUIDOf() -> [String] {
        var result = [String]()
        result.append("fileprivate let knownUIDsOf\(typeName): Set<UID> = [")
        result.append(contentsOf: children.map { "UID.\(typeName).\(propertyName(from: $0)).uid," }.map(indent))
        result.append("]")
        return result
    }

    var typeName: String {
        return name.upperCamelCase
    }

    // Private

    private var children: [String] = []

    private func propertyName(from child: String) -> String {
        return type(of: self).escape(removePrefix(from: child).lowerCamelCase)
    }

    private func removePrefix(from uidString: String) -> String {
        return uidString.replacingOccurrences(of: name + ".", with: "")
    }

    private func render(child: String) -> [String] {
        let property = propertyName(from: child)
        return [
            "/// \(child)",
            "public static let \(property): \(name.upperCamelCase) = \"\(child)\"",
        ]
    }

    private func renderMethods() -> [String] {
        return [
            "public static func ==(lhs: UID.\(typeName), rhs: UID.\(typeName)) -> Bool { return lhs.uid == rhs.uid }",
            "public static func !=(lhs: UID.\(typeName), rhs: UID.\(typeName)) -> Bool { return lhs.uid != rhs.uid }",
            "public static func ==(lhs: UID, rhs: UID.\(typeName)) -> Bool { return lhs == rhs.uid }",
            "public static func !=(lhs: UID, rhs: UID.\(typeName)) -> Bool { return lhs != rhs.uid }",
            "public static func ==(lhs: UID.\(typeName), rhs: UID) -> Bool { return lhs.uid == rhs }",
            "public static func !=(lhs: UID.\(typeName), rhs: UID) -> Bool { return lhs.uid != rhs }",
            "public static func ==(lhs: UID?, rhs: UID.\(typeName)) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }",
            "public static func !=(lhs: UID?, rhs: UID.\(typeName)) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }",
            "public static func ==(lhs: UID.\(typeName), rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }",
            "public static func !=(lhs: UID.\(typeName), rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }",
            // FIXME: Remove following when https://bugs.swift.org/browse/SR-3173 will be resolved.
            "public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }",
            "public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }",
            "public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }",
        ]
    }

    // escaping keywords with "`"
    private static func escape(_ name: String) -> String {
        return keywords.contains(name) ? "`\(name)`" : name
    }
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
