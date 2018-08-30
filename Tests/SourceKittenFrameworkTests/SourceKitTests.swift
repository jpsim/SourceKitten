//
//  SourceKitTests.swift
//  SourceKitten
//
//  Created by JP Simard on 7/15/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import Foundation
@testable import SourceKittenFramework
import XCTest

private func run(executable: String, arguments: [String]) -> String? {
    let task = Process()
    task.launchPath = executable
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe

    task.launch()

    let file = pipe.fileHandleForReading
    let output = String(data: file.readDataToEndOfFile(), encoding: .utf8)
    file.closeFile()
    return output
}

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
    let sourceKitPath = run(executable: "/usr/bin/xcrun", arguments: ["-f", "swiftc"])!.bridge()
        .deletingLastPathComponent.bridge()
        .deletingLastPathComponent.bridge()
        .appendingPathComponent("lib/sourcekitd.framework/XPCServices/SourceKitService.xpc/Contents/MacOS/SourceKitService")
    #endif
    let strings = run(executable: "/usr/bin/strings", arguments: [sourceKitPath])
    return strings!.components(separatedBy: "\n")
}()

private func sourcekitStrings(startingWith pattern: String) -> Set<String> {
    return Set(sourcekitStrings.filter { string in
        return string.range(of: pattern)?.lowerBound == string.startIndex
    })
}

let sourcekittenXcodebuildArguments = [
    "-workspace", "SourceKitten.xcworkspace",
    "-scheme", "SourceKittenFramework",
    "-derivedDataPath",
    URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent("testLibraryWrappersAreUpToDate").path
]

// swiftlint:disable:next type_body_length
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
#if swift(>=4.1)
        var expected: [SyntaxKind] = [
            .argument,
            .attributeBuiltin,
            .attributeID,
            .buildconfigID,
            .buildconfigKeyword,
            .comment,
            .commentMark,
            .commentURL,
            .docComment,
            .docCommentField,
            .identifier,
            .keyword,
            .number,
            .objectLiteral,
            .parameter,
            .placeholder,
            .string,
            .stringInterpolationAnchor,
            .typeidentifier
        ]

#if swift(>=4.1.50)
        expected.append(.poundDirectiveKeyword)
#else
        // silence `let` warning
        expected.append(contentsOf: [])
