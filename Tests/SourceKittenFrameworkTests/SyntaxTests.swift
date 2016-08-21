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

func compareSyntax(_ file: File, _ expectedTokens: [(SyntaxKind, Int, Int)]) {
    let expectedSyntaxMap = SyntaxMap(tokens: expectedTokens.map { tokenTuple in
        return SyntaxToken(type: tokenTuple.0.rawValue, offset: tokenTuple.1, length: tokenTuple.2)
    })
    let syntaxMap = SyntaxMap(file: file)
    XCTAssertEqual(syntaxMap, expectedSyntaxMap, "should generate expected syntax map")

    #if os(Linux)
        typealias JSONType = Any
    #else
        typealias JSONType = NSDictionary
    #endif
    let syntaxData = syntaxMap.description.data(using: .utf8)!
    XCTAssertEqual(
        try! (JSONSerialization.jsonObject(with: syntaxData, options: []) as! [JSONType]).bridge(),
        expectedSyntaxMap.tokens.map({ $0.dictionaryValue.bridge() }).bridge(),
        "JSON should match expected syntax"
    )
}

class SyntaxTests: XCTestCase {

    func testPrintEmptySyntax() {
        XCTAssertEqual(SyntaxMap(file: File(contents: "")).description, "[\n\n]", "should print empty syntax")
    }

    func testGenerateSameSyntaxMapFileAndContents() {
        let fileContents = try! String(contentsOfFile: #file, encoding: .utf8)
        XCTAssertEqual(SyntaxMap(file: File(path: #file)!),
            SyntaxMap(file: File(contents: fileContents)),
            "should generate the same syntax map for a file as raw text")
    }

    func testSubscript() {
        compareSyntax(File(contents: "struct A { subscript(index: Int) -> () { return () } }"),
            [
                (.Keyword, 0, 6),
                (.Identifier, 7, 1),
                (.Keyword, 11, 9),
                (.Identifier, 21, 5),
                (.Typeidentifier, 28, 3),
                (.Keyword, 41, 6)
            ]
        )
    }

    func testSyntaxMapPrintValidJSON() {
        compareSyntax(File(contents: "import Foundation // Hello World!"),
            [
                (.Keyword, 0, 6),
                (.Identifier, 7, 10),
                (.Comment, 18, 15)
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
            ("testSyntaxMapPrintValidJSON", testSyntaxMapPrintValidJSON),
        ]
    }
}
