import Foundation
import SourceKittenFramework
import XCTest

class SwiftDocKeyTests: XCTestCase {

    func testElements() throws {
        let structure = try Structure(file: File(contents: "class Foo: Bar {}"))
        let substructures = structure.dictionary[SwiftDocKey.substructure.rawValue] as! [[String: SourceKitRepresentable]]
        let elements = (substructures[0][SwiftDocKey.elements.rawValue] as! [[String: SourceKitRepresentable]]).map(toNSDictionary)
        let expected: [NSDictionary] = [
            [
                "key.kind": "source.lang.swift.structure.elem.typeref",
                "key.offset": 11,
                "key.length": 3
            ]
        ]
        XCTAssertEqual(elements, expected)
    }

}
