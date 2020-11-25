import Foundation
import SnapshotTesting
import SourceKittenFramework
import XCTest

let fixturesDirectory = URL(fileURLWithPath: #file).deletingLastPathComponent().path + "/Fixtures/"

#if !os(Linux)

class ClangTranslationUnitTests: XCTestCase {
    func testParsesObjectiveCHeaderFilesAndXcodebuildArguments() {
        let headerFiles = [
            "a.h",
            "b.hpp",
            "c.hh"
        ]
        let xcodebuildArguments = [
            "arg1",
            "arg2"
        ]
        let (parsedHeaderFiles, parsedXcodebuildArguments) = parseHeaderFilesAndXcodebuildArguments(sourcekittenArguments: headerFiles + xcodebuildArguments)
        XCTAssertEqual(parsedHeaderFiles, headerFiles.map({ $0.bridge().absolutePathRepresentation() }), "Objective-C header files should be parsed")
        XCTAssertEqual(parsedXcodebuildArguments, xcodebuildArguments, "xcodebuild arguments should be parsed")
    }

    func translationUnit(forFixture fixture: String) -> ClangTranslationUnit {
        return ClangTranslationUnit(
            headerFiles: [fixturesDirectory + fixture + ".h"],
            compilerArguments: ["-x", "objective-c", "-isysroot", sdkPath(), "-I", fixturesDirectory]
        )
    }

    func testBasicObjectiveCDocs() {
        let unit = translationUnit(forFixture: "Musician")
        assertSourceKittenSnapshot(matching: unit, as: .clangJSON, named: nil)
    }

    func testUnicodeInObjectiveCDocs() {
        let unit = translationUnit(forFixture: "SuperScript")
        assertSourceKittenSnapshot(matching: unit, as: .clangJSON, named: nil)
    }

    func testRealmObjectiveCDocs() {
        let unit = translationUnit(forFixture: "Realm/Realm")
        assertSourceKittenSnapshot(matching: unit, as: .clangJSON, named: nil)
    }

    func testCodeFormattingObjectiveCDocs() {
        let unit = translationUnit(forFixture: "CodeFormatting")
        assertSourceKittenSnapshot(matching: unit, as: .clangJSON, named: nil)
    }
}

#endif
