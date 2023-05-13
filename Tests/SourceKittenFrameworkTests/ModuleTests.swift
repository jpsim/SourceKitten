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
        let cloneArguments = ["clone", "https://github.com/Carthage/Commandant.git"]
        let cloneResult = Exec.run("C:\\Program Files\\Git\\cmd\\git.exe", cloneArguments, currentDirectory: temporaryURL.path)
        guard cloneResult.terminationStatus == 0 else {
            XCTFail("`\(cloneArguments.joined(separator: " "))` failed: \(cloneResult.terminationStatus)")
            return
        }

        let commandantPath = temporaryURL.appendingPathComponent("Commandant").path

        let checkoutArguments = ["checkout", "0.17.0"]
        let checkoutResult = Exec.run("C:\\Program Files\\Git\\cmd\\git.exe", checkoutArguments, currentDirectory: commandantPath)
        guard checkoutResult.terminationStatus == 0 else {
            XCTFail("`\(checkoutArguments.joined(separator: " "))` failed: \(checkoutResult.terminationStatus)")
            return
        }

        let submoduleArguments = ["submodule", "update", "--init", "--recursive"]
        let submoduleResult = Exec.run("C:\\Program Files\\Git\\cmd\\git.exe", submoduleArguments, currentDirectory: commandantPath)
        guard submoduleResult.terminationStatus == 0 else {
            XCTFail("`\(submoduleArguments.joined(separator: " "))` failed: \(submoduleResult.terminationStatus)")
            return
        }

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
        let cloneArguments = ["clone", "https://github.com/Carthage/Commandant.git"]
        let cloneResult = Exec.run("C:\\Program Files\\Git\\cmd\\git.exe", cloneArguments, currentDirectory: temporaryURL.path)
        guard cloneResult.terminationStatus == 0 else {
            XCTFail("`\(cloneArguments.joined(separator: " "))` failed: \(cloneResult.terminationStatus)")
            return
        }

        let commandantPath = temporaryURL.appendingPathComponent("Commandant").path

        let checkoutArguments = ["checkout", "0.17.0"]
        let checkoutResult = Exec.run("C:\\Program Files\\Git\\cmd\\git.exe", checkoutArguments, currentDirectory: commandantPath)
        guard checkoutResult.terminationStatus == 0 else {
            XCTFail("`\(checkoutArguments.joined(separator: " "))` failed: \(checkoutResult.terminationStatus)")
            return
        }

        let commandantModule = try XCTUnwrap(Module(spmArguments: [], spmName: "Commandant", inPath: commandantPath))
        compareJSONString(withFixtureNamed: "CommandantSPM", jsonString: commandantModule.docs,
                          rootDirectory: commandantPath)
    }

    func testSpmDefaultModule() {
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil
            && ProcessInfo.processInfo.environment["TEST_WORKSPACE"] == nil else {
            print(
                """
                Skipping \(#function) because we're running in Xcode and this test relies on the `.build` \
                directory being present.
                """
            )
            return
        }
        let skModule = Module(spmName: nil, inPath: projectRoot)
        XCTAssertEqual(skModule?.name, "SourceKittenFramework")
    }
}
