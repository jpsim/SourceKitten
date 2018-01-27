//
//  CodeCompletionTests.swift
//  SourceKitten
//
//  Created by JP Simard on 9/3/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

class CodeCompletionTests: XCTestCase {

    func testSimpleCodeCompletion() {
        let file = "\(NSUUID().uuidString).swift"
        #if os(Linux)
        let arguments = ["-c", file]
        #else
        let arguments = ["-c", file, "-sdk", sdkPath()]
        #endif
        let completionItems = CodeCompletionItem.parse(response:
            try! Request.codeCompletionRequest(file: file, contents: "0.", offset: 2,
                                               arguments: arguments).send())
        compareJSONString(withFixtureNamed: "SimpleCodeCompletion",
                          jsonString: completionItems)
    }
}

extension CodeCompletionTests {
    static var allTests: [(String, (CodeCompletionTests) -> () throws -> Void)] {
        return [
            ("testSimpleCodeCompletion", testSimpleCodeCompletion)
        ]
    }
}
