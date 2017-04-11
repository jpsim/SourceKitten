//
//  SourceKitObject.swift
//  SourceKitten
//
//  Created by Norio Nomura on 11/29/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE
    import SourceKit
#endif

public protocol SourceKitObjectConvertible {
    var object: sourcekitd_object_t? { get }
}

extension Array: SourceKitObjectConvertible {
    public var object: sourcekitd_object_t? {
        guard let first = first, first is SourceKitObjectConvertible else { return nil }
        let objects: [sourcekitd_object_t?] = map { ($0 as! SourceKitObjectConvertible).object }
        return sourcekitd_request_array_create(objects, objects.count)
    }
}

extension Dictionary: SourceKitObjectConvertible {
    public var object: sourcekitd_object_t? {
        guard let (key, value) = first, key is UID.Key, value is SourceKitObjectConvertible else { return nil }
        let keys: [sourcekitd_uid_t?] = self.map { ($0.key as! UID.Key).uid.uid }
        let values: [sourcekitd_object_t?] = self.map { ($0.value as! SourceKitObjectConvertible).object }
        return sourcekitd_request_dictionary_create(keys, values, count)
    }
}

extension Int: SourceKitObjectConvertible {
    public var object: sourcekitd_object_t? {
        return sourcekitd_request_int64_create(Int64(self))
    }
}

extension String: SourceKitObjectConvertible {
    public var object: sourcekitd_object_t? {
        return sourcekitd_request_string_create(self)
    }
}

/// Swift representation of sourcekitd_object_t
public struct SourceKitObject {
    public let object: sourcekitd_object_t?

    /// Updates the value stored in the dictionary for the given key,
    /// or adds a new key-value pair if the key does not exist.
    ///
    /// - Parameters:
    ///   - value: The new value to add to the dictionary.
    ///   - key: The key to associate with value. If key already exists in the dictionary, 
    ///     value replaces the existing associated value. If key isn't already a key of the dictionary
    public func updateValue(_ value: SourceKitObjectConvertible, forKey key: UID.Key) {
        precondition(object != nil)
        precondition(value.object != nil)
        sourcekitd_request_dictionary_set_value(object!, key.uid.uid, value.object!)
    }
}

extension SourceKitObject: SourceKitObjectConvertible {}

// MARK: - CustomStringConvertible
extension SourceKitObject: CustomStringConvertible {
    public var description: String {
        guard let object = object else { return "" }
        let bytes = sourcekitd_request_description_copy(object)!
        let length = Int(strlen(bytes))
        return String(bytesNoCopy: bytes, length: length, encoding: .utf8, freeWhenDone: true)!
    }
}

// MARK: - ExpressibleByArrayLiteral
extension SourceKitObject: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: SourceKitObject...) {
        object = elements.object
    }
}

// MARK: - ExpressibleByDictionaryLiteral
extension SourceKitObject: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (UID.Key, SourceKitObjectConvertible)...) {
        let keys: [sourcekitd_uid_t?] = elements.map { $0.0.uid.uid }
        let values: [sourcekitd_object_t?] = elements.map { $0.1.object }
        object = sourcekitd_request_dictionary_create(keys, values, elements.count)
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension SourceKitObject: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        object = value.object
    }
}

// MARK: - ExpressibleByStringLiteral
extension SourceKitObject: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
       object = value.object
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        object = value.object
    }

    public init(unicodeScalarLiteral value: String) {
        object = value.object
    }
}
