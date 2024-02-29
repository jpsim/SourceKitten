import Foundation
import SourceKittenFramework
import XCTest

class SourceKitObjectTests: XCTestCase {

    func testExample() {
        let path =
            URL(fileURLWithPath: #file)
                .withUnsafeFileSystemRepresentation { String(cString: $0!) }
        let object: SourceKitObject = [
            "key.request": UID("source.request.editor.open"),
            "key.name": path,
            "key.sourcefile": path
        ]
        let expected = """
            {
              key.request: source.request.editor.open,
              key.name: \"\((#file).replacingOccurrences(of: "\\", with: "\\\\"))\",
              key.sourcefile: \"\((#file).replacingOccurrences(of: "\\", with: "\\\\"))\"
            }
            """
        XCTAssertEqual(object.description, expected)
    }
}
