//
//  StructureTests.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SourceKittenFramework
import XCTest

class StructureTests: XCTestCase {

    func testPrintEmptyStructure() throws {
        let expected: NSDictionary = [
            "key.offset": 0,
            "key.length": 0,
            "key.diagnostic_stage": "source.diagnostic.stage.swift.parse",
            "key.substructure": []
        ]
        let structure = try Structure(file: File(contents: ""))
        XCTAssertEqual(toNSDictionary(structure.dictionary), expected, "should generate expected structure")
    }

    func testGenerateSameStructureFileAndContents() throws {
        let fileContents = try String(contentsOfFile: #file, encoding: .utf8)
        try XCTAssertEqual(Structure(file: File(path: #file)!),
            Structure(file: File(contents: fileContents)),
            "should generate the same structure for a file as raw text")
    }

    func testEnum() throws {
        let structure = try Structure(file: File(contents: "enum MyEnum { case First }"))
        let expectedStructure: NSDictionary = [
            "key.substructure": [
                [
                    "key.kind": "source.lang.swift.decl.enum",
                    "key.accessibility": "source.lang.swift.accessibility.internal",
                    "key.offset": 0,
                    "key.nameoffset": 5,
                    "key.namelength": 6,
                    "key.bodyoffset": 13,
                    "key.bodylength": 12,
                    "key.length": 26,
                    "key.substructure": [
                        [
                            "key.kind": "source.lang.swift.decl.enumcase",
                            "key.offset": 14,
                            "key.length": 10,
                            "key.nameoffset": 0,
                            "key.namelength": 0,
                            "key.substructure": [
                                [
                                    "key.kind": "source.lang.swift.decl.enumelement",
                                    "key.accessibility": "source.lang.swift.accessibility.internal",
                                    "key.name": "First",
                                    "key.offset": 19,
                                    "key.length": 5,
                                    "key.nameoffset": 19,
                                    "key.namelength": 5
                                ]
                            ]
                        ]
                    ],
                    "key.name": "MyEnum"
                ]
            ],
            "key.offset": 0,
            "key.diagnostic_stage": "source.diagnostic.stage.swift.parse",
            "key.length": 26
        ]
        XCTAssertEqual(toNSDictionary(structure.dictionary), expectedStructure, "should generate expected structure")
    }

    func testInheritedType() throws {
        let structure = try Structure(file: File(contents: "class Foo: Bar {}"))
        let expected: NSDictionary = [
            "key.substructure": [
                [
                    "key.kind": "source.lang.swift.decl.class",
                    "key.accessibility": "source.lang.swift.accessibility.internal",
                    "key.offset": 0,
                    "key.nameoffset": 6,
                    "key.namelength": 3,
                    "key.bodyoffset": 16,
                    "key.bodylength": 0,
                    "key.length": 17,
                    "key.name": "Foo",
                    "key.elements": [
                        [
                            "key.kind": "source.lang.swift.structure.elem.typeref",
                            "key.offset": 11,
                            "key.length": 3
                        ]
                    ],
                    "key.runtime_name": "_TtC4main3Foo",
                    "key.inheritedtypes": [
                        ["key.name": "Bar"]
                    ]
                ]
            ],
            "key.offset": 0,
            "key.diagnostic_stage": "source.diagnostic.stage.swift.parse",
            "key.length": 17
        ]
        XCTAssertEqual(toNSDictionary(structure.dictionary), expected, "should generate expected structure")
    }

    func testStructurePrintValidJSON() throws {
        let structure = try Structure(file: File(contents: "struct A { func b() {} }"))
        let expectedStructure: NSDictionary = [
            "key.substructure": [
                [
                    "key.kind": "source.lang.swift.decl.struct",
                    "key.accessibility": "source.lang.swift.accessibility.internal",
                    "key.offset": 0,
                    "key.nameoffset": 7,
                    "key.namelength": 1,
                    "key.bodyoffset": 10,
                    "key.bodylength": 13,
                    "key.length": 24,
                    "key.substructure": [
                        [
                            "key.kind": "source.lang.swift.decl.function.method.instance",
                            "key.accessibility": "source.lang.swift.accessibility.internal",
                            "key.offset": 11,
                            "key.nameoffset": 16,
                            "key.namelength": 3,
                            "key.bodyoffset": 21,
                            "key.bodylength": 0,
                            "key.length": 11,
                            "key.name": "b()"
                        ]
                    ],
                    "key.name": "A"
                ]
            ],
            "key.offset": 0,
            "key.diagnostic_stage": "source.diagnostic.stage.swift.parse",
            "key.length": 24
        ]
        XCTAssertEqual(toNSDictionary(structure.dictionary), expectedStructure, "should generate expected structure")

        let jsonData = structure.description.data(using: .utf8)!
        let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [AnyHashable: Any]
        XCTAssertEqual(jsonDictionary.bridge(), expectedStructure, "JSON should match expected structure")
    }
}

extension StructureTests {
    static var allTests: [(String, (StructureTests) -> () throws -> Void)] {
        return [
            ("testPrintEmptyStructure", testPrintEmptyStructure),
            ("testGenerateSameStructureFileAndContents", testGenerateSameStructureFileAndContents),
            ("testEnum", testEnum),
            ("testInheritedType", testInheritedType),
            ("testStructurePrintValidJSON", testStructurePrintValidJSON)
        ]
    }
}
