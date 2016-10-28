import XCTest

@testable import SourceKittenFrameworkTests

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
])
