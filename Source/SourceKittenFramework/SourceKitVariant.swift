//
//  SourceKitVariant.swift
//  SourceKitten
//
//  Created by Norio Nomura on 10/17/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE
import SourceKit
#endif

// MARK: - Basic properties of SourceKitVariant
public struct SourceKitVariant {
    public var array: [SourceKitVariant]? {
        get { return box.array }
        set { box.array = newValue }
    }

    public var dictionary: [String: SourceKitVariant]? {
        get { return box.dictionary }
        set { box.dictionary = newValue }
    }

    public var string: String? {
        get { return box.string }
        set { box.string = newValue }
    }

    public var int: Int? {
        get { return box.int }
        set { box.int = newValue }
    }

    public var bool: Bool? {
        get { return box.bool }
        set { box.bool = newValue }
    }

    public var any: Any? { return box.any }

    public subscript(string: String) -> SourceKitVariant? {
        get { return box.dictionary?[string] }
        set { box.dictionary?[string] = newValue }
    }

    public subscript(key: SwiftDocKey) -> SourceKitVariant? {
        get { return box.dictionary?[key.rawValue] }
        set { box.dictionary?[key.rawValue] = newValue }
    }

    internal init(variant: sourcekitd_variant_t, response: sourcekitd_response_t) {
        box = _VariantBox(variant: .variant(variant, _ResponseBox(response)))
    }

    fileprivate let box: _VariantBox
}

// MARK: - Convenient properties for SwiftDocKey
extension SourceKitVariant {
    /// Annotated declaration (String).
    public var annotatedDeclaration: String?
        { return self[.annotatedDeclaration]?.string }
    /// Body length (Int).
    public var bodyLength: Int?
        { return self[.bodyLength]?.int }
    /// Body offset (Int).
    public var bodyOffset: Int? { return self[.bodyOffset]?.int }
    /// Diagnostic stage (String).
    public var diagnosticStage: String? { return self[.diagnosticStage]?.string }
    /// File path (String).
    public var filePath: String? { return self[.filePath]?.string }
    /// Full XML docs (String).
    public var fullXMLDocs: String? { return self[.fullXMLDocs]?.string }
    /// Kind (SourceKitVariant.string).
    public var kind: SourceKitVariant? { return self[.kind] }
    /// Length (Int).
    public var length: Int? { return self[.length]?.int }
    /// Name (String).
    public var name: String? { return self[.name]?.string }
    /// Name length (Int).
    public var nameLength: Int? { return self[.nameLength]?.int }
    /// Name offset (Int).
    public var nameOffset: Int? { return self[.nameOffset]?.int }
    /// Offset (Int).
    public var offset: Int? { return self[.offset]?.int }
    /// Substructure ([SourceKitVariant]).
    public var substructure: [SourceKitVariant]? { return self[.substructure]?.array }
    /// Syntax map ([SourceKitVariant]).
    public var syntaxMap: [SourceKitVariant]? { return self[.syntaxMap]?.array }
    /// Type name (String).
    public var typeName: String? { return self[.typeName]?.string }
    /// Inheritedtype ([SourceKitVariant])
    public var inheritedtypes: [SourceKitVariant]? { return self[.inheritedtypes]?.array }
}

// MARK: - Accessors for SwiftDocKey
extension SourceKitVariant {
    public static func annotatedDeclaration(_ variant: SourceKitVariant) -> String? {
        return variant[.annotatedDeclaration]?.string
    }

    public static func bodyLength(_ variant: SourceKitVariant) -> Int? {
        return variant[.bodyLength]?.int
    }

    public static func bodyOffset(_ variant: SourceKitVariant) -> Int? {
        return variant[.bodyOffset]?.int
    }

    public static func diagnosticStage(_ variant: SourceKitVariant) -> String? {
        return variant[.diagnosticStage]?.string
    }

    public static func filePath(_ variant: SourceKitVariant) -> String? {
        return variant[.filePath]?.string
    }

    public static func fullXMLDocs(_ variant: SourceKitVariant) -> String? {
        return variant[.fullXMLDocs]?.string
    }

    public static func kind(_ variant: SourceKitVariant) -> SourceKitVariant? {
        return variant[.kind]
    }

    public static func length(_ variant: SourceKitVariant) -> Int? {
        return variant[.length]?.int
    }

    public static func name(_ variant: SourceKitVariant) -> String? {
        return variant[.name]?.string
    }

    public static func nameLength(_ variant: SourceKitVariant) -> Int? {
        return variant[.nameLength]?.int
    }

    public static func nameOffset(_ variant: SourceKitVariant) -> Int? {
        return variant[.nameOffset]?.int
    }

