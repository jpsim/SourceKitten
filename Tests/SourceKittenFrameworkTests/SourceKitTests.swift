import Foundation
@testable import SourceKittenFramework
import XCTest

private let sourcekitStrings: [String] = {
#if os(Linux)
    let searchPaths = [
        linuxSourceKitLibPath,
        linuxFindSwiftenvActiveLibPath,
        linuxFindSwiftInstallationLibPath,
        linuxDefaultLibPath
    ].compactMap({ $0 })
    let sourceKitPath: String = {
        for path in searchPaths {
            let sopath = "\(path)/libsourcekitdInProc.so"
            if FileManager.default.fileExists(atPath: sopath) {
                return sopath
            }
        }
        fatalError("Could not find or load libsourcekitdInProc.so")
    }()
#else
    let sourceKitPath = Exec.run("/usr/bin/xcrun", "-f", "swiftc").string!.bridge()
        .deletingLastPathComponent.bridge()
        .deletingLastPathComponent.bridge()
        .appendingPathComponent("lib/sourcekitd.framework/XPCServices/SourceKitService.xpc/Contents/MacOS/SourceKitService")
#endif
    let strings = Exec.run("/usr/bin/strings", sourceKitPath).string
    return strings!.components(separatedBy: "\n")
}()

private func sourcekitStrings(startingWith pattern: String) -> Set<String> {
    return Set(sourcekitStrings.filter { $0.hasPrefix(pattern) })
}

let sourcekittenXcodebuildArguments = [
    "-scheme", "sourcekitten"
] + { () -> [String] in
    return ProcessInfo.processInfo.environment["XCODE_VERSION_MINOR"].map { $0 >= "1000" } ?? false ? [] : [
        "-derivedDataPath",
        URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("testLibraryWrappersAreUpToDate").path
    ]
}()

class SourceKitTests: XCTestCase {

    func testStatementKinds() {
        let expected: [StatementKind] = [
            .brace,
            .case,
            .for,
            .forEach,
            .guard,
            .if,
            .repeatWhile,
            .switch,
            .while
        ]

        let actual = sourcekitStrings(startingWith: "source.lang.swift.stmt.")
        let expectedStrings = Set(expected.map { $0.rawValue })
        XCTAssertEqual(
            actual,
            expectedStrings
        )
        if actual != expectedStrings {
            print("the following strings were added: \(actual.subtracting(expectedStrings))")
            print("the following strings were removed: \(expectedStrings.subtracting(actual))")
        }
    }

    func testSyntaxKinds() {
        let expected = SyntaxKind.allCases

        let actual = sourcekitStrings(startingWith: "source.lang.swift.syntaxtype.")
        let expectedStrings = Set(expected.map { $0.rawValue })
        XCTAssertEqual(
            actual,
            expectedStrings
        )
        if actual != expectedStrings {
            print("the following strings were added: \(actual.subtracting(expectedStrings))")
            print("the following strings were removed: \(expectedStrings.subtracting(actual))")
        }
    }

    func testSwiftDeclarationKind() {
        var expected = Set(SwiftDeclarationKind.allCases)
        let actual = sourcekitStrings(startingWith: "source.lang.swift.decl.")
#if swift(>=2.2)
        expected.remove(.functionOperator)
#endif
#if !compiler(>=5.0)
        expected.remove(.functionAccessorModify)
        expected.remove(.functionAccessorRead)
#endif
#if !compiler(>=5.1)
        expected.remove(.opaqueType)
#endif
        let expectedStrings = Set(expected.map { $0.rawValue })
        XCTAssertEqual(
            actual,
            expectedStrings
        )
        if actual != expectedStrings {
            print("the following strings were added: \(actual.subtracting(expectedStrings))")
            print("the following strings were removed: \(expectedStrings.subtracting(actual))")
        }
    }

    func testSwiftDeclarationAttributeKind() { // swiftlint:disable:this function_body_length
        var expected = Set(SwiftDeclarationAttributeKind.allCases)
        let attributesFoundInSwift5ButWeIgnore = [
            "source.decl.attribute.GKInspectable",
            "source.decl.attribute.IBAction",
            "source.decl.attribute.IBOutlet"
        ]
        let actual = sourcekitStrings(startingWith: "source.decl.attribute.")
            .subtracting(attributesFoundInSwift5ButWeIgnore)

#if compiler(>=5.4)
        // removed in Swift 5.4
        expected.subtract([._functionBuilder])
#else
        // added in Swift 5.4
        expected.subtract([
            ._specializeExtension, .actor, .actorIndepedent, .async, .asyncHandler,
            .globalActor, .resultBuilder
        ])
#endif

#if compiler(>=5.3)
#else
        // added in Swift 5.3
        expected.subtract([._spi, ._typeEraser, .derivative, .main, .noDerivative, .transpose])
#endif

#if compiler(>=5.2)
        // removed in Swift 5.2
        expected.subtract([.implicitlyUnwrappedOptional])
#else
        // added in Swift 5.2
        expected.subtract([
            .differentiable, ._nonEphemeral, ._originallyDefinedIn, ._inheritsConvenienceInitializers,
            ._hasMissingDesignatedInitializers
        ])
#endif

#if compiler(>=5.0)
        // removed in Swift 5.0
        expected.subtract([.silStored, .effects])
#if !canImport(Darwin)
        // added in Swift 5.0 for Darwin
        expected.subtract([
            .__raw_doc_comment, .__setter_access, ._hasInitialValue, ._hasStorage, ._show_in_interface
        ])
#endif
#else
        // added in Swift 5.0
        expected.subtract([
            .__raw_doc_comment, .__setter_access, ._borrowed, ._dynamicReplacement, ._effects, ._hasInitialValue,
            ._hasStorage, ._nonoverride, ._private, ._show_in_interface, .dynamicCallable
        ])
#endif

#if compiler(>=5.1)
        // removed in Swift 5.1
        expected.subtract([.noreturn, ._frozen])
#if !canImport(Darwin)
        // added in Swift 5.1 for Darwin
        expected.subtract([
            .IBSegueAction
        ])
#endif
#else
        // added in Swift 5.1
        expected.subtract([
            .frozen, ._projectedValueProperty, ._alwaysEmitIntoClient, ._implementationOnly, .ibsegueaction, ._custom,
            ._disfavoredOverload, .propertyWrapper, .IBSegueAction, ._functionBuilder
        ])
#endif

        // removed in Swift 4.2
        expected.subtract([.objcNonLazyRealization, .inlineable, .versioned])
        // removed in Swift 4.1
        expected.subtract([.autoclosure, .noescape])

        let expectedStrings = Set(expected.map { $0.rawValue })
        XCTAssertEqual(
            actual,
            expectedStrings
        )
        if actual != expectedStrings {
            print("the following strings were added: \(actual.subtracting(expectedStrings))")
            print("the following strings were removed: \(expectedStrings.subtracting(actual))")
        }
    }

