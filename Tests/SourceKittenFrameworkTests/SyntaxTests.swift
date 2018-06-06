//
//  SyntaxTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

private typealias TokenWrapper = (kind: SyntaxKind, offset: Int, length: Int)

private func compareSyntax(file: File, expectedTokens: [TokenWrapper]) {
    let expectedSyntaxMap = SyntaxMap(tokens: expectedTokens.map { tokenWrapper in
        return SyntaxToken(type: tokenWrapper.kind.rawValue, offset: tokenWrapper.offset, length: tokenWrapper.length)
    })
    let syntaxMap = try! SyntaxMap(file: file)
    XCTAssertEqual(syntaxMap, expectedSyntaxMap, "should generate expected syntax map")

    let syntaxJSONData = syntaxMap.description.data(using: .utf8)!
    let jsonArray = try! JSONSerialization.jsonObject(with: syntaxJSONData, options: []) as? [Any]
    XCTAssertEqual(
        jsonArray!.bridge(),
        expectedSyntaxMap.tokens.map({ $0.dictionaryValue.bridge() }).bridge(),
        "JSON should match expected syntax"
    )
}

class SyntaxTests: XCTestCase {

    func testPrintEmptySyntax() throws {
        XCTAssertEqual(try SyntaxMap(file: File(contents: "")).description, "[\n\n]", "should print empty syntax")
    }

    func testGenerateSameSyntaxMapFileAndContents() throws {
        let fileContents = try String(contentsOfFile: #file, encoding: .utf8)
        try XCTAssertEqual(SyntaxMap(file: File(path: #file)!),
            SyntaxMap(file: File(contents: fileContents)),
            "should generate the same syntax map for a file as raw text")
    }

    func testSubscript() {
        compareSyntax(file: File(contents: "struct A { subscript(index: Int) -> () { return () } }"),
            expectedTokens: [
                (.keyword, 0, 6),
                (.identifier, 7, 1),
                (.keyword, 11, 9),
                (.identifier, 21, 5),
                (.typeidentifier, 28, 3),
                (.keyword, 41, 6)
            ]
        )
    }

    func testSyntaxMapPrintValidJSON() {
        compareSyntax(file: File(contents: "import Foundation // Hello World!"),
            expectedTokens: [
                (.keyword, 0, 6),
                (.identifier, 7, 10),
                (.comment, 18, 15)
            ]
        )
    }
}

extension SyntaxTests {
    static var allTests: [(String, (SyntaxTests) -> () throws -> Void)] {
        return [
            ("testPrintEmptySyntax", testPrintEmptySyntax),
            ("testGenerateSameSyntaxMapFileAndContents", testGenerateSameSyntaxMapFileAndContents),
            ("testSubscript", testSubscript),
            ("testSyntaxMapPrintValidJSON", testSyntaxMapPrintValidJSON)
        ]
    }
}
