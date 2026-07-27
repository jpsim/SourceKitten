import Foundation
import SourceKittenFramework
import XCTest

class StructureTests: XCTestCase {

    func testPrintEmptyStructure() throws {
        let expected: NSDictionary = [
            "key.offset": 0,
            "key.length": 0,
            "key.diagnostic_stage": "source.diagnostic.stage.swift.parse",
            "key.substructure": [] as NSArray
        ]
        let structure = try Structure(file: File(contents: ""))
        XCTAssertEqual(toNSDictionary(structure.dictionary), expected, "should generate expected structure")
    }

    func testGenerateSameStructureFileAndContents() throws {
        let filepath: String
        if let buildWorkspaceRoot = bazelProjectRoot {
            filepath = buildWorkspaceRoot + "/Tests/SourceKittenFrameworkTests/StructureTests.swift"
        } else {
            filepath = #file
        }
        let fileContents = try String(contentsOfFile: filepath, encoding: .utf8)
        try XCTAssertEqual(Structure(file: File(path: filepath)!),
            Structure(file: File(contents: fileContents)),
            "should generate the same structure for a file as raw text")
    }

    // swiftlint:disable:next function_body_length
    func testEnum() throws {
        let structure = try Structure(file: File(contents: "enum MyEnum { case First }"))
#if compiler(>=5.6)
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
                            "key.substructure": [
                                [
                                    "key.kind": "source.lang.swift.decl.enumelement",
                                    "key.accessibility": "source.lang.swift.accessibility.internal",
                                    "key.name": "First",
                                    "key.offset": 19,
                                    "key.length": 5,
                                    "key.nameoffset": 19,
                                    "key.namelength": 5
                                ] as [String: Any]
                            ]
                        ] as [String: Any]
                    ],
                    "key.name": "MyEnum"
                ] as [String: Any]
            ],
            "key.offset": 0,
            "key.diagnostic_stage": "source.diagnostic.stage.swift.parse",
            "key.length": 26
        ]
#else
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
#endif
        XCTAssertEqual(toNSDictionary(structure.dictionary), expectedStructure, "should generate expected structure")
    }

    // swiftlint:disable:next function_body_length
    func testInheritedType() throws {
        let structure = try Structure(file: File(contents: "class Foo: Bar {}"))
#if compiler(>=5.3)
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
                        ] as [String: Any]
                    ],
                    "key.inheritedtypes": [
                        ["key.name": "Bar"]
                    ]
                ] as [String: Any]
            ],
            "key.offset": 0,
            "key.diagnostic_stage": "source.diagnostic.stage.swift.parse",
            "key.length": 17
        ]
