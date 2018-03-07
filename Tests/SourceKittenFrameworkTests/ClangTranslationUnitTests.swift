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

    private func compare(clangFixture fixture: String) {
        let unit = ClangTranslationUnit(headerFiles: [fixturesDirectory + fixture + ".h"],
                                        compilerArguments: ["-x", "objective-c", "-isysroot", sdkPath(), "-I", fixturesDirectory])
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
}

#endif
