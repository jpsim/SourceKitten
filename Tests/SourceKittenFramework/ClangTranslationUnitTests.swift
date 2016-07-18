//
//  ClangTranslationUnitTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-12.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

let fixturesDirectory: String = {
    let fileURL = URL(fileURLWithPath: #file)
    let parentURL = try! fileURL.deletingLastPathComponent()
    let fixturesURL = try! parentURL.appendingPathComponent("Fixtures")
    return fixturesURL.path! + "/"
}()

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
        XCTAssertEqual(parsedHeaderFiles, headerFiles.map({$0.absolutePathRepresentation()}), "Objective-C header files should be parsed")
        XCTAssertEqual(parsedXcodebuildArguments, xcodebuildArguments, "xcodebuild arguments should be parsed")
    }

    private func compareClangFixture(fixture: String) {
        let tu = ClangTranslationUnit(headerFiles: [fixturesDirectory + fixture + ".h"],
                                      compilerArguments: ["-x", "objective-c", "-isysroot", sdkPath(), "-I", fixturesDirectory])
        compareJSONStringWithFixturesName(fixture.bridge().lastPathComponent, jsonString: tu)
    }

    func testBasicObjectiveCDocs() {
        compareClangFixture(fixture: "Musician")
    }

    func testUnicodeInObjectiveCDocs() {
        compareClangFixture(fixture: "SuperScript")
    }

    func testRealmObjectiveCDocs() {
        compareClangFixture(fixture: "Realm/Realm")
    }
}

#endif
