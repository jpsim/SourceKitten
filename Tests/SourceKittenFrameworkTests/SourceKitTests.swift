import Foundation
@testable import SourceKittenFramework
import XCTest

#if !os(Windows)
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
    // `sourcekitdInProc` doesn't exist on at least Xcode 11.7, and
    // `SourceKitService` doesn't contain the strings in Xcode 13.
#if swift(>=5.5)
    let toolchainUsrPath = "lib/sourcekitdInProc.framework/sourcekitdInProc"
#else
    let toolchainUsrPath = "lib/sourcekitd.framework/XPCServices/SourceKitService.xpc/Contents/MacOS/SourceKitService"
#endif
    let sourceKitPath = Exec.run("/usr/bin/xcrun", "-f", "swiftc").string!.bridge()
        .deletingLastPathComponent.bridge()
        .deletingLastPathComponent.bridge()
        .appendingPathComponent(toolchainUsrPath)
#endif
    let strings = Exec.run("/usr/bin/strings", sourceKitPath).string
    return strings!.components(separatedBy: "\n")
}()
#endif

private func sourcekitStrings(startingWith pattern: String) -> Set<String> {
    return Set(sourcekitStrings.filter { $0.hasPrefix(pattern) })
}

let sourcekittenXcodebuildArguments = [
    "-scheme", "sourcekitten",
    "-destination", "platform=macOS"
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
#if compiler(>=5.8)
        let expected = SyntaxKind.allCases
#else
        let expected = Set(SyntaxKind.allCases).subtracting([.operator])
#endif

        let actual = sourcekitStrings(startingWith: "source.lang.swift.syntaxtype.")
        let expectedStrings = Set(expected.map(\.rawValue))
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
#if compiler(<5.8)
        expected.remove(.macro)
#endif
#if compiler(<5.9)
        expected.remove(.functionAccessorInit)
#endif
        let expectedStrings = Set(expected.map(\.rawValue))
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

#if compiler(>=6.0)
        // removed in Swift 6.0
        expected.subtract([.isolated, ._objcImplementation])
#else
        // added in Swift 6.0
        expected.subtract([._extern, ._resultDependsOnSelf, ._preInverseGenerics, .implementation,
                           ._allowFeatureSuppression, ._noRuntime, ._staticExclusiveOnly, .extractConstantsFromMembers,
                           ._unsafeNonescapableResult, ._noExistentials, ._noObjCBridging, ._nonescapable])
#endif
#if compiler(>=5.10)
        // removed in Swift 5.10
        expected.subtract([.accesses, .runtimeMetadata, .initializes])
#else
        // added in Swift 5.10
        expected.subtract([._rawLayout, ._used, ._section])
#endif

#if compiler(>=5.9)
        // removed in Swift 5.9
        expected.subtract([.typeWrapperIgnored, .typeWrapper])
#else
        // added in Swift 5.9
        expected.subtract([.setterAccessPackage, .package, .initializes, ._lexicalLifetimes,
                           .consuming, .attached, .borrowing, .storageRestrictions, .accesses])
#endif

#if compiler(>=5.8)
        // removed in Swift 5.8
        expected.subtract([._typeSequence, ._backDeploy])
#else
        // added in Swift 5.8
        expected.subtract([.backDeployed, ._noEagerMove, .typeWrapperIgnored, ._spiOnly, ._moveOnly,
                           ._noMetadata, ._alwaysEmitConformanceMetadata, .runtimeMetadata,
                           ._objcImplementation, ._eagerMove, .typeWrapper, ._expose, ._documentation])
#endif

#if compiler(>=5.6)
        // removed in Swift 5.6
        expected.subtract([.asyncHandler, .actorIndependent, .spawn, ._unsafeMainActor, ._unsafeSendable])
#else
        // added in Swift 5.6
        expected.subtract([.distributed, ._unavailableFromAsync, .preconcurrency, ._assemblyVision, ._const,
                           ._typeSequence, ._nonSendable, ._noAllocation, ._noImplicitCopy, ._noLocks])
#endif

#if compiler(>=5.5.2)
        // removed in Swift 5.5.2
        expected.subtract([.completionHandlerAsync])
#endif

#if compiler(>=5.5)
#else
        // added in Swift 5.5
        expected.subtract([
            .spawn, ._unsafeMainActor, ._unsafeSendable, .isolated, ._inheritActorContext,
            .nonisolated, ._implicitSelfCapture, .completionHandlerAsync, ._marker,
            .reasync, .Sendable
        ])
#endif

#if compiler(>=5.4)
        // removed in Swift 5.4
        expected.subtract([._functionBuilder])
#else
        // added in Swift 5.4
        expected.subtract([
            ._specializeExtension, .actor, .actorIndependent, .async, .asyncHandler,
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
#if !canImport(Darwin) && compiler(<5.6)
        // added in Swift 5.0 for Darwin, 5.6 for Linux
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
#if !canImport(Darwin) && compiler(<5.6)
        // added in Swift 5.1 for Darwin, 5.6 for Linux
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
#if compiler(<5.8)
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
#endif

    func testCompilerVersion() {
        XCTAssertTrue(SwiftVersion.current >= SwiftVersion.fiveDotOne)
    }
}
