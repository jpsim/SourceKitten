//
//  StringTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
@testable import SourceKittenFramework
import XCTest

class StringTests: XCTestCase {

    func testStringByRemovingCommonLeadingWhitespaceFromLines() {
        var input = "a\n b\n  c"
        XCTAssertEqual(input.removingCommonLeadingWhitespaceFromLines(), input)

        input = " a\n  b\n   c"
        XCTAssertEqual(input.removingCommonLeadingWhitespaceFromLines(), "a\n b\n  c")
    }

    func testStringByTrimmingTrailingCharactersInSet() {
        XCTAssertEqual("".bridge().trimmingTrailingCharacters(in: .whitespacesAndNewlines), "")
        XCTAssertEqual(" a ".bridge().trimmingTrailingCharacters(in: .whitespacesAndNewlines), " a")
        XCTAssertEqual(" ".bridge().trimmingTrailingCharacters(in: .whitespacesAndNewlines), "")
        XCTAssertEqual("a".bridge().trimmingTrailingCharacters(in: .whitespacesAndNewlines), "a")
        XCTAssertEqual("Foobar💣".bridge().trimmingTrailingCharacters(in: .whitespacesAndNewlines), "Foobar💣")
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
        XCTAssertEqual((good + bad).filter({ $0.bridge().isSwiftFile() }), good, "should parse Swift files in an Array")
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
        XCTAssertEqual((good + bad).filter({ $0.bridge().isObjectiveCHeaderFile() }), good, "should parse Objective-C header files in an Array")
    }

    func testAbsolutePath() {
        XCTAssert(("LICENSE".bridge().absolutePathRepresentation().bridge()).isAbsolutePath,
                  "absolutePathRepresentation() of a relative path should be an absolute path")
        XCTAssertEqual(#file.bridge().absolutePathRepresentation(), #file,
                       "absolutePathRepresentation() should return the caller if it's already an absolute path")
    }

