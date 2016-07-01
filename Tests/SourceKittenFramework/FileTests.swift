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

#if !os(Linux)
    func testFormat() {
        let file = File(path: fixturesDirectory + "BicycleUnformatted.swift")
        let formattedFile = file?.format(trimmingTrailingWhitespace: true,
                                         useTabs: false,
                                         indentWidth: 4)
        XCTAssertEqual(formattedFile!, try! String(contentsOfFile: fixturesDirectory + "Bicycle.swift"))
    }
#endif
}

#if os(Linux)
extension FileTests {
    static var allTests: [(String, (FileTests) -> () throws -> Void)] {
        return [
            ("testUnreadablePath", testUnreadablePath),
        ]
    }
}
#endif
