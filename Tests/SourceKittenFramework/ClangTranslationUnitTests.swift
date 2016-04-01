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

let fixturesDirectory = (#file as NSString).stringByDeletingLastPathComponent + "/Fixtures/"

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
        let (parsedHeaderFiles, parsedXcodebuildArguments) = parseHeaderFilesAndXcodebuildArguments(headerFiles + xcodebuildArguments)
        XCTAssertEqual(parsedHeaderFiles, headerFiles.map({$0.absolutePathRepresentation()}), "Objective-C header files should be parsed")
        XCTAssertEqual(parsedXcodebuildArguments, xcodebuildArguments, "xcodebuild arguments should be parsed")
    }

    private func compareClangFixture(fixture: String) {
        let tu = ClangTranslationUnit(headerFiles: [fixturesDirectory + fixture + ".h"],
                                      compilerArguments: ["-x", "objective-c", "-isysroot", sdkPath(), "-I", fixturesDirectory])
        compareJSONStringWithFixturesName((fixture as NSString).lastPathComponent, jsonString: tu)
    }

    func testBasicObjectiveCDocs() {
        compareClangFixture("Musician")
    }
    
    func testUnicodeInObjectiveCDocs() {
        compareClangFixture("SuperScript")
    }

    func testRealmObjectiveCDocs() {
        compareClangFixture("Realm/Realm")
    }
}
