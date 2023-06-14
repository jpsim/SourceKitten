import Foundation
import SourceKittenFramework
import XCTest

let testWorkspaceDirectory: String? = {
    if let buildWorkspaceRoot: String = ProcessInfo.processInfo.environment["PROJECT_ROOT"] {
        return buildWorkspaceRoot + "/Tests/SourceKittenFrameworkTests/Fixtures/"
    }
    return nil
}()
let fixturesDirectory = testWorkspaceDirectory ?? (URL(fileURLWithPath: #file).deletingLastPathComponent().path + "/Fixtures/")

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

    private func compare(clangFixture fixture: String) {
        let path = URL(fileURLWithPath: fixturesDirectory + fixture + ".h")
            .standardizedFileURL
            .withUnsafeFileSystemRepresentation { String(cString: $0!) }
        let includes = URL(fileURLWithPath: fixturesDirectory)
            .standardizedFileURL
            .withUnsafeFileSystemRepresentation { String(cString: $0!) }
        let unit = ClangTranslationUnit(headerFiles: [path],
                                        compilerArguments: ["-x", "objective-c", "-isysroot", sdkPath(), "-I", includes])
        compareJSONString(withFixtureNamed: (fixture as NSString).lastPathComponent, jsonString: unit)
    }

    func testBasicObjectiveCDocs() {
        compare(clangFixture: "Musician")
    }

    func testUnicodeInObjectiveCDocs() {
        compare(clangFixture: "SuperScript")
    }

    func testRealmObjectiveCDocs() {
        compare(clangFixture: "Realm/Realm")
    }

    func testCodeFormattingObjectiveCDocs() {
        compare(clangFixture: "CodeFormatting")
    }

    func testUnionObjectiveCDocs() {
        compare(clangFixture: "Union")
    }
}

#endif
