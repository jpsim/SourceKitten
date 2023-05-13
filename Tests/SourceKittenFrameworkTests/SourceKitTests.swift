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
#elseif os(Windows)
    return [
        "source.decl.attribute.__consuming",
        "source.decl.attribute.__objc_bridged",
        "source.decl.attribute.__raw_doc_comment",
        "source.decl.attribute.__setter_access",
        "source.decl.attribute.__synthesized_protocol",
        "source.decl.attribute._alignment",
        "source.decl.attribute._alwaysEmitIntoClient",
        "source.decl.attribute._assemblyVision",
        "source.decl.attribute._backDeploy",
        "source.decl.attribute._borrowed",
        "source.decl.attribute._cdecl",
        "source.decl.attribute._clangImporterSynthesizedType",
        "source.decl.attribute._compilerInitialized",
        "source.decl.attribute._const",
        "source.decl.attribute._custom",
        "source.decl.attribute._disfavoredOverload",
        "source.decl.attribute._dynamicReplacement",
        "source.decl.attribute._effects",
        "source.decl.attribute._exported",
        "source.decl.attribute._fixed_layout",
        "source.decl.attribute._forbidSerializingReference",
        "source.decl.attribute._hasInitialValue",
        "source.decl.attribute._hasMissingDesignatedInitializers",
        "source.decl.attribute._hasStorage",
        "source.decl.attribute._implementationOnly",
        "source.decl.attribute._implements",
        "source.decl.attribute._implicitSelfCapture",
        "source.decl.attribute._inheritActorContext",
        "source.decl.attribute._inheritsConvenienceInitializers",
        "source.decl.attribute._local",
        "source.decl.attribute._marker",
        "source.decl.attribute._noAllocation",
        "source.decl.attribute._noImplicitCopy",
        "source.decl.attribute._noLocks",
        "source.decl.attribute._nonEphemeral",
        "source.decl.attribute._nonoverride",
        "source.decl.attribute._nonSendable",
        "source.decl.attribute._objc_non_lazy_realization",
        "source.decl.attribute._objcRuntimeName",
        "source.decl.attribute._optimize",
        "source.decl.attribute._originallyDefinedIn",
        "source.decl.attribute._private",
        "source.decl.attribute._projectedValueProperty",
        "source.decl.attribute._restatedObjCConformance",
        "source.decl.attribute._semantics",
        "source.decl.attribute._show_in_interface",
        "source.decl.attribute._silgen_name",
        "source.decl.attribute._specialize",
        "source.decl.attribute._specializeExtension",
        "source.decl.attribute._spi",
        "source.decl.attribute._staticInitializeObjCMetadata",
        "source.decl.attribute._swift_native_objc_runtime_base",
        "source.decl.attribute._transparent",
        "source.decl.attribute._typeEraser",
        "source.decl.attribute._typeSequence",
        "source.decl.attribute._unavailableFromAsync",
        "source.decl.attribute._unsafeInheritExecutor",
        "source.decl.attribute._weakLinked",
        "source.decl.attribute.actor",
        "source.decl.attribute.async",
        "source.decl.attribute.available",
        "source.decl.attribute.convenience",
        "source.decl.attribute.derivative",
        "source.decl.attribute.differentiable",
        "source.decl.attribute.discardableResult",
        "source.decl.attribute.distributed",
        "source.decl.attribute.dynamic",
        "source.decl.attribute.dynamicCallable",
        "source.decl.attribute.dynamicMemberLookup",
        "source.decl.attribute.exclusivity",
        "source.decl.attribute.fileprivate",
        "source.decl.attribute.final",
        "source.decl.attribute.frozen",
        "source.decl.attribute.gkinspectable",
        "source.decl.attribute.globalActor",
        "source.decl.attribute.ibaction",
        "source.decl.attribute.ibdesignable",
        "source.decl.attribute.ibinspectable",
        "source.decl.attribute.iboutlet",
        "source.decl.attribute.ibsegueaction",
        "source.decl.attribute.IBSegueAction",
        "source.decl.attribute.indirect",
        "source.decl.attribute.infix",
        "source.decl.attribute.inlinable",
        "source.decl.attribute.inline",
        "source.decl.attribute.internal",
        "source.decl.attribute.isolated",
        "source.decl.attribute.lazy",
        "source.decl.attribute.LLDBDebuggerFunction",
        "source.decl.attribute.main",
        "source.decl.attribute.mutating",
        "source.decl.attribute.noDerivative",
        "source.decl.attribute.nonisolated",
        "source.decl.attribute.nonmutating",
        "source.decl.attribute.nonobjc",
        "source.decl.attribute.NSApplicationMain",
        "source.decl.attribute.NSCopying",
        "source.decl.attribute.NSManaged",
        "source.decl.attribute.objc.name",
        "source.decl.attribute.objc",
        "source.decl.attribute.objcMembers",
        "source.decl.attribute.open",
        "source.decl.attribute.optional",
        "source.decl.attribute.override",
        "source.decl.attribute.postfix",
        "source.decl.attribute.preconcurrency",
        "source.decl.attribute.prefix",
        "source.decl.attribute.private",
        "source.decl.attribute.propertyWrapper",
        "source.decl.attribute.public",
        "source.decl.attribute.reasync",
        "source.decl.attribute.required",
        "source.decl.attribute.requires_stored_property_inits",
        "source.decl.attribute.resultBuilder",
        "source.decl.attribute.rethrows",
        "source.decl.attribute.Sendable",
        "source.decl.attribute.setter_access.fileprivate",
        "source.decl.attribute.setter_access.internal",
        "source.decl.attribute.setter_access.open",
        "source.decl.attribute.setter_access.private",
        "source.decl.attribute.setter_access.public",
        "source.decl.attribute.testable",
        "source.decl.attribute.transpose",
        "source.decl.attribute.UIApplicationMain",
        "source.decl.attribute.unsafe_no_objc_tagged_pointer",
        "source.decl.attribute.usableFromInline",
        "source.decl.attribute.warn_unqualified_access",
        "source.decl.attribute.weak",
        "source.lang.swift.decl.actor",
        "source.lang.swift.decl.associatedtype",
        "source.lang.swift.decl.class",
        "source.lang.swift.decl.enum",
        "source.lang.swift.decl.enumcase",
        "source.lang.swift.decl.enumelement",
        "source.lang.swift.decl.extension.class",
        "source.lang.swift.decl.extension.enum",
        "source.lang.swift.decl.extension.protocol",
        "source.lang.swift.decl.extension.struct",
        "source.lang.swift.decl.extension",
        "source.lang.swift.decl.function.accessor.address",
        "source.lang.swift.decl.function.accessor.didset",
        "source.lang.swift.decl.function.accessor.getter",
        "source.lang.swift.decl.function.accessor.modify",
        "source.lang.swift.decl.function.accessor.mutableaddress",
        "source.lang.swift.decl.function.accessor.read",
        "source.lang.swift.decl.function.accessor.setter",
        "source.lang.swift.decl.function.accessor.willset",
        "source.lang.swift.decl.function.constructor",
        "source.lang.swift.decl.function.destructor",
        "source.lang.swift.decl.function.free",
        "source.lang.swift.decl.function.method.class",
        "source.lang.swift.decl.function.method.instance",
        "source.lang.swift.decl.function.method.static",
        "source.lang.swift.decl.function.operator.infix",
        "source.lang.swift.decl.function.operator.postfix",
        "source.lang.swift.decl.function.operator.prefix",
        "source.lang.swift.decl.function.subscript",
        "source.lang.swift.decl.generic_type_param",
        "source.lang.swift.decl.module",
        "source.lang.swift.decl.opaquetype",
        "source.lang.swift.decl.precedencegroup",
        "source.lang.swift.decl.protocol",
        "source.lang.swift.decl.struct",
        "source.lang.swift.decl.typealias",
        "source.lang.swift.decl.var.class",
        "source.lang.swift.decl.var.global",
        "source.lang.swift.decl.var.instance",
        "source.lang.swift.decl.var.local",
        "source.lang.swift.decl.var.parameter",
        "source.lang.swift.decl.var.static",
        "source.lang.swift.stmt.brace",
        "source.lang.swift.stmt.case",
        "source.lang.swift.stmt.for",
        "source.lang.swift.stmt.foreach",
        "source.lang.swift.stmt.guard",
        "source.lang.swift.stmt.if",
        "source.lang.swift.stmt.repeatwhile",
        "source.lang.swift.stmt.switch",
        "source.lang.swift.stmt.while",
        "source.lang.swift.syntaxtype.argument",
        "source.lang.swift.syntaxtype.attribute.builtin",
        "source.lang.swift.syntaxtype.attribute.id",
        "source.lang.swift.syntaxtype.buildconfig.id",
        "source.lang.swift.syntaxtype.buildconfig.keyword",
        "source.lang.swift.syntaxtype.comment.mark",
        "source.lang.swift.syntaxtype.comment.url",
        "source.lang.swift.syntaxtype.comment",
        "source.lang.swift.syntaxtype.doccomment.field",
        "source.lang.swift.syntaxtype.doccomment",
        "source.lang.swift.syntaxtype.identifier",
        "source.lang.swift.syntaxtype.keyword",
        "source.lang.swift.syntaxtype.number",
        "source.lang.swift.syntaxtype.objectliteral",
        "source.lang.swift.syntaxtype.parameter",
        "source.lang.swift.syntaxtype.placeholder",
        "source.lang.swift.syntaxtype.pounddirective.keyword",
        "source.lang.swift.syntaxtype.string_interpolation_anchor",
        "source.lang.swift.syntaxtype.string",
        "source.lang.swift.syntaxtype.typeidentifier",
    ]
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

    func testLibraryWrappersAreUpToDate() throws {
#if compiler(>=5.4) && os(macOS)
        let sourceKittenFrameworkModule = Module(xcodeBuildArguments: sourcekittenXcodebuildArguments,
                                                 name: "SourceKittenFramework", inPath: projectRoot)!
        let docsJSON = sourceKittenFrameworkModule.docs.description
        XCTAssert(docsJSON.range(of: "error type") == nil)
        let jsonArray = try JSONSerialization.jsonObject(with: docsJSON.data(using: .utf8)!, options: []) as? NSArray
        XCTAssertNotNil(jsonArray, "JSON should be properly parsed")
        let sourcekitd = "sourcekitdInProc.framework/Versions/A/sourcekitdInProc"
        let modules: [(module: String, macOSPath: String, linuxPath: String?)] = [
            ("Clang_C", "libclang.dylib", nil),
            ("SourceKit", sourcekitd, "libsourcekitdInProc.so")
        ]
        for (module, inProcPath, linuxPath) in modules {
            let wrapperPath = "\(projectRoot)/Source/SourceKittenFramework/library_wrapper_\(module).swift"
            let existingWrapper = try String(contentsOfFile: wrapperPath)
            let generatedWrapper = try libraryWrapperForModule(
                module, macOSPath: inProcPath, linuxPath: linuxPath,
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
#if compiler(<5.9)
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
