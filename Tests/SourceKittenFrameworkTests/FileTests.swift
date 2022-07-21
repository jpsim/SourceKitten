import SourceKittenFramework
import XCTest

class FileTests: XCTestCase {

    func testUnreadablePath() {
        XCTAssert(File(path: "/dev/wtf") == nil)
    }

    func testFormat() throws {
        let file = File(path: fixturesDirectory + "BicycleUnformatted.swift")
        let formattedFile = try file?.format(trimmingTrailingWhitespace: true, useTabs: false, indentWidth: 4)
        XCTAssertEqual(formattedFile!, try String(contentsOfFile: fixturesDirectory + "Bicycle.swift", encoding: .utf8))
    }

    func testLinesRangesWhenUsingLineSeparator() {
        let file = File(contents: "// There're two U+2028 invisible characters after the colon:\u{2028}\u{2028}\nclass X {}")
        XCTAssertEqual(file.lines.count, 2)
        XCTAssertEqual(file.lines.last?.byteRange, ByteRange(location: 67, length: 10))
    }
}
