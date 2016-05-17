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

func compareJSONStringWithFixturesName(name: String, jsonString: CustomStringConvertible, rootDirectory: String = fixturesDirectory) {
    func jsonValue(jsonString: String) -> AnyObject {
        let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)!
        let result = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
        return (result as? NSDictionary) ?? (result as! NSArray)
    }

    // Strip out fixtures directory since it's dependent on the test machine's setup
    let escapedFixturesDirectory = rootDirectory.stringByReplacingOccurrencesOfString("/", withString: "\\/")
    let jsonString = String(jsonString).stringByReplacingOccurrencesOfString(escapedFixturesDirectory, withString: "")

    // Strip out any other absolute paths after that, since it's also dependent on the test machine's setup
    let absolutePathRegex = try! NSRegularExpression(pattern: "\"key\\.filepath\" : \"\\\\/[^\\\n]+", options: [])
    let actualContent = absolutePathRegex.stringByReplacingMatchesInString(jsonString, options: [], range: NSRange(location: 0, length: jsonString.utf16.count), withTemplate: "\"key\\.filepath\" : \"\",")

    let expectedFile = File(path: fixturesDirectory + name + ".json")!

    let overwrite = false
    if overwrite && actualContent != expectedFile.contents {
        _ = try? actualContent.dataUsingEncoding(NSUTF8StringEncoding)?.writeToFile(expectedFile.path!, options: .AtomicWrite)
        return
    }

    let actualValue = jsonValue(actualContent)
    let expectedValue = jsonValue(expectedFile.contents)
    let message = "output should match expected fixture"
    func AssertEqual(firstValue: NSObject, _ secondValue: NSObject) {
        if firstValue != secondValue {
            XCTFail(message)
            print("actual:\n\(actualContent)\nexpected:\n\(expectedFile.contents)")
        }
    }
    if let firstValue = actualValue as? NSDictionary, secondValue = expectedValue as? NSDictionary {
        AssertEqual(firstValue, secondValue)
    } else if let firstValue = actualValue as? NSArray, secondValue = expectedValue as? NSArray {
        AssertEqual(firstValue, secondValue)
    } else {
        XCTFail("output didn't match fixture type")
    }
}

func compareDocsWithFixturesName(name: String) {
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
        XCTAssertEqual(toAnyObject(parsed), expected)
    }
}
