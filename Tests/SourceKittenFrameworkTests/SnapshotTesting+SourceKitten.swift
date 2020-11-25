import Foundation
import SnapshotTesting
@testable import SourceKittenFramework

enum SnapshotTesting {
#if os(Linux)
    static let swiftVersionAndOSName = "\(SwiftVersion.current.rawValue)-Linux"
#else
    static let swiftVersionAndOSName = "\(SwiftVersion.current.rawValue)"
#endif
}

func assertSourceKittenSnapshot<Value, Format>(
  matching value: @autoclosure () throws -> Value,
  as snapshotting: Snapshotting<Value, Format>,
  named name: String? = SnapshotTesting.swiftVersionAndOSName,
  record recording: Bool = false,
  timeout: TimeInterval = 5,
  file: StaticString = #file,
  testName: String = #function,
  line: UInt = #line
) {
    isRecording = ProcessInfo.processInfo.environment["OVERWRITE_FIXTURES"] != nil
    assertSnapshot(
        matching: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        timeout: timeout,
        file: file,
        testName: testName,
        line: line
    )
}

extension Snapshotting where Value == String, Format == String {
    static let fixturesJSON: Snapshotting<Value, Format> =
        SimplySnapshotting<String>
            .json(removing: fixturesDirectory)
}

extension Snapshotting where Value == [CodeCompletionItem], Format == String {
    static let codeCompletionsJSON: Snapshotting<Value, Format> =
        SimplySnapshotting<String>
            .fixturesJSON
            .pullback { (value: Value) in value.description }
}

extension Snapshotting where Value == SwiftDocs, Format == String {
    static let docsJSON: Snapshotting<Value, Format> =
        SimplySnapshotting<String>
            .fixturesJSON
            .pullback { (value: Value) in value.description }
}

#if !os(Linux)
extension Snapshotting where Value == ClangTranslationUnit, Format == String {
    static let clangJSON: Snapshotting<Value, Format> =
        SimplySnapshotting<String>
            .fixturesJSON
            .pullback { (value: Value) in value.description }
}
#endif

extension Snapshotting where Value == Module, Format == String {
    static let moduleJSON: Snapshotting<Value, Format> =
        SimplySnapshotting<String>
            .fixturesJSON
            .pullback { (value: Value) in value.docs.description }

    static func moduleJSON(removing stringToRemove: String) -> Snapshotting<Value, Format> {
        SimplySnapshotting<String>
            .json(removing: stringToRemove)
            .pullback { (value: Value) in value.docs.description }
    }
}

extension Snapshotting where Value == [String: SourceKitRepresentable], Format == String {
    static let sourcekitJSON: Snapshotting<Value, Format> =
        SimplySnapshotting<String>
            .fixturesJSON
            .pullback { (value: Value) in toJSON(value) }
}

private extension Snapshotting where Value == String, Format == String {
    static func json(removing stringToRemove: String) -> Snapshotting<Value, String> {
        var snapshotting = SimplySnapshotting<String>.lines.pullback { (value: Value) in
            var jsonString = value
                .replacingOccurrences(
                    of: stringToRemove.replacingOccurrences(
                        of: "/",
                        with: "\\/"
                    ),
                    with: ""
                )
            // Strip out any other absolute paths after that, since it's also dependent on the test machine's setup
            let absolutePathRegex = try! NSRegularExpression(pattern: "\"key\\.filepath\" : \"\\\\/[^\\\n]+", options: [])
            jsonString = absolutePathRegex
                .stringByReplacingMatches(
                    in: jsonString,
                    options: [],
                    range: NSRange(location: 0, length: jsonString.bridge().length),
                    withTemplate: "\"key\\.filepath\" : \"<absolute-path-redacted>\","
                )

            return jsonString
        }
        snapshotting.pathExtension = "json"
        return snapshotting
    }
}
