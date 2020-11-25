import Foundation
import SnapshotTesting
@testable import SourceKittenFramework
import XCTest

class DocInfoTests: XCTestCase {
    /// Validates that various doc string formats are parsed correctly.
    func testDocInfoRequest() throws {
        let swiftFile = File(path: fixturesDirectory + "DocInfo.swift")!
        let info = try Request.docInfo(text: swiftFile.contents, arguments: ["-sdk", sdkPath()]).send()
        assertSourceKittenSnapshot(matching: info, as: .sourcekitJSON)
    }
}

extension DocInfoTests {
    static var allTests: [(String, (DocInfoTests) -> () throws -> Void)] {
        return [
            ("testDocInfoRequest", testDocInfoRequest)
        ]
    }
}
