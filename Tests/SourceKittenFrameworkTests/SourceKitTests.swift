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
    let sourceKitPath = "\(linuxSourceKitLibPath)/libsourcekitdInProc.so"
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
            .while,
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
        let expected: [SyntaxKind] = [
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

    func testLibraryWrappersAreUpToDate() {
        let sourceKittenFrameworkModule = Module(xcodeBuildArguments: ["-workspace", "SourceKitten.xcworkspace", "-scheme", "SourceKittenFramework"], name: nil, inPath: projectRoot)!
        let modules: [(module: String, path: String, linuxPath: String?, spmModule: String)] = [
            ("CXString", "libclang.dylib", nil, "Clang_C"),
            ("Documentation", "libclang.dylib", nil, "Clang_C"),
            ("Index", "libclang.dylib", nil, "Clang_C"),
            ("sourcekitd", "sourcekitd.framework/Versions/A/sourcekitd", "libsourcekitdInProc.so", "SourceKit")
        ]
        for (module, path, linuxPath, spmModule) in modules {
            let wrapperPath = "\(projectRoot)/Source/SourceKittenFramework/library_wrapper_\(module).swift"
            let existingWrapper = try! String(contentsOfFile: wrapperPath)
            let generatedWrapper = libraryWrapperForModule(module, loadPath: path, linuxPath: linuxPath, spmModule: spmModule, compilerArguments: sourceKittenFrameworkModule.compilerArguments)
            XCTAssertEqual(existingWrapper, generatedWrapper)
            let overwrite = false // set this to true to overwrite existing wrappers with the generated ones
            if existingWrapper != generatedWrapper && overwrite {
                try! generatedWrapper.data(using: .utf8)?.write(to: URL(fileURLWithPath: wrapperPath))
            }
        }
    }

    func testIndex() {
        let file = "\(fixturesDirectory)Bicycle.swift"
        let arguments = ["-sdk", sdkPath(), "-j4", file ]
        let indexJSON = NSMutableString(string: toJSON(toNSDictionary(Request.index(file: file, arguments: arguments).send())) + "\n")

        func replace(_ pattern: String, withTemplate template: String) {
            _ = try! NSRegularExpression(pattern: pattern, options: []).replaceMatches(in: indexJSON, options: [], range: NSRange(location: 0, length: indexJSON.length), withTemplate: template)
        }

        // Replace the parts of the output that are dependent on the environment of the test running machine
        replace("\"key\\.filepath\"[^\\n]*", withTemplate: "\"key\\.filepath\" : \"\",")
        replace("\"key\\.hash\"[^\\n]*", withTemplate: "\"key\\.hash\" : \"\",")

        compareJSONString(withFixtureNamed: "BicycleIndex", jsonString: indexJSON.bridge())
    }
}

extension SourceKitTests {
    static var allTests: [(String, (SourceKitTests) -> () throws -> Void)] {
        return [
            ("testStatementKinds", testStatementKinds),
            ("testSyntaxKinds", testSyntaxKinds),
            ("testSwiftDeclarationKind", testSwiftDeclarationKind),
            ("testIndex", testIndex),
        ]
    }
}