#endif

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
#endif
    }

    // swiftlint:disable:next function_body_length
    func testSwiftDeclarationKind() {
        let expected: [SwiftDeclarationKind] = [
            .associatedtype,
            .class,
            .enum,
            .enumcase,
            .enumelement,
            .extension,
            .extensionClass,
            .extensionEnum,
            .extensionProtocol,
            .extensionStruct,
            .functionAccessorAddress,
            .functionAccessorDidset,
            .functionAccessorGetter,
            .functionAccessorMutableaddress,
            .functionAccessorSetter,
            .functionAccessorWillset,
            .functionConstructor,
            .functionDestructor,
            .functionFree,
            .functionMethodClass,
            .functionMethodInstance,
            .functionMethodStatic,
            .functionOperatorInfix,
            .functionOperatorPostfix,
            .functionOperatorPrefix,
            .functionSubscript,
            .genericTypeParam,
            .module,
            .precedenceGroup,
            .protocol,
            .struct,
            .typealias,
            .varClass,
            .varGlobal,
            .varInstance,
            .varLocal,
            .varParameter,
            .varStatic
        ]
        let actual = sourcekitStrings(startingWith: "source.lang.swift.decl.")
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

    // swiftlint:disable:next function_body_length
    func testSwiftDeclarationAttributeKind() {
#if swift(>=4.1)
        var expected: [SwiftDeclarationAttributeKind] = [
            .ibaction,
            .iboutlet,
            .ibdesignable,
            .ibinspectable,
            .gkinspectable,
            .objc,
            .objcName,
            .silgenName,
            .available,
            .final,
            .required,
            .optional,
            .noreturn,
            .epxorted,
            .nsCopying,
            .nsManaged,
            .lazy,
            .lldbDebuggerFunction,
            .uiApplicationMain,
            .unsafeNoObjcTaggedPointer,
            .inline,
            .semantics,
            .dynamic,
            .infix,
            .prefix,
            .postfix,
            .transparent,
            .requiresStoredProperyInits,
            .nonobjc,
            .fixedLayout,
            .inlineable,
            .specialize,
            .objcMembers,
            .mutating,
            .nonmutating,
            .convenience,
            .override,
            .silSorted,
            .weak,
            .effects,
            .objcBriged,
            .nsApplicationMain,
            .objcNonLazyRealization,
            .synthesizedProtocol,
            .testable,
            .alignment,
            .rethrows,
            .swiftNativeObjcRuntimeBase,
            .indirect,
            .warnUnqualifiedAccess,
            .cdecl,
            .versioned,
            .discardableResult,
            .implements,
            .objcRuntimeName,
            .staticInitializeObjCMetadata,
            .restatedObjCConformance,
            .private,
            .fileprivate,
            .internal,
            .public,
            .open,
            .setterPrivate,
            .setterFilePrivate,
            .setterInternal,
            .setterPublic,
            .setterOpen,
            .optimize,
            .consuming,
            .implicitlyUnwrappedOptional
        ]

#if swift(>=4.1.50)
        let removed: [SwiftDeclarationAttributeKind] = [
            .objcNonLazyRealization,
            .inlineable,
            .versioned
        ]

        expected.removeAll(where: removed.contains)

        expected.append(contentsOf: [
            .underscoredObjcNonLazyRealization,
            .clangImporterSynthesizedType,
            .forbidSerializingReference,
            .usableFromInline,
            .weakLinked,
            .inlinable,
            .dynamicMemberLookup,
            .frozen
        ])
#else
        // silence `let` warning
        expected.append(contentsOf: [])
#endif

        let actual = sourcekitStrings(startingWith: "source.decl.attribute.")
        let expectedStrings = Set(expected.map { $0.rawValue })
        XCTAssertEqual(
            actual,
            expectedStrings
        )
        if actual != expectedStrings {
            print("the following strings were added: \(actual.subtracting(expectedStrings))")
            print("the following strings were removed: \(expectedStrings.subtracting(actual))")
        }
#endif
    }

    func testLibraryWrappersAreUpToDate() throws {
        let sourceKittenFrameworkModule = Module(xcodeBuildArguments: sourcekittenXcodebuildArguments, name: nil, inPath: projectRoot)!
        let docsJSON = sourceKittenFrameworkModule.docs.description
        XCTAssert(docsJSON.range(of: "error type") == nil)
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: docsJSON.data(using: .utf8)!, options: []) as? NSArray
            XCTAssertNotNil(jsonArray, "JSON should be propery parsed")
        } catch {
            XCTFail("JSON should be propery parsed")
        }
        let modules: [(module: String, path: String, linuxPath: String?, spmModule: String)] = [
            ("CXString", "libclang.dylib", nil, "Clang_C"),
            ("Documentation", "libclang.dylib", nil, "Clang_C"),
            ("Index", "libclang.dylib", nil, "Clang_C"),
            ("sourcekitd", "sourcekitd.framework/Versions/A/sourcekitd", "libsourcekitdInProc.so", "SourceKit")
        ]
        for (module, path, linuxPath, spmModule) in modules {
            let wrapperPath = "\(projectRoot)/Source/SourceKittenFramework/library_wrapper_\(module).swift"
            let existingWrapper = try String(contentsOfFile: wrapperPath)
            let generatedWrapper = try libraryWrapperForModule(module, loadPath: path, linuxPath: linuxPath, spmModule: spmModule,
                                                           compilerArguments: sourceKittenFrameworkModule.compilerArguments)
            XCTAssertEqual(existingWrapper, generatedWrapper)
            let overwrite = false // set this to true to overwrite existing wrappers with the generated ones
            if existingWrapper != generatedWrapper && overwrite {
                try generatedWrapper.data(using: .utf8)?.write(to: URL(fileURLWithPath: wrapperPath))
            }
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
}

extension SourceKitTests {
    static var allTests: [(String, (SourceKitTests) -> () throws -> Void)] {
        return [
            ("testStatementKinds", testStatementKinds),
            ("testSyntaxKinds", testSyntaxKinds),
            ("testSwiftDeclarationKind", testSwiftDeclarationKind),
            ("testSwiftDeclarationAttributeKind", testSwiftDeclarationAttributeKind),
            ("testIndex", testIndex),
            ("testYamlRequest", testYamlRequest)
        ]
    }
}
