import Foundation
@testable import SourceKittenFramework
import XCTest

let bazelProjectRoot: String? = ProcessInfo.processInfo.environment["PROJECT_ROOT"]
let projectRoot: String = bazelProjectRoot ?? #file.bridge()
    .deletingLastPathComponent.bridge()
    .deletingLastPathComponent.bridge()
    .deletingLastPathComponent

class ModuleTests: XCTestCase {

#if os(macOS)

    func testModuleNilInPathWithNoXcodeProject() {
        let pathWithNoXcodeProject = (#file as NSString).deletingLastPathComponent
        let model = Module(xcodeBuildArguments: [], name: nil, inPath: pathWithNoXcodeProject)
        XCTAssert(model == nil, "model initialization without any Xcode project should fail")
    }

    func testCommandantDocs() throws {
        let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("\(#function)-\(NSUUID())")
        try FileManager.default.createDirectory(at: temporaryURL, withIntermediateDirectories: true)
        let cloneArguments = ["git", "clone", "https://github.com/Carthage/Commandant.git"]
        let cloneResult = Exec.run("/usr/bin/env", cloneArguments, currentDirectory: temporaryURL.path)
        guard cloneResult.terminationStatus == 0 else {
            XCTFail("`\(cloneArguments.joined(separator: " "))` failed: \(cloneResult.terminationStatus)")
            return
        }

        let commandantPath = temporaryURL.appendingPathComponent("Commandant").path

        let checkoutArguments = ["git", "checkout", "0.17.0"]
        let checkoutResult = Exec.run("/usr/bin/env", checkoutArguments, currentDirectory: commandantPath)
        guard checkoutResult.terminationStatus == 0 else {
            XCTFail("`\(checkoutArguments.joined(separator: " "))` failed: \(checkoutResult.terminationStatus)")
            return
        }

        let submoduleArguments = ["git", "submodule", "update", "--init", "--recursive"]
        let submoduleResult = Exec.run("/usr/bin/env", submoduleArguments, currentDirectory: commandantPath)
        guard submoduleResult.terminationStatus == 0 else {
            XCTFail("`\(submoduleArguments.joined(separator: " "))` failed: \(submoduleResult.terminationStatus)")
            return
        }

        let pbxprojURL = URL(fileURLWithPath: "\(commandantPath)/Commandant.xcodeproj/project.pbxproj")
        let originalPbxproj = try String(contentsOf: pbxprojURL)
        let newPbxproj = originalPbxproj.replacingOccurrences(
            of: "MACOSX_DEPLOYMENT_TARGET = 10.9",
            with: "MACOSX_DEPLOYMENT_TARGET = 12.0"
        )
        try newPbxproj.data(using: .utf8)?.write(to: pbxprojURL)
        let arguments = ["-workspace", "Commandant.xcworkspace", "-scheme", "Commandant"]
        let commandantModule = try XCTUnwrap(Module(xcodeBuildArguments: arguments, name: nil, inPath: commandantPath))
        compareJSONString(withFixtureNamed: "Commandant", jsonString: commandantModule.docs,
                          rootDirectory: commandantPath)
    }

#endif

    func testCommandantDocsSPM() throws {
        let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("\(#function)-\(NSUUID())")
        try FileManager.default.createDirectory(at: temporaryURL, withIntermediateDirectories: true)
        let cloneArguments = ["git", "clone", "https://github.com/Carthage/Commandant.git"]
        let cloneResult = Exec.run("/usr/bin/env", cloneArguments, currentDirectory: temporaryURL.path)
        guard cloneResult.terminationStatus == 0 else {
            XCTFail("`\(cloneArguments.joined(separator: " "))` failed: \(cloneResult.terminationStatus)")
            return
        }

        let commandantPath = temporaryURL.appendingPathComponent("Commandant").path

        let checkoutArguments = ["git", "checkout", "0.17.0"]
        let checkoutResult = Exec.run("/usr/bin/env", checkoutArguments, currentDirectory: commandantPath)
        guard checkoutResult.terminationStatus == 0 else {
            XCTFail("`\(checkoutArguments.joined(separator: " "))` failed: \(checkoutResult.terminationStatus)")
            return
        }

        let commandantModule = try XCTUnwrap(Module(spmArguments: [], spmName: "Commandant", inPath: commandantPath))
        compareJSONString(withFixtureNamed: "CommandantSPM", jsonString: commandantModule.docs,
                          rootDirectory: commandantPath)
    }

    private var isXcode: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil ||
        ProcessInfo.processInfo.environment["TEST_WORKSPACE"] != nil
    }

    func testSpmDefaultModuleXcode() throws {
        guard isXcode else {
            // `swift build` hangs if run from within `swift test` of the same package
            throw XCTSkip("Not running in Xcode.  Can't run `swift build` from within `swift test`: skipping.")
        }
        let skModule = Module(spmArguments: [], spmName: nil, inPath: projectRoot)
        XCTAssertEqual(skModule?.name, "SourceKittenFramework")
    }

#if compiler(<6.4)
    // Marking this test deprecated suppresses the deprecated warning on the
    // pre-6.4 module initializer.
    @available(*, deprecated)
    func testSpmDefaultModuleSpm() throws {
        guard !isXcode else {
            throw XCTSkip("Not running in Xcode, skipping")
        }
        let skModule = Module(spmName: nil, inPath: projectRoot)
        XCTAssertEqual(skModule?.name, "SourceKittenFramework")
    }
#endif
}
