@testable import SourceKittenFramework
import XCTest

final class LibraryWrapperGeneratorTests: XCTestCase {
#if compiler(>=5.4) && os(macOS)
    func testLibraryWrappersAreUpToDate() throws {
        let sourceKittenFrameworkModule = Module(xcodeBuildArguments: sourcekittenXcodebuildArguments,
                                                 name: "SourceKittenFramework", inPath: projectRoot)!
        XCTAssert(try noTypeErrors(in: sourceKittenFrameworkModule.docs.description))
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

    private func noTypeErrors(in json: String) throws -> Bool {
        let errorType = "<<error type>>"
        let errorTypeRegex = try NSRegularExpression(pattern: errorType, options: [])
        XCTAssertLessThanOrEqual(
            errorTypeRegex.matches(in: json, range: NSRange(json.startIndex..<json.endIndex, in: json)).count,
            2,
            "Found more than 2 (expected) errors in JSON"
        )
        let errorTypeData = Array(Data(errorType.utf8))
        let jsonArray = try JSONSerialization.jsonObject(with: json.data(using: .utf8)!) as? NSArray
        XCTAssertNotNil(jsonArray, "JSON not parseble")
        let filteredJsonArray = jsonArray!.filter { item in
            if let dict = item as? NSDictionary {
                // WindowsError.swift cannot be properly interpreted due to missing Windows dependencies.
                return dict["\(projectRoot)/Source/SourceKittenFramework/WindowsError.swift"] == nil
            }
            return true
        }
        return !(try JSONSerialization.data(withJSONObject: filteredJsonArray).contains(errorTypeData))
    }
#endif
}
