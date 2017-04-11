//
//  SourceKitObjectTests.swift
//  SourceKitten
//
//  Created by 野村 憲男 on 11/29/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import XCTest
@testable import SourceKittenFramework

class SourceKitObjectTests: XCTestCase {

    func testExample() {
        let path = #file
        let object: SourceKitObject = [
            .request: UID.SourceRequest.editorOpen,
            "key.name": path,
            "key.sourcefile": path
        ]
        let expected = [
            "{",
            "  key.request: source.request.editor.open,",
            "  key.name: \"\(#file)\",",
            "  key.sourcefile: \"\(#file)\"",
            "}"
        ].joined(separator: "\n")
        XCTAssertEqual(object.description, expected)
    }
}
