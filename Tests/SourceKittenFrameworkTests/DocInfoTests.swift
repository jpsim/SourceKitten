import Foundation
import SourceKittenFramework
import XCTest

class DocInfoTests: XCTestCase {
    /// Validates that various doc string formats are parsed correctly.
    func testDocInfoRequest() throws {
        let swiftFile = File(path: fixturesDirectory + "DocInfo.swift")!
        let info = toNSDictionary(
            try Request.docInfo(text: swiftFile.contents, arguments: ["-sdk", sdkPath()]).send()
        )
        compareJSONString(withFixtureNamed: "DocInfo", jsonString: toJSON(info))
    }
}

extension DocInfoTests {
    static var allTests: [(String, (DocInfoTests) -> () throws -> Void)] {
        return [
            ("testDocInfoRequest", testDocInfoRequest)
        ]
    }
}
