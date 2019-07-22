//
//  CursorInfoParsingTests.swift
//  SourceKittenFramework
//
//  Created by Colton Schlosser on 7/21/19.
//  Copyright © 2019 SourceKitten. All rights reserved.
//

import SourceKittenFramework
import XCTest

final class CursorInfoParsingTests: XCTestCase {

    func testNoReferencedUSR() {
        let cursorInfo: [String: SourceKitRepresentable] = [
            "key.usr": "s:4main5limitL_Sivp",
            "key.kind": "source.lang.swift.decl.var.local"
        ]

        XCTAssertEqual(cursorInfo.referencedUSRs, [])
    }

    func testSingleReferencedUSR() {
        let cursorInfo: [String: SourceKitRepresentable] = [
            "key.usr": "s:4main5limitL_Sivp",
            "key.kind": "source.lang.swift.ref.var.local"
        ]

        XCTAssertEqual(cursorInfo.referencedUSRs, ["s:4main5limitL_Sivp"])
    }

    func testRelatedReferencedUSR() {
        let cursorInfo: [String: SourceKitRepresentable] = [
            "key.usr": "s:4main5limitL_Sivp",
            "key.kind": "source.lang.swift.ref.var.local",
            "key.related_decls": [
                ["key.annotated_decl": "<RelatedName usr=\"s:4main5limit33_BF49849BA67C991867DA082EF03F5F16LLSivp\">limit</RelatedName>"]
            ]
        ]

        XCTAssertEqual(cursorInfo.referencedUSRs, ["s:4main5limitL_Sivp", "s:4main5limit33_BF49849BA67C991867DA082EF03F5F16LLSivp"])
    }
}

extension CursorInfoParsingTests {
    static var allTests: [(String, (CursorInfoParsingTests) -> () throws -> Void)] {
        return [
            ("testNoReferencedUSR", testNoReferencedUSR),
            ("testSingleReferencedUSR", testSingleReferencedUSR),
            ("testRelatedReferencedUSR", testRelatedReferencedUSR)
        ]
    }
}
