//
//  StringTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

class StringTests: XCTestCase {

    func testStringByRemovingCommonLeadingWhitespaceFromLines() {
        var input = "a\n b\n  c"
        XCTAssertEqual(input.stringByRemovingCommonLeadingWhitespaceFromLines(), input)

        input = " a\n  b\n   c"
        XCTAssertEqual(input.stringByRemovingCommonLeadingWhitespaceFromLines(), "a\n b\n  c")
    }

    func testStringByTrimmingTrailingCharactersInSet() {
        XCTAssertEqual(NSString(string: "").stringByTrimmingTrailingCharactersInSet(characterSet: NSCharacterSet.whitespacesAndNewlines()), "")
        XCTAssertEqual(NSString(string: " a ").stringByTrimmingTrailingCharactersInSet(characterSet: NSCharacterSet.whitespacesAndNewlines()), " a")
        XCTAssertEqual(NSString(string: " ").stringByTrimmingTrailingCharactersInSet(characterSet: NSCharacterSet.whitespacesAndNewlines()), "")
        XCTAssertEqual(NSString(string: "a").stringByTrimmingTrailingCharactersInSet(characterSet: NSCharacterSet.whitespacesAndNewlines()), "a")
    }

    func testCommentBody() {
        var commentString = "/// Single line comment.\n\n"
        XCTAssertEqual(commentString.commentBody()!, "Single line comment.")

        commentString = "/// Multiple\n/// single line comments.\n\n"
        XCTAssertEqual(commentString.commentBody()!, "Multiple\nsingle line comments.")

        commentString = "/**\nMultiple\nline\ncomments.\n*/"
        XCTAssertEqual(commentString.commentBody()!, "Multiple\nline\ncomments.")

        commentString = "/*\nNot a documentation comment.\n*/"
        XCTAssertNil(commentString.commentBody())

        commentString = "// Not a documentation comment."
        XCTAssertNil(commentString.commentBody())

        commentString = "👨‍👩‍👧‍👧\n    /// Multiple\n        /// single line comments.\n\n"
        XCTAssertEqual(commentString.commentBody()!, "Multiple\n    single line comments.")

        commentString = "👨‍👩‍👧‍👧\n    /**\n    Multiple\n        line\n    comments.\n    */"
        XCTAssertEqual(commentString.commentBody()!, "Multiple\n    line\ncomments.")
    }

    func testIsSwiftFile() {
        let good = ["good.swift"]
        let bad = [
            "bad.swift.",
            ".swift.bad",
            "badswift",
            "bad.Swift"
        ]
        XCTAssertEqual((good + bad).filter({ NSString(string: $0).isSwiftFile() }), good, "should parse Swift files in an Array")
    }

    func testIsObjectiveCHeaderFile() {
        let good = [
            "good.h",
            "good.hpp",
            "good.hh"
        ]
        let bad = [
            "bad.h.",
            ".hpp.bad",
            "badshh",
            "bad.H"
        ]
        XCTAssertEqual((good + bad).filter({ NSString(string: $0).isObjectiveCHeaderFile() }), good, "should parse Objective-C header files in an Array")
    }

