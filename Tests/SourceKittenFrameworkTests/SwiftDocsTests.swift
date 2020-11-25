import Foundation
import SnapshotTesting
@testable import SourceKittenFramework
import XCTest

class SwiftDocsTests: XCTestCase {
    func testSubscript() {
        assertSourceKittenSnapshot(matching: docs(forFixtureNamed: "Subscript"), as: .docsJSON)
    }

    func testBicycle() {
        assertSourceKittenSnapshot(matching: docs(forFixtureNamed: "Bicycle"), as: .docsJSON)
    }

    func testExtension() {
        assertSourceKittenSnapshot(matching: docs(forFixtureNamed: "Extension"), as: .docsJSON)
    }

    func testParseFullXMLDocs() {
        // swiftlint:disable:next line_length
        let xmlDocsStringPreSwift32 = "<Type file=\"file\" line=\"1\" column=\"2\"><Name>name</Name><USR>usr</USR><Declaration>declaration</Declaration><Abstract><Para>discussion</Para></Abstract><Parameters><Parameter><Name>param1</Name><Direction isExplicit=\"0\">in</Direction><Discussion><Para>param1_discussion</Para></Discussion></Parameter></Parameters><ResultDiscussion><Para>result_discussion</Para></ResultDiscussion></Type>"
        // swiftlint:disable:next line_length
        let xmlDocsStringSwift32 = "<Type file=\"file\" line=\"1\" column=\"2\"><Name>name</Name><USR>usr</USR><Declaration>declaration</Declaration><CommentParts><Abstract><Para>discussion</Para></Abstract><Parameters><Parameter><Name>param1</Name><Direction isExplicit=\"0\">in</Direction><Discussion><Para>param1_discussion</Para></Discussion></Parameter></Parameters><ResultDiscussion><Para>result_discussion</Para></ResultDiscussion></CommentParts></Type>"
        let parsedPreSwift32 = parseFullXMLDocs(xmlDocsStringPreSwift32)!
        let parsedSwift32 = parseFullXMLDocs(xmlDocsStringSwift32)!
        let expected: NSDictionary = [
            "key.doc.type": "Type",
            "key.doc.file": "file",
            "key.doc.line": 1,
            "key.doc.column": 2,
            "key.doc.name": "name",
            "key.usr": "usr",
            "key.doc.declaration": "declaration",
            "key.doc.parameters": [[
                "name": "param1",
                "discussion": [["Para": "param1_discussion"]]
            ]],
            "key.doc.result_discussion": [["Para": "result_discussion"]]
        ]
        XCTAssertEqual(toNSDictionary(parsedPreSwift32), expected)
        XCTAssertEqual(toNSDictionary(parsedSwift32), expected)
    }

    // #606 - create docs without crashing
    func testParseExternalReference() {
        let firstPath = fixturesDirectory + "ExternalRef1.swift"
        let secondPath = fixturesDirectory + "ExternalRef2.swift"
        let docs = SwiftDocs(file: File(path: firstPath)!, arguments: ["-sdk", sdkPath(), firstPath, secondPath])!
        XCTAssertFalse(docs.docsDictionary.isEmpty)
    }

    private func docs(forFixtureNamed fixtureName: String) -> SwiftDocs {
        let swiftFilePath = fixturesDirectory + fixtureName + ".swift"
        return SwiftDocs(file: File(path: swiftFilePath)!, arguments: ["-j4", "-sdk", sdkPath(), swiftFilePath])!
    }
}

extension SwiftDocsTests {
    static var allTests: [(String, (SwiftDocsTests) -> () throws -> Void)] {
        return [
            ("testSubscript", testSubscript),
            ("testBicycle", testBicycle),
            ("testExtension", testExtension),
            ("testParseFullXMLDocs", testParseFullXMLDocs),
            ("testParseExternalReference", testParseExternalReference)
        ]
    }
}
