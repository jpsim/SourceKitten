//
//  DocInfoTests.swift
//  SourceKitten
//
//  Created by Erik Abair on 10/25/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

#if os(Linux)
let sdkArgs: [String] = []
#else
let sdkArgs = ["-sdk", sdkPath()]
#endif

class DocInfoTests: XCTestCase {

    /// Validates that various doc string formats are parsed correctly.
    func testDocInfoRequest() {
        let swiftFile = File(path: fixturesDirectory + "DocInfo.swift")!
        let info = toNSDictionary(
            try! Request.docInfo(text: swiftFile.contents, arguments: sdkArgs).send()
        )
        compareJSONString(withFixtureNamed: "DocInfo", jsonString: toJSON(info))
    }

    func testModuleInfoRequest() {
        let swiftFile = fixturesDirectory + "DocInfo.swift"
        let info = toNSDictionary(
            try! Request.moduleInfo(module: "",
                                    arguments: [
                                        "-c", swiftFile,
                                        "-module-name", "DocInfo"
                ] + sdkArgs).send()
        )
        compareJSONString(withFixtureNamed: "ModuleInfo", jsonString: toJSON(info))
    }
}

extension DocInfoTests {
    static var allTests: [(String, (DocInfoTests) -> () throws -> Void)] {
        return [
            ("testDocInfoRequest", testDocInfoRequest),
            ("testModuleInfoRequest", testModuleInfoRequest)
        ]
    }
}
