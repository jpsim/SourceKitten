//
//  FileTests.swift
//  SourceKitten
//
//  Created by JP Simard on 7/15/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import SourceKittenFramework
import XCTest

class FileTests: XCTestCase {

    // protocol XCTestCaseProvider
    lazy var allTests: [(String, () throws -> Void)] = [
        ("testUnreadablePath", self.testUnreadablePath)
    ]

    func testUnreadablePath() {
        XCTAssert(File(path: "/dev/null") == nil)
    }
}
