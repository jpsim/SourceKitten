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
        let completionItems = CodeCompletionItem.parseResponse(
            response: Request.CodeCompletionRequest(file: file, contents: "0.", offset: 2,
                arguments: ["-c", file, "-sdk", sdkPath()]).send())
        compareJSONStringWithFixturesName("SimpleCodeCompletion",
            jsonString: completionItems)
    }
}

extension CodeCompletionTests {
    static var allTests: [(String, (CodeCompletionTests) -> () throws -> Void)] {
        return [
            // ("testSimpleCodeCompletion", testSimpleCodeCompletion),
        ]
    }
}