    func testLibraryWrappersAreUpToDate() throws {
#if compiler(>=5.4)
        let sourceKittenFrameworkModule = Module(xcodeBuildArguments: sourcekittenXcodebuildArguments,
                                                 name: "SourceKittenFramework", inPath: projectRoot)!
        let docsJSON = sourceKittenFrameworkModule.docs.description
        XCTAssert(docsJSON.range(of: "error type") == nil)
        let jsonArray = try JSONSerialization.jsonObject(with: docsJSON.data(using: .utf8)!, options: []) as? NSArray
        XCTAssertNotNil(jsonArray, "JSON should be properly parsed")
        let modules: [(module: String, path: String, linuxPath: String?)] = [
            ("Clang_C", "libclang.dylib", nil),
            ("SourceKit", "sourcekitd.framework/Versions/A/sourcekitd", "libsourcekitdInProc.so")
        ]
        for (module, path, linuxPath) in modules {
            let wrapperPath = "\(projectRoot)/Source/SourceKittenFramework/library_wrapper_\(module).swift"
            let existingWrapper = try String(contentsOfFile: wrapperPath)
            let generatedWrapper = try libraryWrapperForModule(
                module, loadPath: path, linuxPath: linuxPath,
                compilerArguments: sourceKittenFrameworkModule.compilerArguments
            )
            XCTAssertEqual(existingWrapper, generatedWrapper)
            let overwrite = false // set this to true to overwrite existing wrappers with the generated ones
            if existingWrapper != generatedWrapper && overwrite {
                try generatedWrapper.data(using: .utf8)?.write(to: URL(fileURLWithPath: wrapperPath))
            }
        }
#endif
    }

    func testIndex() throws {
        let file = "\(fixturesDirectory)Bicycle.swift"
        let arguments = ["-sdk", sdkPath(), "-j4", file ]
        let indexJSON = NSMutableString(string: toJSON(toNSDictionary(try Request.index(file: file, arguments: arguments).send())) + "\n")

        func replace(_ pattern: String, withTemplate template: String) throws {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            _ = regex.replaceMatches(in: indexJSON, options: [],
                                     range: NSRange(location: 0, length: indexJSON.length),
                                     withTemplate: template)
        }

        // Replace the parts of the output that are dependent on the environment of the test running machine
        try replace("\"key\\.filepath\"[^\\n]*", withTemplate: "\"key\\.filepath\" : \"\",")
        try replace("\"key\\.hash\"[^\\n]*", withTemplate: "\"key\\.hash\" : \"\",")

        compareJSONString(withFixtureNamed: "BicycleIndex", jsonString: indexJSON.bridge())
    }

    func testYamlRequest() throws {
        let path = fixturesDirectory + "Subscript.swift"
        let yaml = "key.request: source.request.editor.open\nkey.name: \"\(path)\"\nkey.sourcefile: \"\(path)\""
        let output = try Request.yamlRequest(yaml: yaml).send()
        let expectedStructure = try Structure(file: File(path: path)!)
        let actualStructure = Structure(sourceKitResponse: output)
        XCTAssertEqual(expectedStructure, actualStructure)
    }

    func testSyntaxTree() throws {
        let file = File(path: "\(fixturesDirectory)Bicycle.swift")!
        let request = Request.syntaxTree(file: file, byteTree: false)
        let response = try request.send()
        guard let syntaxJSON = response["key.serialized_syntax_tree"] as? String else {
            XCTFail("Could not get serialized syntax tree")
            return
        }

        compareJSONString(withFixtureNamed: "BicycleSyntax", jsonString: syntaxJSON)
    }

    func testCompilerVersion() {
        XCTAssertTrue(SwiftVersion.current >= SwiftVersion.fiveDotOne)
    }
}

extension SourceKitTests {
    static var allTests: [(String, (SourceKitTests) -> () throws -> Void)] {
        return [
            ("testStatementKinds", testStatementKinds),
            ("testSyntaxKinds", testSyntaxKinds),
            ("testSwiftDeclarationKind", testSwiftDeclarationKind),
            ("testSwiftDeclarationAttributeKind", testSwiftDeclarationAttributeKind),
            ("testIndex", testIndex),
            ("testYamlRequest", testYamlRequest),
            ("testSyntaxTree", testSyntaxTree),
            ("testCompilerVersion", testCompilerVersion)
        ]
    }
}
