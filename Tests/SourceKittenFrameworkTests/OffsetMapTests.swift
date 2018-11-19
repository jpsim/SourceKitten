//
//  OffsetMapTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

class OffsetMapTests: XCTestCase {

    func testOffsetMapContainsDeclarationOffsetWithDocCommentButNotAlreadyDocumented() throws {
        // Subscripts aren't parsed by SourceKit, so OffsetMap should contain its offset.
        let file = File(contents:
            "struct VoidStruct {\n/// Returns or sets Void.\nsubscript(key: String) -> () {\n" +
            "get { return () }\nset {}\n}\n}"
        )
        let documentedTokenOffsets = file.contents.documentedTokenOffsets(syntaxMap: try SyntaxMap(file: file))
        let response = file.process(dictionary: try Request.editorOpen(file: file).send(), cursorInfoRequest: nil)
        let offsetMap = file.makeOffsetMap(documentedTokenOffsets: documentedTokenOffsets, dictionary: response)
        XCTAssertEqual(offsetMap, [:], "should generate correct offset map of [(declaration offset): (parent offset)]")
    }

    func testOffsetMapDoesntContainAlreadyDocumentedDeclarationOffset() throws {
        // Struct declarations are parsed by SourceKit, so OffsetMap shouldn't contain its offset.
        let file = File(contents: "/// Doc Comment\nstruct DocumentedStruct {}")
        let documentedTokenOffsets = file.contents.documentedTokenOffsets(syntaxMap: try SyntaxMap(file: file))
        let response = file.process(dictionary: try Request.editorOpen(file: file).send(), cursorInfoRequest: nil)
        let offsetMap = file.makeOffsetMap(documentedTokenOffsets: documentedTokenOffsets, dictionary: response)
        XCTAssertEqual(offsetMap, [:], "should generate empty offset map")
    }
}

extension OffsetMapTests {
    static var allTests: [(String, (OffsetMapTests) -> () throws -> Void)] {
        return [
            ("testOffsetMapContainsDeclarationOffsetWithDocCommentButNotAlreadyDocumented",
             testOffsetMapContainsDeclarationOffsetWithDocCommentButNotAlreadyDocumented),
            ("testOffsetMapDoesntContainAlreadyDocumentedDeclarationOffset",
             testOffsetMapDoesntContainAlreadyDocumentedDeclarationOffset)
        ]
    }
}
