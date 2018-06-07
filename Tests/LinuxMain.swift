@testable import SourceKittenFrameworkTests
import SwiftBacktrace
import XCTest

let handler: @convention(c) (Int32) -> Void = { signo in
    fputs(backtrace().joined(separator: "\n") + "\n", stderr)
    fflush(stderr)
    exit(128 + signo)
}
handle(signal: SIGABRT, action: handler)
handle(signal: SIGUSR1, action: handler)

XCTMain([
    // testCase(ClangTranslationUnitTests.allTests),
    testCase(CodeCompletionTests.allTests),
    testCase(DocInfoTests.allTests),
    testCase(FileTests.allTests),
    testCase(ModuleTests.allTests),
    testCase(OffsetMapTests.allTests),
    testCase(SourceKitObjectTests.allTests),
    testCase(SourceKitTests.allTests),
    testCase(StringTests.allTests),
    testCase(StructureTests.allTests),
    testCase(SwiftDocKeyTests.allTests),
    testCase(SwiftDocsTests.allTests),
    testCase(SyntaxTests.allTests)
])