    public static func offset(_ variant: SourceKitVariant) -> Int? {
        return variant[.offset]?.int
    }

    public static func substructure(_ variant: SourceKitVariant) -> [SourceKitVariant]? {
        return variant[.substructure]?.array
    }

    public static func syntaxMap(_ variant: SourceKitVariant) -> [SourceKitVariant]? {
        return variant[.syntaxMap]?.array
    }

    public static func typeName(_ variant: SourceKitVariant) -> String? {
        return variant[.typeName]?.string
    }

    public static func inheritedtypes(_ variant: SourceKitVariant) -> [SourceKitVariant]? {
        return variant[.inheritedtypes]?.array
    }
}

// MARK: - ExpressibleByStringLiteral
extension SourceKitVariant: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        box = _VariantBox(variant: .string(value))
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        box = _VariantBox(variant: .string(value))
    }

    public init(unicodeScalarLiteral value: String) {
        box = _VariantBox(variant: .string(value))
    }
}

// MARK: - Equatable
extension SourceKitVariant: Equatable {
    public static func ==(lhs: SourceKitVariant, rhs: SourceKitVariant) -> Bool {
        return lhs.box == rhs.box
    }
}

// MARK: - Implementation
extension SourceKitVariant {
    private enum _VariantCore {
        case variant(sourcekitd_variant_t, _ResponseBox)
        case array([SourceKitVariant])
        case dictionary([String:SourceKitVariant])
        case string(String)
        case int64(Int64)
        case bool(Bool)
        case uid(String)
        case none

        fileprivate init(sourcekitObject: sourcekitd_variant_t, response: _ResponseBox) {
            switch sourcekitd_variant_get_type(sourcekitObject) {
            case SOURCEKITD_VARIANT_TYPE_ARRAY:
                var array = [SourceKitVariant]()
                _ = sourcekitd_variant_array_apply(sourcekitObject) { index, value in
                    array.insert(SourceKitVariant(variant: value, response: response), at:Int(index))
                    return true
                }
                self = .array(array)
            case SOURCEKITD_VARIANT_TYPE_DICTIONARY:
                var count: Int = 0
                _ = sourcekitd_variant_dictionary_apply(sourcekitObject) { _, _ in
                    count += 1
                    return true
                }
                var dictionary = [String:SourceKitVariant](minimumCapacity: count)
                _ = sourcekitd_variant_dictionary_apply(sourcekitObject) { key, value in
                    if let key = String(sourceKitUID: key!) {
                        dictionary[key] = SourceKitVariant(variant: value, response: response)
                    }
                    return true
                }
                self = .dictionary(dictionary)
            case SOURCEKITD_VARIANT_TYPE_STRING:
                let length = sourcekitd_variant_string_get_length(sourcekitObject)
                let ptr = sourcekitd_variant_string_get_ptr(sourcekitObject)
                self = String(bytes: ptr!, length: length).map(_VariantCore.string) ?? .none
            case SOURCEKITD_VARIANT_TYPE_INT64:
                self = .int64(sourcekitd_variant_int64_get_value(sourcekitObject))
            case SOURCEKITD_VARIANT_TYPE_BOOL:
                self = .bool(sourcekitd_variant_bool_get_value(sourcekitObject))
            case SOURCEKITD_VARIANT_TYPE_UID:
                self = String(sourceKitUID: sourcekitd_variant_uid_get_value(sourcekitObject))
                    .map(_VariantCore.string) ?? .none
            case SOURCEKITD_VARIANT_TYPE_NULL:
                self = .none
            default:
                fatalError("Should never happen because we've checked all SOURCEKITD_VARIANT_TYPE")
            }
        }
    }

    private init(variant: sourcekitd_variant_t, response: _ResponseBox) {
        box = _VariantBox(variant: .variant(variant, response))
    }

