//
//  SourceKitVariantTests.swift
//  SourceKitten
//
//  Created by Norio Nomura on 11/28/16.
//  Copyright (c) 2016 SourceKitten. All rights reserved.
//

import XCTest
@testable import SourceKittenFramework

class SourceKitVariantTests: XCTestCase {

    func testSupportArray() {
        // Initializer
        let variant = SourceKitVariant(["foo", true, 1])

        // Property
        XCTAssertEqual(variant.array!, ["foo", true, 1])
        XCTAssertNotEqual(variant.array!, ["bar", true, 1])

        // ExpressibleByArrayLiteral
        XCTAssertEqual(variant, ["foo", true, 1])
        XCTAssertNotEqual(variant, ["bar", true, 1])

        // Any
        XCTAssertTrue(variant.any is [Any])
        XCTAssertFalse(variant.any is Bool)
        XCTAssertFalse(variant.any is [String:Any])
        XCTAssertFalse(variant.any is Int)
        XCTAssertFalse(variant.any is String)

        // Subscript
        XCTAssertEqual(variant[0], "foo")
        XCTAssertEqual(variant[1], true)
        XCTAssertEqual(variant[2], 1)

        // Mutation
        var mutable = variant
        mutable.array = ["bar", true, 1]
        XCTAssertNotEqual(mutable, ["foo", true, 1])
        XCTAssertEqual(mutable, ["bar", true, 1])
        mutable[0] = "baz"
        mutable[1] = false
        mutable[2] = 2
        XCTAssertEqual(mutable, ["baz", false, 2])

        // Copy on write
        XCTAssertNotEqual(mutable, variant)
    }

    func testSupportBool() {
        // Initializer
        let variant = SourceKitVariant(true)

        // Property
        XCTAssertEqual(variant.bool, true)
        XCTAssertNotEqual(variant.bool, false)

        // ExpressibleByBooleanLiteral
        XCTAssertEqual(variant, true)
        XCTAssertNotEqual(variant, false)

        // Any
        XCTAssertFalse(variant.any is [Any])
        XCTAssertTrue(variant.any is Bool)
        XCTAssertFalse(variant.any is [String:Any])
        XCTAssertFalse(variant.any is Int)
        XCTAssertFalse(variant.any is String)

        // Mutation
        var mutable = variant
        mutable.bool = false
        XCTAssertNotEqual(mutable.bool, true)
        XCTAssertEqual(mutable.bool, false)

        // Copy on write
        XCTAssertNotEqual(mutable, variant)
    }

    func testSupportDictionary() {
        // Initializer
        let variant = SourceKitVariant(["key.request": "foo"])

        // Property
        XCTAssertEqual(variant.dictionary!, ["key.request": "foo"])
        XCTAssertNotEqual(variant.dictionary!, ["key.request": "bar"])

        // ExpressibleByDictionaryLiteral
        XCTAssertEqual(variant, ["key.request": "foo"])
        XCTAssertNotEqual(variant, ["key.request": "bar"])

        // Any
        XCTAssertFalse(variant.any is [Any])
        XCTAssertFalse(variant.any is Bool)
        XCTAssertTrue(variant.any is [String:Any])
        XCTAssertFalse(variant.any is Int)
        XCTAssertFalse(variant.any is String)

        // Subscript
        XCTAssertEqual(variant["key.request"], "foo")
        XCTAssertNil(variant["key.name"])

        // mutation
        var mutable = variant
        mutable.dictionary = ["key.request": "bar"]
        XCTAssertNotEqual(mutable, ["key.request": "foo"])
        XCTAssertEqual(mutable, ["key.request": "bar"])

        // Copy on write
        XCTAssertNotEqual(mutable, variant)

        // remove value
        var removable = variant
        removable.removeValue(forKey: "key.request")
        XCTAssertNotEqual(removable, ["key.request": "foo"])
        XCTAssertEqual(removable, [:])

        // Copy on write
        XCTAssertNotEqual(removable, variant)
    }

    func testSupportInteger() {
        // Initializer
        let variant = SourceKitVariant(1)

        // Property
        XCTAssertEqual(variant.int, 1)
        XCTAssertNotEqual(variant.int, 2)

        // ExpressibleByIntegerLiteral
        XCTAssertEqual(variant, 1)
        XCTAssertNotEqual(variant, 2)

        // Any
        XCTAssertFalse(variant.any is [Any])
        XCTAssertFalse(variant.any is Bool)
        XCTAssertFalse(variant.any is [String:Any])
        XCTAssertTrue(variant.any is Int)
        XCTAssertFalse(variant.any is String)

        // Mutation
        var mutable = variant
        mutable.int = 2
        XCTAssertNotEqual(mutable.int, 1)
        XCTAssertEqual(mutable.int, 2)

        // Copy on write
        XCTAssertNotEqual(mutable, variant)
    }

    func testSupportString() {
        // Initializer
        let variant = SourceKitVariant("foo")

        // Property
        XCTAssertEqual(variant.string, "foo")
        XCTAssertNotEqual(variant.string, "bar")

        // ExpressibleByStringLiteral
        XCTAssertEqual(variant, "foo")
        XCTAssertNotEqual(variant, "bar")

        // Any
        XCTAssertFalse(variant.any is [Any])
        XCTAssertFalse(variant.any is Bool)
        XCTAssertFalse(variant.any is [String:Any])
        XCTAssertFalse(variant.any is Int)
        XCTAssertTrue(variant.any is String)

        // Mutation
        var mutable = variant
        mutable.string = "bar"
        XCTAssertNotEqual(mutable.string, "foo")
        XCTAssertEqual(mutable.string, "bar")

        // Copy on write
        XCTAssertNotEqual(mutable, variant)
    }

    func testUID() {
        // Initializer
        let variant = SourceKitVariant(UID("key.request"))

        // Property
        XCTAssertEqual(variant.uid, UID("key.request"))
        XCTAssertNotEqual(variant.uid, UID("key.name"))

        // Any
        XCTAssertFalse(variant.any is [Any])
        XCTAssertFalse(variant.any is Bool)
        XCTAssertFalse(variant.any is [String:Any])
        XCTAssertFalse(variant.any is Int)
        XCTAssertTrue(variant.any is String)

        // Mutation
        var mutable = variant
        mutable.uid = UID("key.name")
        XCTAssertNotEqual(mutable.uid, UID("key.request"))
        XCTAssertEqual(mutable.uid, UID("key.name"))

        // Copy on write
        XCTAssertNotEqual(mutable, variant)
    }
}

extension SourceKitVariantTests {
    static var allTests: [(String, (SourceKitVariantTests) -> () throws -> Void)] {
        return [
            ("testSupportArray", testSupportArray),
            ("testSupportBool", testSupportBool),
            ("testSupportDictionary", testSupportDictionary),
            ("testSupportInteger", testSupportInteger),
            ("testSupportString", testSupportString),
            ("testUID", testUID)
        ]
    }
}
