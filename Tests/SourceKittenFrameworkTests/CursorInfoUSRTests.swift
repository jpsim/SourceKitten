import Foundation
import SourceKittenFramework
import XCTest

class CursorInfoUSRTests: XCTestCase {
    /// Validates that cursorInfo is parsed correctly.
    func testCursorInfoUSRRequest() throws {
        let path = fixturesDirectory + "DocInfo.swift"

        let info = try Request.cursorInfoUSR(
            file: path,
            usr: "s:7DocInfo16DocumentedStructV",
            arguments: ["-sdk", sdkPath(), path],
            cancelOnSubsequentRequest: false
        ).send()
        assertSourceKittenSnapshot(matching: info, as: .sourcekitJSON)
    }
}

extension CursorInfoUSRTests {
    static var allTests: [(String, (CursorInfoUSRTests) -> () throws -> Void)] {
        return [
            ("testCursorInfoUSRRequest", testCursorInfoUSRRequest)
        ]
    }
}
