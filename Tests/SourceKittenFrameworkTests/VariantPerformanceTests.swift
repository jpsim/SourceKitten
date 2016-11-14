//
//  VariantPerformanceTests.swift
//  SourceKitten
//
//  Created by Norio Nomura on 10/17/16.
//  Copyright (c) 2016 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

let srcURL = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()

let largestSwiftFileInRepoURL = srcURL
    .appendingPathComponent("Source/SourceKittenFramework/String+SourceKitten.swift")

let largestSwiftFile = File(path: largestSwiftFileInRepoURL.path)!

class VariantPerformanceTests: XCTestCase {

    // MARK: - JSON
    func testEditorOpenJSONWithDictionary() {
        let dictionary = try? Request.editorOpen(file: largestSwiftFile).failableSend()
        if let jsonString = dictionary.map(toNSDictionary).map(toJSON) {
            try? jsonString.write(to: srcURL.appendingPathComponent("testEditorOpenJSON1.json"),
                                  atomically: true,
                                  encoding: .utf8)
        }
    }

    func testEditorOpenJSONWithVariant() {
        let variant = try? Request.editorOpen(file: largestSwiftFile).failableSend2()
        if let jsonString = variant?.any.map(toJSON) {
            try? jsonString.write(to: srcURL.appendingPathComponent("testEditorOpenJSON2.json"),
                                  atomically: true,
                                  encoding: .utf8)
        }
    }

    func testIndexJSONWithDictionary() {
        let arguments = ["-sdk", sdkPath(), "-j4", #file ]
        let dictionary = try? Request.index(file: #file, arguments: arguments).failableSend()
        if let jsonString = dictionary.map(toNSDictionary).map(toJSON) {
            try? jsonString.write(to: srcURL.appendingPathComponent("testIndexJSON1.json"),
                                  atomically: true,
                                  encoding: .utf8)
        }
    }

    func testIndexJSONWithVariant() {
        let arguments = ["-sdk", sdkPath(), "-j4", #file ]
        let variant = try? Request.index(file: #file, arguments: arguments).failableSend2()
        if let jsonString = variant?.any.map(toJSON) {
            try? jsonString.write(to: srcURL.appendingPathComponent("testIndexJSON2.json"),
                                  atomically: true,
                                  encoding: .utf8)
        }
    }

    // MARK: - Performance
    let expectedAvailables = [
        "absolutePathRepresentation(_:)",
        "commentBody(_:)",
        "countOfLeadingCharactersInSet(_:)",
        "documentedTokenOffsets(_:)",
        "lineAndCharacterForByteOffset(_:)",
        "lineAndCharacterForCharacterOffset(_:)",
        "pragmaMarks(_:excludeRanges:limitRange:)",
        "stringByRemovingCommonLeadingWhitespaceFromLines()",
        "stringByTrimmingTrailingCharactersInSet(_:)",
        "substringWithSourceRange(_:end:)",
        ]

    func testRequestEditorOpenWithDictionary() {
        self.measure {
            _ = try? Request.editorOpen(file: largestSwiftFile).failableSend()
        }
    }

    func testRequestEditorOpenWithVariant() {
        self.measure {
            _ = try? Request.editorOpen(file: largestSwiftFile).failableSend2()
        }
    }

    func testFindAvailablesWithDictionary() {
        func findAvailables(dictionary: [String: SourceKitRepresentable]) -> [String] {
            let resultFromSubstructure = (dictionary[SwiftDocKey.substructure.rawValue] as? [[String:SourceKitRepresentable]])?.flatMap(findAvailables) ?? []
            if let kind = dictionary[SwiftDocKey.kind.rawValue] as? String,
                kind == SwiftDeclarationKind.functionMethodInstance.rawValue,
                let attributes = (dictionary["key.attributes"] as? [[String:SourceKitRepresentable]])?
                    .flatMap({$0["key.attribute"] as? String}),
                attributes.contains("source.decl.attribute.available"),
                let name = dictionary[SwiftDocKey.name.rawValue] as? String {
                return [name] + resultFromSubstructure
            }
            return resultFromSubstructure
        }

        let dictionary = try? Request.editorOpen(file: largestSwiftFile).failableSend()
        var availables: [String]! = nil
        self.measure {
            availables = findAvailables(dictionary: dictionary!)
        }
        XCTAssertEqual(availables.sorted(), self.expectedAvailables)
    }

    func testFindAvailablesWithVariant() {
        func findAvailables(variant: SourceKitVariant) -> [String] {
            let resultFromSubstructure = variant.subStructure?.flatMap(findAvailables) ?? []
            if variant.kind == .sourceLangSwiftDeclMethodInstance,
                let attributes = variant.attributes?.flatMap({ $0.attribute?.uid }),
                attributes.contains(.sourceDeclAttributeAvailable),
                let name = variant.name {
                return [name] + resultFromSubstructure
            }
            return resultFromSubstructure
        }

        let variant = try? Request.editorOpen(file: largestSwiftFile).failableSend2()
        var availables: [String]!
        self.measure {
            availables = findAvailables(variant: variant!)
        }
        XCTAssertEqual(availables.sorted(), self.expectedAvailables)
    }

    func testFindAvailablesWithVariantUIDNamespace() {
        func findAvailables(variant: SourceKitVariant) -> [String] {
            let resultFromSubstructure = variant.subStructure?.flatMap(findAvailables) ?? []
            if variant.kind == UID.source.lang.swift.decl.function.method.instance,
                let attributes = variant.attributes?.flatMap({ $0.attribute }),
                attributes.contains(.available),
                let name = variant.name {
                return [name] + resultFromSubstructure
            }
            return resultFromSubstructure
        }

        let variant = try? Request.editorOpen(file: largestSwiftFile).failableSend2()
        var availables: [String]!
        self.measure {
            availables = findAvailables(variant: variant!)
        }
        XCTAssertEqual(availables.sorted(), self.expectedAvailables)
    }
}

extension VariantPerformanceTests {
    static var allTests: [(String, (VariantPerformanceTests) -> () throws -> Void)] {
        return [
            ("testEditorOpenJSONWithDictionary", testEditorOpenJSONWithDictionary),
            ("testEditorOpenJSONWithVariant", testEditorOpenJSONWithVariant),
            ("testIndexJSONWithDictionary", testIndexJSONWithDictionary),
            ("testIndexJSONWithVariant", testIndexJSONWithVariant),
            ("testRequestEditorOpenWithDictionary", testRequestEditorOpenWithDictionary),
            ("testRequestEditorOpenWithVariant", testRequestEditorOpenWithVariant),
            ("testFindAvailablesWithDictionary", testFindAvailablesWithDictionary),
            ("testFindAvailablesWithVariant", testFindAvailablesWithVariant),
            ("testFindAvailablesWithVariantUIDNamespace", testFindAvailablesWithVariantUIDNamespace),
        ]
    }
}