    func testIsTokenDocumentable() throws {
        let source = "struct A { subscript(key: String) -> Void { return () } }"
        let file = File(contents: source)
        let actual = try SyntaxMap(file: file).tokens.filter(file.stringView.isTokenDocumentable)
        let expected = [
            SyntaxToken(type: SyntaxKind.identifier.rawValue, offset: 7, length: 1), // `A`
            SyntaxToken(type: SyntaxKind.keyword.rawValue, offset: 11, length: 9),   // `subscript`
            SyntaxToken(type: SyntaxKind.identifier.rawValue, offset: 21, length: 3) // `key`
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

    func testParseMultiLineDeclaration() {
        let dict: [String: SourceKitRepresentable] = [
            "key.kind": "source.lang.swift.decl.function.free",
            "key.offset": Int64(4),
            "key.bodyoffset": Int64(40),
            "key.annotated_decl": "",
            "key.typename": "(Int, Int) -> ()"
        ]
        let contents = "    func f(a: Int,\n" +
                       "           b: Int) {\n" +
                       "    }\n"
        let file = File(contents: contents)
        let parsedDecl = file.parseDeclaration(dict)!
        let expectedDecl = "func f(a: Int,\n" +
                           "       b: Int)"
        XCTAssertEqual(parsedDecl, expectedDecl, "should preserve declaration alignment")
    }

    func testParseUnbodiedMultiLineDeclaration() {
        let dict: [String: SourceKitRepresentable] = [
            "key.kind": "source.lang.swift.decl.function.method.instance",
            "key.offset": Int64(17),
            "key.length": Int64(33),
            "key.annotated_decl": "",
            "key.typename": "(Int, Int) -> ()"
        ]
        let contents = """
                       protocol P {
                           func f(a: Int,
                                  b: Int)
                       }
                       """
        let file = File(contents: contents)
        let parsedDecl = file.parseDeclaration(dict)!
#if compiler(>=5.1)
        let expectedDecl = """
                           func f(a: Int,
                                  b: Int)
                           """
#else
        let expectedDecl = "func f(a: Int,"
#endif
        XCTAssertEqual(parsedDecl, expectedDecl, "should extract the declaration")
    }

    func testGenerateDocumentedTokenOffsets() throws {
        let fileContents = "/// Comment\nlet global = 0"
        let syntaxMap = try SyntaxMap(file: File(contents: fileContents))
        XCTAssertEqual(fileContents.stringView().documentedTokenOffsets(syntaxMap: syntaxMap), [16], "should generate documented token offsets")
    }

    func testDocumentedTokenOffsetsWithSubscript() throws {
        let file = File(path: fixturesDirectory + "Subscript.swift")!
        let syntaxMap = try SyntaxMap(file: file)
        XCTAssertEqual(file.stringView.documentedTokenOffsets(syntaxMap: syntaxMap), [54], "should generate documented token offsets")
    }

    func testGenerateDocumentedTokenOffsetsEmpty() throws {
        let fileContents = "// Comment\nlet global = 0"
        let syntaxMap = try SyntaxMap(file: File(contents: fileContents))
        XCTAssertEqual(fileContents.stringView().documentedTokenOffsets(syntaxMap: syntaxMap).count,
                       0,
                       "shouldn't detect any documented token offsets when there are none")
    }

    func testSubstringWithByteRange() {
        let string = "👨‍👩‍👧‍👧123"
        XCTAssertEqual(string.stringView().substringWithByteRange(ByteRange(location: 0, length: 25))!, "👨‍👩‍👧‍👧")
        XCTAssertEqual(string.stringView().substringWithByteRange(ByteRange(location: 25, length: 1))!, "1")
    }

    func testSubstringLinesWithByteRange() {
        let string = "👨‍👩‍👧‍👧\n123"
        XCTAssertEqual(string.stringView().substringLinesWithByteRange(ByteRange(location: 0, length: 0))!, "👨‍👩‍👧‍👧\n")
        XCTAssertEqual(string.stringView().substringLinesWithByteRange(ByteRange(location: 0, length: 25))!, "👨‍👩‍👧‍👧\n")
        XCTAssertEqual(string.stringView().substringLinesWithByteRange(ByteRange(location: 0, length: 26))!, "👨‍👩‍👧‍👧\n")
        XCTAssertEqual(string.stringView().substringLinesWithByteRange(ByteRange(location: 0, length: 27))!, string)
        XCTAssertEqual(string.stringView().substringLinesWithByteRange(ByteRange(location: 27, length: 0))!, "123")
    }

    func testLineRangeWithByteRange() {
        XCTAssert("".stringView().lineRangeWithByteRange(ByteRange(location: 0, length: 0)) == nil)
        let string = "👨‍👩‍👧‍👧\n123"
        XCTAssertEqual(string.stringView().lineRangeWithByteRange(ByteRange(location: 0, length: 0)), (1, 1))
        XCTAssertEqual(string.stringView().lineRangeWithByteRange(ByteRange(location: 0, length: 25)), (1, 1))
        XCTAssertEqual(string.stringView().lineRangeWithByteRange(ByteRange(location: 0, length: 26)), (1, 2))
        XCTAssertEqual(string.stringView().lineRangeWithByteRange(ByteRange(location: 0, length: 27)), (1, 2))
        XCTAssertEqual(string.stringView().lineRangeWithByteRange(ByteRange(location: 27, length: 0)), (2, 2))
    }

    func testLineAndCharacterForByteOffset() {
        let string = "public typealias 🔳 = QRCode"
        XCTAssertEqual(string.stringView().lineAndCharacter(forByteOffset: 17), (1, 18))
    }

    func testByteRangeToNSRange() {
        let string = """
            enum Foo {
                case one
                case two
            }

            func bar(foo: Foo) -> String {
                let some = "ru_RU"
                switch foo {
                case .one:
                    return "\\(some) один"
                default:
                    return "\\(some) два"
                }
            }
            """
        XCTAssertEqual(string.stringView().byteRangeToNSRange(ByteRange(location: 115, length: 41)), NSRange(location: 115, length: 38))
    }

    func testLineAndCharacterForCharacterOffset() {
        let string = "" +
        "func foo() {\n" + //     12+1 characters, start=0
        "    test()\n" +   //     10+1 characters, start=13
        "  \ttest()\n" +   // 2+t+06+1 characters, start=24
        "\ttest()\n" +     // t+  06+1 characters
        "}"

        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 4, expandingTabsToWidth: 1), (1, 5))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 17, expandingTabsToWidth: 1), (2, 5))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 27 /* expandingTabsToWidth: default */), (3, 4))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 27, expandingTabsToWidth: 1), (3, 4))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 27, expandingTabsToWidth: 2), (3, 5))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 27, expandingTabsToWidth: 4), (3, 5))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 27, expandingTabsToWidth: 8), (3, 9))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 35 /* tabWidth: default */), (4, 2))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 35, expandingTabsToWidth: 1), (4, 2))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 35, expandingTabsToWidth: 2), (4, 3))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 35, expandingTabsToWidth: 4), (4, 5))
        XCTAssertEqual(string.stringView().lineAndCharacter(forCharacterOffset: 35, expandingTabsToWidth: 8), (4, 9))
    }

    func testUnescaping() {
        XCTAssertEqual("aaa".unescaped, "aaa")
        XCTAssertEqual("a\\bc".unescaped, "abc")
        XCTAssertEqual("\\abc".unescaped, "abc")
        XCTAssertEqual("ab\\c".unescaped, "abc")
        XCTAssertEqual("\\a".unescaped, "a")
        XCTAssertEqual("\\\\".unescaped, "\\")
        XCTAssertEqual("a\\\\\\b".unescaped, "a\\b")

        // no crash on bad input
        XCTAssertEqual("ab\\".unescaped, "ab")
    }

    func testResponseFiles() throws {
        let responseContents = "3 4\n5\n6\\\\7\n8\\ 9\n"
        let responseUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(UUID().uuidString).rsp")
        try responseContents.data(using: .utf8)?.write(to: responseUrl)
        let xcodeArgs = ["1", "2", "@\(responseUrl.path)", "e"]
        let expandedArgs = xcodeArgs.expandingResponseFiles
        XCTAssertEqual("1,2,3 4,5,6\\7,8 9,e", expandedArgs.joined(separator: ","))
    }
}

