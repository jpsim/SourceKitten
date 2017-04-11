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

class DocInfoTests: XCTestCase {

    /// Validates that various doc string formats are parsed correctly.
    func testDocInfoRequest() {
        let swiftFile = File(path: fixturesDirectory + "DocInfo.swift")!
        let info = try! Request.docInfo(text: swiftFile.contents,
                                        arguments: ["-sdk", sdkPath()]).failableSend()
        compareJSONString(withFixtureNamed: "DocInfo", jsonString: toJSON(info.any))
    }

    func testModuleInfoRequest() {
        let swiftFile = fixturesDirectory + "DocInfo.swift"
        let info = try! Request.moduleInfo(module: "",
                                           arguments: [
                                            "-c", swiftFile,
                                            "-module-name", "DocInfo",
                                            "-sdk", sdkPath()]).failableSend()
        compareJSONString(withFixtureNamed: "ModuleInfo", jsonString: toJSON(info.any))
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
