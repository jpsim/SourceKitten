@testable import SourceKittenFrameworkTests
import XCTest

XCTMain([
    // testCase(ClangTranslationUnitTests.allTests),
    testCase(CodeCompletionTests.allTests),
    testCase(DocInfoTests.allTests),
    testCase(FileTests.allTests),
    testCase(ModuleTests.allTests),
    testCase(OffsetMapTests.allTests),
    testCase(SourceKitTests.allTests),
    testCase(StringTests.allTests),
    testCase(StructureTests.allTests),
    testCase(SwiftDocsTests.allTests),
    testCase(SyntaxTests.allTests),
    testCase(RequestTests.allTests)
])