    fileprivate final class _VariantBox {
        private var _core: _VariantCore

        init(variant: _VariantCore) { _core = variant }

        func resolveType() ->_VariantCore {
            if case let .variant(sourcekitObject, response) = _core {
                _core = _VariantCore(sourcekitObject: sourcekitObject, response: response)
            }
            return _core
        }

        var array: [SourceKitVariant]? {
            get {
                if case let .array(array) = _core { return array }
                if case let .array(array) = resolveType() { return array }
                return nil
            }
            set {
                if case .array = _core, let newValue = newValue {
                    _core = .array(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var dictionary: [String: SourceKitVariant]? {
            get {
                if case let .dictionary(dictionary) = _core { return dictionary }
                if case let .dictionary(dictionary) = resolveType() { return dictionary }
                return nil
            }
            set {
                if case .dictionary = _core, let newValue = newValue {
                    _core = .dictionary(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var string: String? {
            get {
                if case let .string(string) = _core { return string }
                if case let .uid(string) = _core { return string }
                switch resolveType() {
                case let .string(string): return string
                case let .uid(string): return string
                default: return nil
                }
            }
            set {
                if case .string = _core, let newValue = newValue {
                    _core = .string(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var int: Int? {
            get {
                if case let .int64(int64) = _core { return Int(int64) }
                if case let .int64(int64) = resolveType() { return Int(int64) }
                return nil
            }
            set {
                if case .int64 = _core, let newValue = newValue {
                    _core = .int64(Int64(newValue))
                } else {
                    fatalError()
                }
            }
        }

        var int64: Int64? {
            get {
                if case let .int64(int64) = _core { return int64 }
                if case let .int64(int64) = resolveType() { return int64 }
                return nil
            }
            set {
                if case .int64 = _core, let newValue = newValue {
                    _core = .int64(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var bool: Bool? {
            get {
                if case let .bool(bool) = _core { return bool }
                if case let .bool(bool) = resolveType() { return bool }
                return nil
            }
            set {
                if case .bool = _core, let newValue = newValue {
                    _core = _VariantCore.bool(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var any: Any? {
            switch _core {
            case let .variant(sourcekitObject, response):
                _core = _VariantCore(sourcekitObject: sourcekitObject, response: response)
                return self.any
            case let .array(array):
                return array.flatMap { $0.any }
            case let .dictionary(dictionary):
                var anyDictionary = [String:Any](minimumCapacity: dictionary.count)
                for (key,value) in dictionary {
                    anyDictionary[key] = value.any
                }
                return anyDictionary
            case let .string(string):
                return string
            case let .int64(int64):
                return Int(int64)
            case let .bool(bool):
                return bool
            case let .uid(uidString):
                return uidString
            case .none:
                return nil
            }
        }
    }

    fileprivate final class _ResponseBox {
        private let response: sourcekitd_response_t
        init(_ response: sourcekitd_response_t) { self.response = response }
        deinit { sourcekitd_response_dispose(response) }
    }
}

// MARK: - Equatable
extension SourceKitVariant._VariantBox: Equatable {
    public static func ==(lhs: SourceKitVariant._VariantBox, rhs: SourceKitVariant._VariantBox) -> Bool {
        switch (lhs.resolveType(), rhs.resolveType()) {
        case let (.array(lhs), .array(rhs)): return lhs == rhs
        case let (.dictionary(lhs), .dictionary(rhs)): return lhs == rhs
        case let (.string(lhs), .string(rhs)): return lhs == rhs
        case let (.int64(lhs), .int64(rhs)): return lhs == rhs
        case let (.bool(lhs), .bool(rhs)): return lhs == rhs
        case let (.uid(lhs), .uid(rhs)): return lhs == rhs
        case (.none, .none): return true
        default: return false
        }
    }
}

// MARK: - == to String
public func ==(lhs: SourceKitVariant?, rhs: String) -> Bool {
    return lhs.map { $0 == rhs } ?? false
}

public func ==(lhs: String, rhs: SourceKitVariant?) -> Bool {
    return rhs == lhs
}

extension SourceKitVariant {
    public static func ==(lhs: SourceKitVariant, rhs: String) -> Bool {
        return lhs.string.map { $0 == rhs } ?? false
    }

    public static func ==(lhs: String, rhs: SourceKitVariant) -> Bool {
        return rhs == lhs
    }
}

// MARK: - == to RawRepresentable
public func ==<T: RawRepresentable>(lhs: SourceKitVariant?, rhs: T) -> Bool
    where T.RawValue == String {
        return lhs == rhs.rawValue
}

public func ==<T: RawRepresentable>(lhs: T, rhs: SourceKitVariant?) -> Bool
    where T.RawValue == String {
        return rhs == lhs
}

extension SourceKitVariant {
    public static func ==<T: RawRepresentable>(lhs: SourceKitVariant, rhs: T) -> Bool
        where T.RawValue == String {
            return lhs == rhs.rawValue
    }

    public static func ==<T: RawRepresentable>(lhs: T, rhs: SourceKitVariant) -> Bool
        where T.RawValue == String {
            return rhs == lhs
    }
}

// MARK: - Custom
extension SourceKitVariant {
    var attributes: [SourceKitVariant]? { return self["key.attributes"]?.array }
    var attribute: SourceKitVariant? { return self["key.attribute"] }
}
