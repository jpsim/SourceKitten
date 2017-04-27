//
//  ModuleTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

let projectRoot = #file.bridge()
    .deletingLastPathComponent.bridge()
    .deletingLastPathComponent.bridge()
    .deletingLastPathComponent

let sourcekittenXcodebuildArguments = ["-workspace", "SourceKitten.xcworkspace", "-scheme", "SourceKittenFramework"]

class ModuleTests: XCTestCase {

    func testModuleNilInPathWithNoXcodeProject() {
        let pathWithNoXcodeProject = (#file as NSString).deletingLastPathComponent
        let model = Module(xcodeBuildArguments: [], name: nil, inPath: pathWithNoXcodeProject)
        XCTAssert(model == nil, "model initialization without any Xcode project should fail")
    }

    func testSourceKittenFrameworkDocsAreValidJSON() {
        let sourceKittenModule = Module(xcodeBuildArguments: sourcekittenXcodebuildArguments, name: nil, inPath: projectRoot)!
        let docsJSON = sourceKittenModule.docs.description
        XCTAssert(docsJSON.range(of: "error type") == nil)
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: docsJSON.data(using: .utf8)!, options: []) as? NSArray
            XCTAssertNotNil(jsonArray, "JSON should be propery parsed")
        } catch {
            XCTFail("JSON should be propery parsed")
        }
    }

    func testCommandantDocs() {
        let commandantPath = projectRoot + "/Carthage/Checkouts/Commandant/"
        let arguments = ["-workspace", "Commandant.xcworkspace", "-scheme", "Commandant"]
        let commandantModule = Module(xcodeBuildArguments: arguments, name: nil, inPath: commandantPath)!
        compareJSONString(withFixtureNamed: "Commandant", jsonString: commandantModule.docs, rootDirectory: commandantPath)
    }
}

#if SWIFT_PACKAGE
extension ModuleTests {
    func testCommandantDocsSPM() {
    #if swift(>=3.1) && os(Linux)
        // FIXME
        print("FIXME: Skip \(#function), because our sourcekitInProc on Swift 3.1 for Linux seems to be broken")
    #else
        func findCommandant(in directory: String) -> String? {
            guard let contents = try? FileManager.default.contentsOfDirectory(atPath: directory),
                let subDirectory = contents.first(where: { $0.hasPrefix("Commandant") }) else {
                    return nil
            }
            return directory + subDirectory + "/"
        }

        let checkoutDirectory: String
        #if swift(>=3.1)
            checkoutDirectory = "/.build/checkouts/"
        #else
            checkoutDirectory = "/Packages/"
        #endif
        guard let commandantPath = findCommandant(in: projectRoot + checkoutDirectory) else {
            XCTFail("Can't find Commandant")
            return
        }
        let commandantModule = Module(spmName: "Commandant")!
        compareJSONString(withFixtureNamed: "CommandantSPM", jsonString: commandantModule.docs, rootDirectory: commandantPath)
    #endif
    }

    static var allTests: [(String, (ModuleTests) -> () throws -> Void)] {
        return [
            // Disabled on Linux because these tests require Xcode
            // ("testModuleNilInPathWithNoXcodeProject", testModuleNilInPathWithNoXcodeProject),
            // ("testSourceKittenFrameworkDocsAreValidJSON", testSourceKittenFrameworkDocsAreValidJSON),
            // ("testCommandantDocs", testCommandantDocs),
            ("testCommandantDocsSPM", testCommandantDocsSPM)
        ]
    }
}
#endif
