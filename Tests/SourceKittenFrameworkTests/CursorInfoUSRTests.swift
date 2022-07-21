import Foundation
import SourceKittenFramework
import XCTest

class CursorInfoUSRTests: XCTestCase {

    /// Validates that cursorInfo is parsed correctly.
    func testCursorInfoUSRRequest() throws {
        let path = fixturesDirectory + "DocInfo.swift"

        let info = toNSDictionary(
            try Request.cursorInfoUSR(
                file: path,
                usr: "s:7DocInfo16DocumentedStructV",
                arguments: ["-sdk", sdkPath(), path],
                cancelOnSubsequentRequest: false
            ).send()
        )
        compareJSONString(withFixtureNamed: "CursorInfoUSR", jsonString: toJSON(info))
    }
}
