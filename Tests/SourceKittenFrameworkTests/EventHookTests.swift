import Foundation
@testable import SourceKittenFramework
import XCTest

class EventHookTests: XCTestCase {
#if os(macOS) || os(Linux)
    func testDefaultHandlerPreservesStandardError() throws {
        let path = "/sourcekitten-missing-\(UUID())/source.swift"
        let output = try captureStandardError {
            XCTAssertNil(File(path: path))
        }
        XCTAssertEqual(output, "Could not read contents of `\(path)`\n")
    }

    func testCustomHandlerDoesNotAlsoWriteToStandardError() throws {
        var messages: [String] = []
        let path = "/sourcekitten-missing-\(UUID())/source.swift"
        let output = try captureStandardError {
            XCTAssertNil(File(path: path, eventHook: EventHook { messages.append($0) }))
        }
        XCTAssertEqual(output, "")
        XCTAssertEqual(messages, ["Could not read contents of `\(path)`\n"])
    }

    private func captureStandardError(_ body: () -> Void) throws -> String {
        let pipe = Pipe()
        fflush(stderr)
        let original = dup(STDERR_FILENO)
        XCTAssertGreaterThanOrEqual(original, 0)
        guard original >= 0 else { return "" }
        defer { close(original) }
        XCTAssertGreaterThanOrEqual(dup2(pipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO), 0)
        body()
        fflush(stderr)
        XCTAssertGreaterThanOrEqual(dup2(original, STDERR_FILENO), 0)
        try pipe.fileHandleForWriting.close()
        return try XCTUnwrap(String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8))
    }
#endif

    func testCustomHandlerPreservesMessageBytesAndOrder() {
        var messages: [String] = []
        let hook = EventHook { messages.append($0) }
        hook.emit("first\n")
        hook.emit("second")
        XCTAssertEqual(messages, ["first\n", "second"])
    }

    func testUnreadableFileUsesCustomHandler() {
        var messages: [String] = []
        let path = "/sourcekitten-missing-\(UUID())/source.swift"
        XCTAssertNil(File(path: path, eventHook: EventHook { messages.append($0) }))
        XCTAssertEqual(messages, ["Could not read contents of `\(path)`\n"])
    }

    func testDeferredReadReportsCachedFailureOnce() {
        var messages: [String] = []
        let path = "/sourcekitten-missing-\(UUID())/source.swift"
        let file = File(pathDeferringReading: path, eventHook: EventHook { messages.append($0) })
        XCTAssertTrue(messages.isEmpty)
        XCTAssertEqual(file.contents, "")
        XCTAssertEqual(file.contents, "")
        XCTAssertEqual(messages, ["Could not read contents of `\(path)`\n"])
        file.clearCaches()
        XCTAssertEqual(file.contents, "")
        XCTAssertEqual(messages.count, 2)
    }

    func testDeferredReadHandlerCanReadContentsAndStringView() {
        var file: File?
        defer { file = nil }
        var calls = 0
        let hook = EventHook { _ in
            calls += 1
            XCTAssertEqual(file?.contents, "")
            XCTAssertNotNil(file?.stringView)
        }
        file = File(pathDeferringReading: "/sourcekitten-missing-\(UUID())/source.swift", eventHook: hook)
        // Accessing stringView is important: its lock must not surround the callback.
        XCTAssertNotNil(file?.stringView)
        XCTAssertEqual(calls, 1)
    }

    func testIndependentFileHooksDoNotReplaceEachOther() {
        var firstMessages: [String] = []
        var secondMessages: [String] = []
        let firstPath = "/sourcekitten-missing-\(UUID())/first.swift"
        let secondPath = "/sourcekitten-missing-\(UUID())/second.swift"
        let first = File(pathDeferringReading: firstPath, eventHook: EventHook { firstMessages.append($0) })
        let second = File(pathDeferringReading: secondPath, eventHook: EventHook { secondMessages.append($0) })
        XCTAssertEqual(second.contents, "")
        XCTAssertEqual(first.contents, "")
        XCTAssertEqual(firstMessages, ["Could not read contents of `\(firstPath)`\n"])
        XCTAssertEqual(secondMessages, ["Could not read contents of `\(secondPath)`\n"])
    }

    func testDeferredReadHandlerCanReplaceContentsWithoutCachingStaleStringView() {
        var file: File?
        defer { file = nil }
        let hook = EventHook { _ in file?.contents = "recovered" }
        file = File(pathDeferringReading: "/sourcekitten-missing-\(UUID())/source.swift", eventHook: hook)
        XCTAssertEqual(file?.stringView.string, "recovered")
        XCTAssertEqual(file?.contents, "recovered")
        XCTAssertEqual(file?.stringView.string, "recovered")
    }

    func testDeferredReadHandlerCanClearCachesWithoutRetryLoop() {
        var file: File?
        defer { file = nil }
        var calls = 0
        let hook = EventHook { _ in
            calls += 1
            file?.clearCaches()
        }
        file = File(pathDeferringReading: "/sourcekitten-missing-\(UUID())/source.swift", eventHook: hook)
        XCTAssertEqual(file?.stringView.string, "")
        XCTAssertEqual(calls, 1)
        XCTAssertEqual(file?.stringView.string, "")
        XCTAssertEqual(calls, 2)
    }

    func testMissingSwiftPMManifestUsesCustomHandler() throws {
        try withDirectory { directory in
            var messages: [String] = []
            XCTAssertNil(Module(inPath: directory.path, eventHook: EventHook { messages.append($0) }))
            let manifest = directory.appendingPathComponent(".build/debug.yaml").path
            XCTAssertEqual(messages, ["SPM build manifest does not exist at `\(manifest)` or does not match expected format.\n"])
        }
    }

    func testMalformedSwiftPMManifestUsesCustomHandler() throws {
        try withDirectory { directory in
            let build = directory.appendingPathComponent(".build")
            try FileManager.default.createDirectory(at: build, withIntermediateDirectories: true)
            try "commands: [invalid".write(to: build.appendingPathComponent("debug.yaml"), atomically: true, encoding: .utf8)
            var messages: [String] = []
            XCTAssertNil(Module(inPath: directory.path, eventHook: EventHook { messages.append($0) }))
            XCTAssertEqual(messages.count, 1)
            XCTAssertTrue(messages[0].hasSuffix("does not match expected format.\n"))
        }
    }

    func testUnavailableSwiftPMModuleReportsAvailableModulesInOrder() throws {
        try withDirectory { directory in
            let build = directory.appendingPathComponent(".build")
            try FileManager.default.createDirectory(at: build, withIntermediateDirectories: true)
            let manifest = """
            commands:
              module:
                module-name: Available
                inputs: []
            """
            try manifest.write(to: build.appendingPathComponent("debug.yaml"), atomically: true, encoding: .utf8)
            var messages: [String] = []
            XCTAssertNil(Module(spmName: "Missing", inPath: directory.path, eventHook: EventHook { messages.append($0) }))
            XCTAssertEqual(messages, [
                "Could not find SPM module 'Missing'. Here are the modules available:\n",
                "  - Available\n"
            ])
        }
    }

    func testSwiftPMBuildFailureUsesCustomHandler() throws {
        try withDirectory { directory in
            var messages: [String] = []
            XCTAssertNil(Module(spmArguments: [], inPath: directory.path, eventHook: EventHook { messages.append($0) }))
            XCTAssertEqual(messages.count, 2)
            XCTAssertEqual(messages[0], "Running swift build\n")
            XCTAssertTrue(messages[1].hasPrefix("Build failed, saved `swift build` log file: "))
        }
    }

