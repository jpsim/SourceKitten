//
//  SourceKitTests.swift
//  SourceKitten
//
//  Created by JP Simard on 7/15/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import XCTest
@testable import SourceKittenFramework

private func run(executable: String, arguments: [String]) -> String? {
    let task = NSTask()
    task.launchPath = executable
    task.arguments = arguments

    let pipe = NSPipe()
    task.standardOutput = pipe

    task.launch()

    let file = pipe.fileHandleForReading
    defer { file.closeFile() }
    return String(data: file.readDataToEndOfFile(), encoding: NSUTF8StringEncoding)
}

private func sourcekitStringsStartingWith(pattern: String) -> Set<String> {
    // Should ideally use NSURL(fileURLWithPath:isDirectory:relativeToURL:)
    // but that's 10.11+.
    guard let sourceKitServicePath = toolchainPath().flatMap({
        NSURL(fileURLWithPath: $0, isDirectory: true).URLByAppendingPathComponent("usr/lib/sourcekitd.framework/XPCServices/SourceKitService.xpc/Contents/MacOS/SourceKitService", isDirectory: false).path
    }) else { return [] }
    let strings = run("/usr/bin/strings", arguments: [sourceKitServicePath])
    return Set(strings!.componentsSeparatedByString("\n").filter({ $0.hasPrefix(pattern) }))
}

class SourceKitTests: XCTestCase {

    func testSyntaxKinds() {
        let expected: [SyntaxKind] = [
            .Argument,
            .AttributeBuiltin,
            .AttributeID,
            .BuildconfigID,
            .BuildconfigKeyword,
            .Comment,
            .CommentMark,
            .CommentURL,
            .DocComment,
            .DocCommentField,
            .Identifier,
            .Keyword,
            .Number,
            .ObjectLiteral,
            .Parameter,
            .Placeholder,
            .String,
            .StringInterpolationAnchor,
            .Typeidentifier
        ]
        let actual = sourcekitStringsStartingWith("source.lang.swift.syntaxtype.")
        let expectedStrings = Set(expected.map { $0.rawValue })
        XCTAssertEqual(
            actual,
            expectedStrings
        )
        if actual != expectedStrings {
            print("the following strings were added: \(actual.subtract(expectedStrings))")
            print("the following strings were removed: \(expectedStrings.subtract(actual))")
        }
    }

    func testSwiftDeclarationKind() {
        let expected: [SwiftDeclarationKind] = [
            .Class,
            .Enum,
            .Enumcase,
            .Enumelement,
            .Extension,
            .ExtensionClass,
            .ExtensionEnum,
            .ExtensionProtocol,
            .ExtensionStruct,
            .FunctionAccessorAddress,
            .FunctionAccessorDidset,
            .FunctionAccessorGetter,
            .FunctionAccessorMutableaddress,
            .FunctionAccessorSetter,
            .FunctionAccessorWillset,
            .FunctionConstructor,
            .FunctionDestructor,
            .FunctionFree,
            .FunctionMethodClass,
            .FunctionMethodInstance,
            .FunctionMethodStatic,
            .FunctionOperator,
            .FunctionSubscript,
            .GenericTypeParam,
            .Module,
            .Protocol,
            .Struct,
            .Typealias,
            .VarClass,
            .VarGlobal,
            .VarInstance,
            .VarLocal,
            .VarParameter,
            .VarStatic
        ]
        let actual = sourcekitStringsStartingWith("source.lang.swift.decl.")
        let expectedStrings = Set(expected.map { $0.rawValue })
        XCTAssertEqual(
            actual,
            expectedStrings
        )
        if actual != expectedStrings {
            print("the following strings were added: \(actual.subtract(expectedStrings))")
            print("the following strings were removed: \(expectedStrings.subtract(actual))")
        }
    }
}
