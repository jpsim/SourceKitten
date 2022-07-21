import Foundation
import SourceKittenFramework
import XCTest

class CodeCompletionTests: XCTestCase {

    func testSimpleCodeCompletion() throws {
        let file = "\(NSUUID().uuidString).swift"
        let completionItems = CodeCompletionItem.parse(response:
            try Request.codeCompletionRequest(file: file, contents: "0.", offset: 2,
                                               arguments: ["-c", file, "-sdk", sdkPath()]).send())
        compareJSONString(withFixtureNamed: "SimpleCodeCompletion",
                          jsonString: completionItems)
    }
}
