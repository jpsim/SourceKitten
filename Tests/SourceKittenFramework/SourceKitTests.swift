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

private func run(_ executable: String, arguments: [String]) -> String? {
    let task = Task()
    task.launchPath = executable
    task.arguments = arguments

    let pipe = Pipe()
    task.standardOutput = pipe

    task.launch()

    let file = pipe.fileHandleForReading
    let output = NSString(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue)
    file.closeFile()
    return output as String?
}

private func sourcekitStringsStartingWith(_ pattern: String) -> Set<String> {
    let sourceKitServicePath = (((run("/usr/bin/xcrun", arguments: ["-f", "swiftc"])! as NSString)
        .deletingLastPathComponent as NSString)
        .deletingLastPathComponent as NSString)
        .appendingPathComponent("lib/sourcekitd.framework/XPCServices/SourceKitService.xpc/Contents/MacOS/SourceKitService")
    let strings = run("/usr/bin/strings", arguments: [sourceKitServicePath])
    return Set(strings!.components(separatedBy: "\n").filter { string in
        return string.range(of: pattern)?.lowerBound == string.startIndex
    })
}

class SourceKitTests: XCTestCase {

    func testStatementKinds() {
        let expected: [StatementKind] = [
            .Brace,
            .Case,
            .For,
            .ForEach,
            .Guard,
            .If,
            .RepeatWhile,
            .Switch,
            .While,
        ]

        let actual = sourcekitStringsStartingWith("source.lang.swift.stmt.")
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
            print("the following strings were added: \(actual.subtracting(expectedStrings))")
            print("the following strings were removed: \(expectedStrings.subtracting(actual))")
        }
    }

    func testSwiftDeclarationKind() {
        let expected: [SwiftDeclarationKind] = [
            .Associatedtype,
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
            .FunctionOperatorInfix,
            .FunctionOperatorPostfix,
            .FunctionOperatorPrefix,
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
            print("the following strings were added: \(actual.subtracting(expectedStrings))")
            print("the following strings were removed: \(expectedStrings.subtracting(actual))")
        }
    }

    func testIndex() {
        let file = "\(fixturesDirectory)Bicycle.swift"
        let arguments = ["-sdk", sdkPath(), "-j4", file ]
        let indexJSON = NSMutableString(string: toJSON(toAnyObject(Request.Index(file: file, arguments: arguments).send())) + "\n")

        func replace(_ pattern: String, withTemplate template: String) {
            try! RegularExpression(pattern: pattern, options: []).replaceMatches(in: indexJSON, options: [], range: NSRange(location: 0, length: indexJSON.length), withTemplate: template)
        }

        // Replace the parts of the output that are dependent on the environment of the test running machine
        replace("\"key\\.filepath\"[^\\n]*", withTemplate: "\"key\\.filepath\" : \"\",")
        replace("\"key\\.hash\"[^\\n]*", withTemplate: "\"key\\.hash\" : \"\",")

        compareJSONStringWithFixturesName("BicycleIndex", jsonString: indexJSON as String)
    }
}

extension String: CustomStringConvertible {
    public var description: String {
        return self
    }
}