#if os(macOS)
    func testClangHeaderReadFailureUsesCustomHandler() throws {
        try withDirectory { directory in
            let header = directory.appendingPathComponent("Example.h")
            var contents = Data("// ".utf8)
            contents.append(0xFF)
            contents.append(Data("\nvoid example(void);\n".utf8))
            try contents.write(to: header)
            var messages: [String] = []
            _ = ClangTranslationUnit(headerFiles: [header.path], compilerArguments: ["-x", "objective-c"],
                                     eventHook: EventHook { messages.append($0) })
            XCTAssertEqual(messages, ["Could not read contents of `\(header.path)`\n"])
        }
    }

    func testXcodeBuildFailureUsesCustomHandler() throws {
        try withDirectory { directory in
            var messages: [String] = []
            XCTAssertNil(Module(xcodeBuildArguments: [], inPath: directory.path, eventHook: EventHook { messages.append($0) }))
            XCTAssertEqual(Array(messages.prefix(3)), [
                "Running xcodebuild\n",
                "Could not successfully run `xcodebuild`.\n",
                "Please check the build arguments.\n"
            ])
            XCTAssertEqual(messages.count, 4)
            XCTAssertTrue(messages[3].hasPrefix("Saved `xcodebuild` log file: "))
        }
    }

    func testClangBuildFailureUsesCustomHandler() throws {
        try withDirectory { directory in
            var messages: [String] = []
            XCTAssertNil(ClangTranslationUnit(headerFiles: [], xcodeBuildArguments: [], inPath: directory.path,
                                              eventHook: EventHook { messages.append($0) }))
            XCTAssertEqual(messages.count, 2)
            XCTAssertEqual(messages[0], "Running xcodebuild\n")
            XCTAssertTrue(messages[1].hasPrefix("could not parse compiler arguments\n"))
        }
    }
#endif

    func testModulePropagatesHookToDocumentation() throws {
        try withDirectory { directory in
            let source = directory.appendingPathComponent("Example.swift")
            try "/// Example.\nstruct Example {}\n".write(to: source, atomically: true, encoding: .utf8)
            var messages: [String] = []
            let module = Module(name: "Example", compilerArguments: [source.path], eventHook: EventHook { messages.append($0) })
            XCTAssertEqual(module.docs.count, 1)
            XCTAssertEqual(messages, ["Parsing Example.swift (1/1)\n"])
        }
    }

    func testModulePropagatesHookToUnreadableFile() throws {
        try withDirectory { directory in
            let source = directory.appendingPathComponent("Example.swift")
            try "struct Example {}\n".write(to: source, atomically: true, encoding: .utf8)
            var messages: [String] = []
            let module = Module(name: "Example", compilerArguments: [source.path], eventHook: EventHook { messages.append($0) })
            try FileManager.default.removeItem(at: source)
            XCTAssertTrue(module.docs.isEmpty)
            XCTAssertEqual(messages, [
                "Could not read contents of `\(source.path)`\n",
                "Could not parse `Example.swift`. Please open an issue at https://github.com/jpsim/SourceKitten/issues with the file contents.\n"
            ])
        }
    }

    func testOriginalInitializerFunctionReferencesRemainAvailable() {
        let fileInitializer: (String) -> File? = File.init(path:)
        let deferredInitializer: (String) -> File = File.init(pathDeferringReading:)
        let moduleInitializer: (String, [String]) -> Module = Module.init(name:compilerArguments:)
        let docsInitializer: (File, [String]) -> SwiftDocs? = SwiftDocs.init(file:arguments:)
        _ = (fileInitializer, deferredInitializer, moduleInitializer, docsInitializer)
    }

    private func withDirectory(_ body: (URL) throws -> Void) throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent("EventHookTests-\(UUID())")
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        try body(directory)
    }
}
