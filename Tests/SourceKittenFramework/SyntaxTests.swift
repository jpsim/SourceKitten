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

private func compareSyntax(file: File, expectedTokens: [(SyntaxKind, Int, Int)]) {
    let expectedSyntaxMap = SyntaxMap(tokens: expectedTokens.map { tokenTuple in
        return SyntaxToken(type: tokenTuple.0.rawValue, offset: tokenTuple.1, length: tokenTuple.2)
    })
    let syntaxMap = SyntaxMap(file: file)
    XCTAssertEqual(syntaxMap, expectedSyntaxMap, "should generate expected syntax map")

    let syntaxJSON = syntaxMap.description
    let jsonArray = try! JSONSerialization.jsonObject(with: syntaxJSON.data(using: .utf8)!, options: []) as? NSArray
    XCTAssertNotNil(jsonArray, "JSON should be propery parsed")
    XCTAssertEqual(jsonArray!, expectedSyntaxMap.tokens.map { $0.dictionaryValue } as NSArray, "JSON should match expected syntax")
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
