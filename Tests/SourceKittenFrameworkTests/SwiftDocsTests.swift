//
//  SwiftDocsTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

func compareJSONStringWithFixturesName(_ name: String, jsonString: CustomStringConvertible, rootDirectory: String = fixturesDirectory) {
    // Strip out fixtures directory since it's dependent on the test machine's setup
    let escapedFixturesDirectory = rootDirectory.replacingOccurrences(of: "/", with: "\\/")
    let jsonString = String(describing: jsonString).replacingOccurrences(of: escapedFixturesDirectory, with: "")

    // Strip out any other absolute paths after that, since it's also dependent on the test machine's setup
    let absolutePathRegex = try! NSRegularExpression(pattern: "\"key\\.filepath\" : \"\\\\/[^\\\n]+", options: [])
    let actualContent = absolutePathRegex.stringByReplacingMatches(in: jsonString, options: [], range: NSRange(location: 0, length: jsonString.utf16.count), withTemplate: "\"key\\.filepath\" : \"\",")

    let expectedFile = File(path: fixturesDirectory + name + ".json")!

    let overwrite = false
    if overwrite && actualContent != expectedFile.contents {
        _ = try? actualContent.data(using: .utf8)?.write(to: URL(fileURLWithPath: expectedFile.path!), options: [])
        return
    }

    func jsonValue(_ jsonString: String) -> NSObject {
        let data = jsonString.data(using: .utf8)!
        let result = try! JSONSerialization.jsonObject(with: data, options: [])
        return (result as? NSDictionary) ?? (result as! NSArray)
    }

    if jsonValue(actualContent) != jsonValue(expectedFile.contents) {
        XCTFail("output should match expected fixture")
        print("actual:\n\(actualContent)\nexpected:\n\(expectedFile.contents)")
    }
}

func compareDocsWithFixturesName(_ name: String) {
    let swiftFilePath = fixturesDirectory + name + ".swift"
    let docs = SwiftDocs(file: File(path: swiftFilePath)!, arguments: ["-j4", swiftFilePath])!
    compareJSONStringWithFixturesName(name, jsonString: docs)
}

class SwiftDocsTests: XCTestCase {

    func testSubscript() {
        compareDocsWithFixturesName("Subscript")
    }

    func testBicycle() {
        compareDocsWithFixturesName("Bicycle")
    }

#if !os(Linux)
    func testParseFullXMLDocs() {
        let xmlDocsString = "<Type file=\"file\" line=\"1\" column=\"2\"><Name>name</Name><USR>usr</USR><Declaration>declaration</Declaration><Abstract><Para>discussion</Para></Abstract><Parameters><Parameter><Name>param1</Name><Direction isExplicit=\"0\">in</Direction><Discussion><Para>param1_discussion</Para></Discussion></Parameter></Parameters><ResultDiscussion><Para>result_discussion</Para></ResultDiscussion></Type>"
        let parsed = parseFullXMLDocs(xmlDocsString)!
        let expected: NSDictionary = [
            "key.doc.type": "Type",
            "key.doc.file": "file",
            "key.doc.line": 1,
            "key.doc.column": 2,
            "key.doc.name": "name",
            "key.usr": "usr",
            "key.doc.declaration": "declaration",
            "key.doc.parameters": [[
                "name": "param1",
                "discussion": [["Para": "param1_discussion"]]
            ]],
            "key.doc.result_discussion": [["Para": "result_discussion"]]
        ]
        XCTAssertEqual(toNSDictionary(parsed), expected)
    }
#endif
}

extension SwiftDocsTests {
    static var allTests: [(String, (SwiftDocsTests) -> () throws -> Void)] {
        return [
            // ("testSubscript", testSubscript),
            // ("testBicycle", testBicycle),
            // ("testParseFullXMLDocs", testParseFullXMLDocs),
        ]
    }
}
