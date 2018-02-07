//
//  SourceKitObjectTests.swift
//  SourceKitten
//
//  Created by Norio Nomura on 2/7/18.
//  Copyright © 2018 SourceKitten. All rights reserved.
//

import SourceKittenFramework
import XCTest

class SourceKitObjectTests: XCTestCase {

    func testExample() {
        let path = #file
        let object: SourceKitObject = [
            "key.request": UID("source.request.editor.open"),
            "key.name": path,
            "key.sourcefile": path
        ]
        let expected = """
            {
              key.request: source.request.editor.open,
              key.name: \"\(#file)\",
              key.sourcefile: \"\(#file)\"
            }
            """
        XCTAssertEqual(object.description, expected)
    }
}

extension SourceKitObjectTests {
    static var allTests: [(String, (SourceKitObjectTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample)
        ]
    }
}
