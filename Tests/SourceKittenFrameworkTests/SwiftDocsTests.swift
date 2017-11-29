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

func compareJSONString(withFixtureNamed name: String,
                       jsonString: CustomStringConvertible,
                       rootDirectory: String = fixturesDirectory,
                       overwrite: Bool = false,
                       file: StaticString = #file,
                       line: UInt = #line) {
    #if os(Linux)
    let jsonString = String(describing: jsonString).replacingOccurrences(of: rootDirectory, with: "")
    let actualContent = jsonString
    #else
    // Strip out fixtures directory since it's dependent on the test machine's setup
    let escapedFixturesDirectory = rootDirectory.replacingOccurrences(of: "/", with: "\\/")
    let jsonString = String(describing: jsonString).replacingOccurrences(of: escapedFixturesDirectory, with: "")

    // Strip out any other absolute paths after that, since it's also dependent on the test machine's setup
    let absolutePathRegex = try! NSRegularExpression(pattern: "\"key\\.filepath\" : \"\\\\/[^\\\n]+", options: [])
    let actualContent = absolutePathRegex.stringByReplacingMatches(in: jsonString, options: [],
                                                                   range: NSRange(location: 0, length: jsonString.bridge().length),
                                                                   withTemplate: "\"key\\.filepath\" : \"\",")
    #endif

    let versionedFilename = versionedExpectedFilename(for: name)
    print("Loading \(versionedFilename)")
    let expectedFile = File(path: versionedFilename)!

    if overwrite && actualContent != expectedFile.contents {
        _ = try? actualContent.data(using: .utf8)?.write(to: URL(fileURLWithPath: expectedFile.path!), options: [])
        return
    }

    func jsonValue(_ jsonString: String) -> NSObject {
        let data = jsonString.data(using: .utf8)!
        let result = try! JSONSerialization.jsonObject(with: data, options: [])
        if let dict = (result as? [String: Any])?.bridge() {
            return dict
        } else if let array = (result as? [Any])?.bridge() {
            return array
        }
        fatalError()
    }

    if jsonValue(actualContent) != jsonValue(expectedFile.contents) {
        XCTFail("output should match expected fixture", file: file, line: line)
        print("actual:\n\(actualContent)\nexpected:\n\(expectedFile.contents)")
    }
}

private func compareDocs(withFixtureNamed name: String, file: StaticString = #file, line: UInt = #line) {
    let swiftFilePath = fixturesDirectory + name + ".swift"
    let docs = SwiftDocs(file: File(path: swiftFilePath)!, arguments: ["-j4", swiftFilePath])!
    compareJSONString(withFixtureNamed: name, jsonString: docs, file: file, line: line)
}

private func versionedExpectedFilename(for name: String) -> String {
    #if swift(>=4.0.2)
        let versions = ["swift-4.0.2", "swift-3.2.2", "swift-4.0", "swift-3.2"]
    #elseif swift(>=4.0)
        let versions = ["swift-4.0", "swift-3.2"]
    #elseif swift(>=3.2.2)
        let versions = ["swift-3.2.2", "swift-3.2"]
    #else // if swift(>=3.2)
        let versions = ["swift-3.2"]
    #endif
    #if os(Linux)
        let platforms = ["Linux", ""]
    #else
        let platforms = [""]
    #endif
    for version in versions {
        for platform in platforms {
            let versionedFilename = "\(fixturesDirectory)\(platform)\(name)@\(version).json"
            if FileManager.default.fileExists(atPath: versionedFilename) {
                return versionedFilename
            }
        }
    }
    return "\(fixturesDirectory)\(name).json"
}

class SwiftDocsTests: XCTestCase {

    func testSubscript() {
        compareDocs(withFixtureNamed: "Subscript")
    }

    func testBicycle() {
        compareDocs(withFixtureNamed: "Bicycle")
    }

    func testExtension() {
        compareDocs(withFixtureNamed: "Extension")
    }

    func testParseFullXMLDocs() {
        // swiftlint:disable:next line_length
        let xmlDocsStringPreSwift32 = "<Type file=\"file\" line=\"1\" column=\"2\"><Name>name</Name><USR>usr</USR><Declaration>declaration</Declaration><Abstract><Para>discussion</Para></Abstract><Parameters><Parameter><Name>param1</Name><Direction isExplicit=\"0\">in</Direction><Discussion><Para>param1_discussion</Para></Discussion></Parameter></Parameters><ResultDiscussion><Para>result_discussion</Para></ResultDiscussion></Type>"
        // swiftlint:disable:next line_length
        let xmlDocsStringSwift32 = "<Type file=\"file\" line=\"1\" column=\"2\"><Name>name</Name><USR>usr</USR><Declaration>declaration</Declaration><CommentParts><Abstract><Para>discussion</Para></Abstract><Parameters><Parameter><Name>param1</Name><Direction isExplicit=\"0\">in</Direction><Discussion><Para>param1_discussion</Para></Discussion></Parameter></Parameters><ResultDiscussion><Para>result_discussion</Para></ResultDiscussion></CommentParts></Type>"
        let parsedPreSwift32 = parseFullXMLDocs(xmlDocsStringPreSwift32)!
        let parsedSwift32 = parseFullXMLDocs(xmlDocsStringSwift32)!
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
        XCTAssertEqual(toNSDictionary(parsedPreSwift32), expected)
        XCTAssertEqual(toNSDictionary(parsedSwift32), expected)
    }
}

extension SwiftDocsTests {
    static var allTests: [(String, (SwiftDocsTests) -> () throws -> Void)] {
        return [
            ("testSubscript", testSubscript),
            ("testBicycle", testBicycle),
            ("testExtension", testExtension),
            ("testParseFullXMLDocs", testParseFullXMLDocs)
        ]
    }
}