    func testAbsolutePath() {
        #if os(Linux)
        XCTAssert(NSString(string: NSString(string: "LICENSE").absolutePathRepresentation()).absolutePath, "absolutePathRepresentation() of a relative path should be an absolute path")
        #else
        XCTAssert(NSString(string: NSString(string: "LICENSE").absolutePathRepresentation()).isAbsolutePath, "absolutePathRepresentation() of a relative path should be an absolute path")
        #endif
        XCTAssertEqual(NSString(string: #file).absolutePathRepresentation(), #file, "absolutePathRepresentation() should return the caller if it's already an absolute path")
    }

    func testIsTokenDocumentable() {
        let source = "struct A { subscript(key: String) -> Void { return () } }"
        let actual = SyntaxMap(file: File(contents: source)).tokens.filter(source.isTokenDocumentable)
        let expected = [
            SyntaxToken(type: SyntaxKind.Identifier.rawValue, offset: 7, length: 1), // `A`
            SyntaxToken(type: SyntaxKind.Keyword.rawValue, offset: 11, length: 9),   // `subscript`
            SyntaxToken(type: SyntaxKind.Identifier.rawValue, offset: 21, length: 3) // `key`
        ]
        XCTAssertEqual(actual, expected, "should detect documentable tokens")
    }

    func testParseDeclaration() {
        let dict: [String: SourceKitRepresentable] = [
            "key.kind": "source.lang.swift.decl.class",
            "key.offset": Int64(24),
            "key.bodyoffset": Int64(32),
            "key.annotated_decl": "",
            "key.typename": "ClassA.Type"
        ]
        // This string is a regression test for https://github.com/jpsim/SourceKitten/issues/35 .
        let file = File(contents: "/**\n　ほげ\n*/\nclass ClassA {\n}\n")
        XCTAssertEqual("class ClassA", file.parseDeclaration(dict)!, "should extract declaration from source text")
    }

    func testGenerateDocumentedTokenOffsets() {
        let fileContents = "/// Comment\nlet global = 0"
        let syntaxMap = SyntaxMap(file: File(contents: fileContents))
        XCTAssertEqual(fileContents.documentedTokenOffsets(syntaxMap: syntaxMap), [16], "should generate documented token offsets")
    }

    func testDocumentedTokenOffsetsWithSubscript() {
        let file = File(path: fixturesDirectory + "Subscript.swift")!
        let syntaxMap = SyntaxMap(file: file)
        XCTAssertEqual(file.contents.documentedTokenOffsets(syntaxMap: syntaxMap), [54], "should generate documented token offsets")
    }

    func testGenerateDocumentedTokenOffsetsEmpty() {
        let fileContents = "// Comment\nlet global = 0"
        let syntaxMap = SyntaxMap(file: File(contents: fileContents))
        XCTAssertEqual(fileContents.documentedTokenOffsets(syntaxMap: syntaxMap).count, 0, "shouldn't detect any documented token offsets when there are none")
    }

    func testSubstringWithByteRange() {
        let string = NSString(string: "👨‍👩‍👧‍👧123")
        XCTAssertEqual(string.substringWithByteRange(start: 0, length: 25)!, "👨‍👩‍👧‍👧")
        XCTAssertEqual(string.substringWithByteRange(start: 25, length: 1)!, "1")
    }

    func testSubstringLinesWithByteRange() {
        let string = NSString(string: "👨‍👩‍👧‍👧\n123")
        XCTAssertEqual(string.substringLinesWithByteRange(start: 0, length: 0)!, "👨‍👩‍👧‍👧\n")
        XCTAssertEqual(string.substringLinesWithByteRange(start: 0, length: 25)!, "👨‍👩‍👧‍👧\n")
        XCTAssertEqual(string.substringLinesWithByteRange(start: 0, length: 26)!, "👨‍👩‍👧‍👧\n")
        #if os(Linux)
        XCTAssertEqual(string.substringLinesWithByteRange(start: 0, length: 27)!, string.bridge())
        #else
        XCTAssertEqual(string.substringLinesWithByteRange(start: 0, length: 27)!, string)
        #endif
        XCTAssertEqual(string.substringLinesWithByteRange(start: 27, length: 0)!, "123")
    }

    func testLineRangeWithByteRange() {
        XCTAssert(NSString(string: "").lineRangeWithByteRange(start: 0, length: 0) == nil)
        let string = NSString(string: "👨‍👩‍👧‍👧\n123")
        XCTAssert(string.lineRangeWithByteRange(start: 0, length: 0)! == (1, 1))
        XCTAssert(string.lineRangeWithByteRange(start: 0, length: 25)! == (1, 1))
        XCTAssert(string.lineRangeWithByteRange(start: 0, length: 26)! == (1, 2))
        XCTAssert(string.lineRangeWithByteRange(start: 0, length: 27)! == (1, 2))
        XCTAssert(string.lineRangeWithByteRange(start: 27, length: 0)! == (2, 2))
    }
}

typealias LineRangeType = (start: Int, end: Int)

func ==(lhs: LineRangeType, rhs: LineRangeType) -> Bool {
    return lhs.start == rhs.start && lhs.end == rhs.end
}
