//
//  ClangTranslationUnitTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-12.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
@testable import SourceKittenFramework
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

    func testFiltersObjcArguments() {
        let xcodebuildOutput =
           "/usr/bin/false\n" +
           "\nNot even a command\n\n" +
           "/usr/bin/clang -dynamiclib args args args\n" +
           "/usr/bin/clang -x c -c something.c -o something.o\n" +
           "/usr/bin/clang -x objective-c -fmodule-name=TheWrongModule\n" +
           "/usr/bin/clang -x objective-c -fmodule-name=MyModule -I/include/path.hmap " +
           "--serialize-diagnostics diags -fbuild-session-file=sess -fmodules-validate-once-per-build-session " +
           "-fobjc-arc -fobjc-arch=386 -Os -Wdocumentation -Wimportant -q special -M cmake -c in.c -o out.o\n" +
           "/usr/bin/clang -x objective-c -fmodule-name=MyModule -I/include/wrong/path.hmap -c in2.c -o out2.o\n"

        let expectedFilteredArgs = [
            "-x", "objective-c",
            "-fmodule-name=MyModule",
            "-I/include/path.hmap",
            "-fobjc-arch=386",
            "-Wimportant",
            "-q", "special"
        ]

        guard let actualFilteredArgs = parseCompilerArguments(xcodebuildOutput: xcodebuildOutput.bridge(), language: .objc, moduleName: "MyModule") else {
            XCTFail("parseCompilerArguments returned nil")
            return
        }
        XCTAssertEqual(actualFilteredArgs, expectedFilteredArgs)
    }

    private func compare(clangFixture fixture: String, subdir: String = "") {
        let tu = ClangTranslationUnit(headerFiles: [fixturesDirectory + fixture + ".h"],
                                      compilerArguments: ["-x", "objective-c", "-isysroot", sdkPath(), "-I", fixturesDirectory + subdir])
        compareJSONString(withFixtureNamed: (fixture as NSString).lastPathComponent, jsonString: tu)
    }

    func testBasicObjectiveCDocs() {
        compare(clangFixture: "Musician")
    }

    func testUnicodeInObjectiveCDocs() {
        compare(clangFixture: "SuperScript")
    }

    func testRealmObjectiveCDocs() {
        compare(clangFixture: "Realm/Realm/Realm", subdir: "Realm")
    }
}

#endif