#else
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
#endif
        XCTAssertEqual(toNSDictionary(structure.dictionary), expected, "should generate expected structure")
    }

    func testStructureOmitsImportsByDefault() throws {
        let structure = try Structure(file: File(contents: "import Foundation\nclass Foo {}"))
        XCTAssertNil(structure.dictionary["key.imports"], "key.imports should be absent when extractImports is not set")
    }

    func testStructureIncludesImports() throws {
        let structure = try Structure(file: File(contents: "import Foundation\nclass Foo {}"), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Foundation")
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        XCTAssertEqual(first?["key.length"] as? Int64, 17)
    }

    func testStructureMultipleImports() throws {
        let source = "import Foundation\nimport UIKit\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 2)
        let first = imports?[0] as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Foundation")
        let second = imports?[1] as? [String: SourceKitRepresentable]
        XCTAssertEqual(second?["key.name"] as? String, "UIKit")
    }

    func testStructureNoImports() throws {
        let structure = try Structure(file: File(contents: "class Foo {}"), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports, "key.imports should be present when extractImports is true")
        XCTAssertEqual(imports?.count, 0, "key.imports should be empty when there are no imports")
    }

    func testStructureTestableImport() throws {
        let source = "@testable import XCTest\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "XCTest")
        // Offset should be 0 (start of @testable), not the import keyword
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        // Length should cover "@testable import XCTest" = 23
        XCTAssertEqual(first?["key.length"] as? Int64, 23)
        let attrs = first?["key.attributes"] as? [SourceKitRepresentable]
        XCTAssertEqual(attrs?.count, 1)
        let firstAttr = attrs?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(firstAttr?["key.attribute"] as? String, "source.decl.attribute.testable")
        // "@testable" starts at 0, length 9
        XCTAssertEqual(firstAttr?["key.offset"] as? Int64, 0)
        XCTAssertEqual(firstAttr?["key.length"] as? Int64, 9)
    }

    func testStructureExportedTestableImport() throws {
        let source = "@_exported @testable import XCTest\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "XCTest")
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        // "@_exported @testable import XCTest" = 34
        XCTAssertEqual(first?["key.length"] as? Int64, 34)
        let attrs = first?["key.attributes"] as? [SourceKitRepresentable]
        XCTAssertEqual(attrs?.count, 2)
        let firstAttr = attrs?[0] as? [String: SourceKitRepresentable]
        let secondAttr = attrs?[1] as? [String: SourceKitRepresentable]
        XCTAssertEqual(firstAttr?["key.attribute"] as? String, "source.decl.attribute._exported")
        // "@_exported" starts at 0, length 10
        XCTAssertEqual(firstAttr?["key.offset"] as? Int64, 0)
        XCTAssertEqual(firstAttr?["key.length"] as? Int64, 10)
        XCTAssertEqual(secondAttr?["key.attribute"] as? String, "source.decl.attribute.testable")
        // "@testable" starts at 11, length 9
        XCTAssertEqual(secondAttr?["key.offset"] as? Int64, 11)
        XCTAssertEqual(secondAttr?["key.length"] as? Int64, 9)
    }

    func testStructurePlainImportHasNoAttributes() throws {
        let structure = try Structure(file: File(contents: "import Foundation\nclass Foo {}"), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertNil(first?["key.attributes"], "plain imports should not have key.attributes")
    }

    func testStructureSubmoduleImport() throws {
        let source = "import Foundation.NSObject\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Foundation.NSObject")
        XCTAssertEqual(first?["key.module_name"] as? String, "Foundation")
        XCTAssertNil(first?["key.import_kind"], "bare submodule import should not have import_kind")
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        // "import Foundation.NSObject" = 26
        XCTAssertEqual(first?["key.length"] as? Int64, 26)
    }

    func testStructureSubmoduleImportNSDate() throws {
        let source = "import Foundation.NSDate\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Foundation.NSDate")
        XCTAssertEqual(first?["key.module_name"] as? String, "Foundation")
        XCTAssertNil(first?["key.import_kind"])
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        // "import Foundation.NSDate" = 24
        XCTAssertEqual(first?["key.length"] as? Int64, 24)
    }

    func testStructureKindQualifiedImportClass() throws {
        let source = "import class Foundation.NSObject\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Foundation.NSObject")
        XCTAssertEqual(first?["key.module_name"] as? String, "Foundation")
        XCTAssertEqual(first?["key.import_kind"] as? String, "class")
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        // "import class Foundation.NSObject" = 32
        XCTAssertEqual(first?["key.length"] as? Int64, 32)
    }

    func testStructureKindQualifiedImportFunc() throws {
        let source = "import func Darwin.exit\nfunc foo() {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Darwin.exit")
        XCTAssertEqual(first?["key.module_name"] as? String, "Darwin")
        XCTAssertEqual(first?["key.import_kind"] as? String, "func")
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        // "import func Darwin.exit" = 23
        XCTAssertEqual(first?["key.length"] as? Int64, 23)
    }

    func testStructureKindQualifiedImportStruct() throws {
        let source = "import struct Foundation.URL\nstruct Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Foundation.URL")
        XCTAssertEqual(first?["key.module_name"] as? String, "Foundation")
        XCTAssertEqual(first?["key.import_kind"] as? String, "struct")
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        // "import struct Foundation.URL" = 28
        XCTAssertEqual(first?["key.length"] as? Int64, 28)
    }

    func testStructureKindQualifiedImportEnum() throws {
        let source = "import enum Foundation.JSONSerialization.ReadingOptions\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Foundation.JSONSerialization.ReadingOptions")
        XCTAssertEqual(first?["key.module_name"] as? String, "Foundation")
        XCTAssertEqual(first?["key.import_kind"] as? String, "enum")
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        // "import enum Foundation.JSONSerialization.ReadingOptions" = 55
        XCTAssertEqual(first?["key.length"] as? Int64, 55)
    }

    func testStructureMixedImportStyles() throws {
        let source = "import Foundation\nimport func Darwin.exit\nimport struct Foundation.URL\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 3)
        let names = imports?.compactMap { ($0 as? [String: SourceKitRepresentable])?["key.name"] as? String }
        XCTAssertEqual(names, ["Foundation", "Darwin.exit", "Foundation.URL"])
        let kinds = imports?.map { ($0 as? [String: SourceKitRepresentable])?["key.import_kind"] as? String }
        XCTAssertEqual(kinds?.count, 3)
        XCTAssertNil(kinds?[0])
        XCTAssertEqual(kinds?[1], "func")
        XCTAssertEqual(kinds?[2], "struct")
    }

    func testStructureTestableSubmoduleImport() throws {
        let source = "@testable import Foundation.NSObject\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 1)
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Foundation.NSObject")
        XCTAssertEqual(first?["key.module_name"] as? String, "Foundation")
        XCTAssertNil(first?["key.import_kind"])
        XCTAssertEqual(first?["key.offset"] as? Int64, 0)
        // "@testable import Foundation.NSObject" = 36
        XCTAssertEqual(first?["key.length"] as? Int64, 36)
        let attrs = first?["key.attributes"] as? [SourceKitRepresentable]
        XCTAssertEqual(attrs?.count, 1)
    }

    func testStructurePlainImportHasNoModulenameOrKind() throws {
        let structure = try Structure(file: File(contents: "import Foundation\nclass Foo {}"), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        let first = imports?.first as? [String: SourceKitRepresentable]
        XCTAssertEqual(first?["key.name"] as? String, "Foundation")
        XCTAssertNil(first?["key.module_name"], "plain module import should not have key.modulename")
        XCTAssertNil(first?["key.import_kind"], "plain module import should not have key.import_kind")
    }

    func testStructureConsecutiveImportsNoBlankLine() throws {
        let source = "import Foundation\nimport UIKit\nimport CoreData\nclass Foo {}"
        let structure = try Structure(file: File(contents: source), extractImports: true)
        let imports = structure.dictionary["key.imports"] as? [SourceKitRepresentable]
        XCTAssertNotNil(imports)
        XCTAssertEqual(imports?.count, 3)
        let names = imports?.compactMap { ($0 as? [String: SourceKitRepresentable])?["key.name"] as? String }
        XCTAssertEqual(names, ["Foundation", "UIKit", "CoreData"])
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
                        ] as [String: Any]
                    ],
                    "key.name": "A"
                ] as [String: Any]
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
