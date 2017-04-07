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

    func testUnreadablePath() {
        XCTAssert(File(path: "/dev/wtf") == nil)
    }

    func testFormat() {
    #if swift(>=3.1) && os(Linux)
        // FIXME
        print("FIXME: Skip \(#function), because our sourcekitInProc on Swift 3.1 for Linux seems to be broken")
    #else
        let file = File(path: fixturesDirectory + "BicycleUnformatted.swift")
        let formattedFile = try! file?.format(trimmingTrailingWhitespace: true,
                                         useTabs: false,
                                         indentWidth: 4)
        XCTAssertEqual(formattedFile!, try! String(contentsOfFile: fixturesDirectory + "Bicycle.swift", encoding: .utf8))
    #endif
    }
}

extension FileTests {
    static var allTests: [(String, (FileTests) -> () throws -> Void)] {
        return [
            ("testUnreadablePath", testUnreadablePath),
            ("testFormat", testFormat)
        ]
    }
}
