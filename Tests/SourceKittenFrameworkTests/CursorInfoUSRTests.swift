//
//  CursorInfoUSRTests.swift
//  SourceKittenFrameworkTests
//
//  Created by Timofey Solonin on 14/05/19.
//  Copyright © 2019 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

class CursorInfoUSRTests: XCTestCase {

    /// Validates that cursorInfo is parsed correctly.
    func testCursorInfoUSRRequest() throws {
        let path = fixturesDirectory + "DocInfo.swift"

        let info = toNSDictionary(
            try Request.cursorInfoUSR(
                file: path,
                usr: "s:7DocInfo16DocumentedStructV",
                arguments: ["-sdk", sdkPath(), path],
                cancelOnSubsequentRequest: false
            ).send()
        )
        compareJSONString(withFixtureNamed: "CursorInfoUSR", jsonString: toJSON(info))
    }
}

extension CursorInfoUSRTests {
    static var allTests: [(String, (CursorInfoUSRTests) -> () throws -> Void)] {
        return [
            ("testCursorInfoUSRRequest", testCursorInfoUSRRequest)
        ]
    }
}