typealias LineRangeType = (start: Int, end: Int)

func == (lhs: LineRangeType, rhs: LineRangeType) -> Bool {
    return lhs.start == rhs.start && lhs.end == rhs.end
}

private func XCTAssertEqual(_ actual: (Int, Int)?, _ expected: (Int, Int), file: StaticString = #file, line: UInt = #line) {
    XCTAssertNotNil(actual, file: file, line: line)

    if let actual = actual {
        XCTAssertEqual([actual.0, actual.1], [expected.0, expected.1], file: file, line: line)
    }
}

extension StringTests {
    static var allTests: [(String, (StringTests) -> () throws -> Void)] {
        return [
            ("testStringByRemovingCommonLeadingWhitespaceFromLines", testStringByRemovingCommonLeadingWhitespaceFromLines),
            ("testStringByTrimmingTrailingCharactersInSet", testStringByTrimmingTrailingCharactersInSet),
            ("testCommentBody", testCommentBody),
            ("testIsSwiftFile", testIsSwiftFile),
            ("testIsObjectiveCHeaderFile", testIsObjectiveCHeaderFile),
            ("testAbsolutePath", testAbsolutePath),
            ("testIsTokenDocumentable", testIsTokenDocumentable),
            ("testParseDeclaration", testParseDeclaration),
            ("testParseMultiLineDeclaration", testParseMultiLineDeclaration),
            ("testParseUnbodiedMultiLineDeclaration", testParseUnbodiedMultiLineDeclaration),
            ("testGenerateDocumentedTokenOffsets", testGenerateDocumentedTokenOffsets),
            ("testDocumentedTokenOffsetsWithSubscript", testDocumentedTokenOffsetsWithSubscript),
            ("testGenerateDocumentedTokenOffsetsEmpty", testGenerateDocumentedTokenOffsetsEmpty),
            ("testSubstringWithByteRange", testSubstringWithByteRange),
            ("testSubstringLinesWithByteRange", testSubstringLinesWithByteRange),
            ("testLineRangeWithByteRange", testLineRangeWithByteRange),
            ("testLineAndCharacterForByteOffset", testLineAndCharacterForByteOffset),
            ("testByteRangeToNSRange", testByteRangeToNSRange),
            ("testLineAndCharacterForCharacterOffset", testLineAndCharacterForCharacterOffset),
            ("testUnescaping", testUnescaping),
            ("testResponseFiles", testResponseFiles)
        ]
    }
}

private extension String {

    func stringView() -> StringView {
        return StringView(self)
    }

}
