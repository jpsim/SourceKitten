import Foundation
@testable import SourceKittenFramework
import XCTest

func compareJSONString(withFixtureNamed name: String,
                       jsonString: CustomStringConvertible,
                       rootDirectory: String = fixturesDirectory,
                       file: StaticString = #file,
                       line: UInt = #line) {
    let jsonString = String(describing: jsonString)

    // Strip out fixtures directory since it's dependent on the test machine's setup
#if os(Windows)
    let escapedFixturesDirectory = URL(fileURLWithPath: rootDirectory)
        .standardizedFileURL
        .withUnsafeFileSystemRepresentation { String(cString: $0!) }
        .replacingOccurrences(of: #"\"#, with: #"\\"#)
        .replacingOccurrences(of: "/", with: #"\/"#)
#else
    let escapedFixturesDirectory = rootDirectory.replacingOccurrences(of: "/", with: "\\/")
#endif
    let escapedJSONString = jsonString.replacingOccurrences(of: escapedFixturesDirectory, with: "")

    // Strip out any other absolute paths after that, since it's also dependent on the test machine's setup
    let absolutePathRegex = try! NSRegularExpression(pattern: "\"key\\.filepath\" : \"\\\\/[^\\\n]+", options: [])
    let actualContent = absolutePathRegex.stringByReplacingMatches(in: escapedJSONString, options: [],
                                                                   range: NSRange(location: 0, length: escapedJSONString.bridge().length),
                                                                   withTemplate: "\"key\\.filepath\" : \"\",")
    let expectedFile = File(path: versionedExpectedFilename(for: name))!

    // Use if changes are introduced by changes in SourceKitten.
    let overwrite = ProcessInfo.processInfo.environment["OVERWRITE_FIXTURES"] != nil ? true : false
    if overwrite && actualContent != expectedFile.contents {
        _ = try? actualContent.data(using: .utf8)?.write(to: URL(fileURLWithPath: expectedFile.path!), options: [])
        return
    }

    // Use if changes are introduced by the new Swift version.
    let appendFixturesForNewSwiftVersion = ProcessInfo.processInfo.environment["APPEND_FIXTURES"] != nil ? true : false
    if appendFixturesForNewSwiftVersion && actualContent != expectedFile.contents,
        var path = expectedFile.path, let index = path.firstIndex(of: "@"),
        !path.hasSuffix("@\(buildingSwiftVersion).json") {
        path.replaceSubrange(index..<path.endIndex, with: "@\(buildingSwiftVersion).json")
        _ = try? actualContent.data(using: .utf8)?.write(to: URL(fileURLWithPath: path), options: [])
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
        print(diff(original: expectedFile.contents, modified: actualContent))
    }
}

private func compareDocs(withFixtureNamed name: String, file: StaticString = #file, line: UInt = #line) {
    let swiftFilePath = fixturesDirectory + name + ".swift"
    let docs = SwiftDocs(file: File(path: swiftFilePath)!, arguments: ["-j4", "-sdk", sdkPath(), swiftFilePath])!
    compareJSONString(withFixtureNamed: name, jsonString: docs, file: file, line: line)
}

// swiftlint:disable:next function_body_length
private func versionedExpectedFilename(for name: String) -> String {
    var versionNumbers = [String]()
#if compiler(>=6.4)
    versionNumbers += ["6.4"]
#endif
#if compiler(>=6.3)
    versionNumbers += ["6.3"]
#endif
#if compiler(>=6.0)
    versionNumbers += ["6.0"]
#endif
#if compiler(>=5.10)
    versionNumbers += ["5.10"]
#endif
#if compiler(>=5.9)
    versionNumbers += ["5.9"]
#endif
#if compiler(>=5.8)
    versionNumbers += ["5.8"]
#endif
#if compiler(>=5.6)
    versionNumbers += ["5.6"]
#endif
#if compiler(>=5.5)
    versionNumbers += ["5.5"]
#endif
#if compiler(>=5.4)
    versionNumbers += ["5.4"]
#endif
#if compiler(>=5.3.1)
    versionNumbers += ["5.3.1"]
#endif
#if compiler(>=5.3)
    versionNumbers += ["5.3"]
#endif
    versionNumbers += ["5.0", "5.1", "5.2"]

    let versions = versionNumbers.map { "swift-\($0)" }

#if os(Linux)
    let platforms = ["Linux", ""]
#elseif os(Windows)
    let platforms = ["Windows", ""]
#else
    let platforms = [""]
#endif
    for platform in platforms {
        for version in versions {
            let versionedFilename = "\(fixturesDirectory)\(platform)\(name)@\(version).json"
            if FileManager.default.fileExists(atPath: versionedFilename) {
                return versionedFilename
            }
        }
    }
    return "\(fixturesDirectory)\(name).json"
}

private func diff(original: String, modified: String) -> String {
    do {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("SwiftDocsTests-diff-\(NSUUID())")
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

        try original.data(using: .utf8)?.write(to: url.appendingPathComponent("original.json"))
        try modified.data(using: .utf8)?.write(to: url.appendingPathComponent("modified.json"))

        return Exec.run("/usr/bin/env", "git", "diff", "original.json", "modified.json",
                        currentDirectory: url.path).string ?? ""
    } catch {
        return "\(error)"
    }
}

private let buildingSwiftVersion: String = {
#if compiler(>=6.4)
    return "swift-6.4"
#elseif compiler(>=6.3)
    return "swift-6.3"
#elseif compiler(>=6.0)
    return "swift-6.0"
#elseif compiler(>=5.10)
    return "swift-5.10"
#elseif compiler(>=5.9)
    return "swift-5.9"
#elseif compiler(>=5.8)
    return "swift-5.8"
#elseif compiler(>=5.6)
    return "swift-5.6"
#elseif compiler(>=5.5.0)
    return "swift-5.5"
#elseif compiler(>=5.4.0)
    return "swift-5.4"
#elseif compiler(>=5.3.1)
    return "swift-5.3.1"
#elseif compiler(>=5.3)
    return "swift-5.3"
#else
    return "swift-5.2"
#endif
}()

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
            ] as [String: Any]],
            "key.doc.result_discussion": [["Para": "result_discussion"]]
        ]
        XCTAssertEqual(toNSDictionary(parsedPreSwift32), expected)
        XCTAssertEqual(toNSDictionary(parsedSwift32), expected)
    }

    // #606 - create docs without crashing
    func testParseExternalReference() {
        let firstPath = fixturesDirectory + "ExternalRef1.swift"
        let secondPath = fixturesDirectory + "ExternalRef2.swift"
        let docs = SwiftDocs(file: File(path: firstPath)!, arguments: ["-sdk", sdkPath(), firstPath, secondPath])!
        XCTAssertFalse(docs.docsDictionary.isEmpty)
    }
}
