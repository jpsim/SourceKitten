//
//  ModuleTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
@testable import SourceKittenFramework
import XCTest

let projectRoot = #file.bridge()
    .deletingLastPathComponent.bridge()
    .deletingLastPathComponent.bridge()
    .deletingLastPathComponent

class ModuleTests: XCTestCase {

    func testModuleNilInPathWithNoXcodeProject() {
        let pathWithNoXcodeProject = (#file as NSString).deletingLastPathComponent
        let model = Module(xcodeBuildArguments: [], name: nil, inPath: pathWithNoXcodeProject)
        XCTAssert(model == nil, "model initialization without any Xcode project should fail")
    }

    func testCommandantDocs() {
        let commandantPath = projectRoot + "/Carthage/Checkouts/Commandant/"
        let arguments = ["-workspace", "Commandant.xcworkspace", "-scheme", "Commandant"]
        let commandantModule = Module(xcodeBuildArguments: arguments, name: nil, inPath: commandantPath)!
        compareJSONString(withFixtureNamed: "Commandant", jsonString: commandantModule.docs, rootDirectory: commandantPath)
    }
}

#if SWIFT_PACKAGE
let commandantPathForSPM: String? = {
    struct Package: Decodable {
        var name: String
        var path: String
        var dependencies: [Package]
    }

    let arguments = ["swift", "package", "show-dependencies", "--format", "json"]
    let result = Exec.run("/usr/bin/env", arguments, currentDirectory: projectRoot)
    guard result.terminationStatus == 0 else {
        print("`\(arguments.joined(separator: " "))` returns error: \(result.terminationStatus)")
        return nil
    }
    do {
        let package = try JSONDecoder().decode(Package.self, from: result.data)
        return (package.dependencies.first(where: { $0.name == "Commandant" })?.path).map { $0 + "/" }
    } catch {
        print("failed to decode output of `\(arguments.joined(separator: " "))`: \(error)")
        return nil
    }
}()

extension ModuleTests {
    func testCommandantDocsSPM() {
        guard let commandantPath = commandantPathForSPM else {
            XCTFail("Can't find Commandant")
            return
        }
        let commandantModule = Module(spmArguments: [], spmName: "Commandant", inPath: projectRoot)!
        compareJSONString(withFixtureNamed: "CommandantSPM", jsonString: commandantModule.docs, rootDirectory: commandantPath)
    }

    func testSpmDefaultModule() {
        let skModule = Module(spmName: nil, inPath: projectRoot)!
        XCTAssertEqual("SourceKittenFramework", skModule.name)
    }

    static var allTests: [(String, (ModuleTests) -> () throws -> Void)] {
        return [
            // Disabled on Linux because these tests require Xcode
            // ("testModuleNilInPathWithNoXcodeProject", testModuleNilInPathWithNoXcodeProject),
            // ("testCommandantDocs", testCommandantDocs),
            ("testCommandantDocsSPM", testCommandantDocsSPM),
            ("testSpmDefaultModule", testSpmDefaultModule)
        ]
    }
}
#endif
