@testable import SourceKittenFramework
import XCTest

final class LibraryWrapperGeneratorTests: XCTestCase {
#if compiler(>=5.4) && os(macOS)
    func testLibraryWrappersAreUpToDate() throws {
        let sourceKittenFrameworkModule = Module(xcodeBuildArguments: sourcekittenXcodebuildArguments,
                                                 name: "SourceKittenFramework", inPath: projectRoot)!
        let docsJSON = sourceKittenFrameworkModule.docs.description

        /// If this assert fires and the cause is missing Windows types, then see e.g. https://github.com/jpsim/SourceKitten/pull/828
        /// for direction - the idea is to provide 'shim' types to let sourcekit reason about the types and leave this test unchanged.
        XCTAssert(docsJSON.range(of: "error type") == nil)

        let jsonArray = try JSONSerialization.jsonObject(with: docsJSON.data(using: .utf8)!, options: []) as? NSArray
        XCTAssertNotNil(jsonArray, "JSON should be properly parsed")
        for wrapperConfig in LibraryWrapperGenerator.allCases {
            let wrapperURL = URL(fileURLWithPath: "\(projectRoot)/\(wrapperConfig.filePath)")
            let existingWrapper = try String(contentsOf: wrapperURL)
            let generatedWrapper = try wrapperConfig.generate(compilerArguments: sourceKittenFrameworkModule.compilerArguments)
            XCTAssertEqual(existingWrapper, generatedWrapper)
            let overwrite = false // set this to true to overwrite existing wrappers with the generated ones
            if existingWrapper != generatedWrapper && overwrite {
                try generatedWrapper.data(using: .utf8)?.write(to: wrapperURL)
            }
        }
    }
#endif
}
