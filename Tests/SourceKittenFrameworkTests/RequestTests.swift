//
//  RequestTests.swift
//  SourceKittenFrameworkTests
//
//  Created by Zheng Li on 05/10/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

class RequestTests: XCTestCase {
    func testProtocolVersion() {
        let version = Request.protocolVersion().send()
        compareJSONString(withFixtureNamed: "ProtocolVersion", jsonString: toJSON(toNSDictionary(version)))
    }

    func testSwiftModuleGroups() {
        let groups = Request.moduleGroups(module: "Swift", arguments: ["-sdk", sdkPath()]).send()
        compareJSONString(withFixtureNamed: "SwiftModuleGroups", jsonString: toJSON(toNSDictionary(groups)))
    }

    func testDemangle() {
        let mangledNames = [
            "_T0SSD",
            "_T0SC7NSRangeamD",
            "_T0So7ProcessCD",
            "_T021SourceKittenFramework7RequestOD",
            "_T0s10DictionaryVySS9Structure22SourceKitRepresentable_pGD"
        ]

        let expectedResult: NSDictionary = [
            "key.results": [
                ["key.name": "Swift.String"],
                ["key.name": "__C.NSRange.Type"],
                ["key.name": "__ObjC.Process"],
                ["key.name": "SourceKittenFramework.Request"],
                ["key.name": "Swift.Dictionary<Swift.String, Structure.SourceKitRepresentable>"]
            ]
        ]
        let result = Request.demangle(names: mangledNames).send()
        XCTAssertEqual(toNSDictionary(result), expectedResult, "should demange names.")
    }

    func testEditorOpenInterface() {
        let result = Request.editorOpenInterface(
            name: UUID().uuidString,
            moduleName: "Swift",
            group: .name("Assert"), // Choose a relative small group.
            synthesizedExtension: true,
            arguments: ["-sdk", sdkPath()]
        ).send()
        compareJSONString(withFixtureNamed: "SwiftAssertInterface", jsonString: toJSON(toNSDictionary(result)))
    }
}

extension RequestTests {
    static var allTests: [(String, (RequestTests) -> () throws -> Void)] {
        return [
            ("testProtocolVersion", testProtocolVersion),
            ("testSwiftModuleGroups", testSwiftModuleGroups),
            ("testEditorOpenInterface", testEditorOpenInterface)
        ]
    }
}
