//
//  ModuleTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

#if !os(Linux)

import Foundation
import SourceKittenFramework
import XCTest

let projectRoot = (((#file as NSString)
    .deletingLastPathComponent as NSString)
    .deletingLastPathComponent as NSString)
    .deletingLastPathComponent

class ModuleTests: XCTestCase {

    func testModuleNilInPathWithNoXcodeProject() {
        let pathWithNoXcodeProject = (#file as NSString).deletingLastPathComponent
        let model = Module(xcodeBuildArguments: [], name: nil, inPath: pathWithNoXcodeProject)
        XCTAssert(model == nil, "model initialization without any Xcode project should fail")
    }

//    func testSourceKittenFrameworkDocsAreValidJSON() {
//        let sourceKittenModule = Module(xcodeBuildArguments: ["-workspace", "SourceKitten.xcworkspace", "-scheme", "SourceKittenFramework"], name: nil, inPath: projectRoot)!
//        let docsJSON = sourceKittenModule.docs.description
//        XCTAssert(docsJSON.rangeOfString("error type") == nil)
//        do {
//            let jsonArray = try NSJSONSerialization.JSONObjectWithData(docsJSON.dataUsingEncoding(NSUTF8StringEncoding)!, options: []) as? NSArray
//            XCTAssertNotNil(jsonArray, "JSON should be propery parsed")
//        } catch {
//            XCTFail("JSON should be propery parsed")
//        }
//    }
//
//    func testCommandantDocs() {
//        let commandantPath = projectRoot + "/Carthage/Checkouts/Commandant/"
//        let commandantModule = Module(xcodeBuildArguments: ["-workspace", "Commandant.xcworkspace", "-scheme", "Commandant"], name: nil, inPath: commandantPath)!
//        compareJSONStringWithFixturesName("Commandant", jsonString: commandantModule.docs, rootDirectory: commandantPath)
//    }
}

#endif
