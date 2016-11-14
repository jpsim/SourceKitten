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

    public var dictionary: [UID:SourceKitVariant]? {
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

    public var uid: UID? {
        get { return box.uid }
        set { box.uid = newValue }
    }

    public var any: Any? { return box.any }

    public subscript(string: String) -> SourceKitVariant? {
        get { return box.dictionary?[UID(string)] }
        set { box.dictionary?[UID(string)] = newValue }
    }

    public subscript(uid: UID) -> SourceKitVariant? {
        get { return box.dictionary?[uid] }
        set { box.dictionary?[uid] = newValue }
    }

    internal init(variant: sourcekitd_variant_t, response: sourcekitd_response_t) {
        box = _VariantBox(variant: .variant(variant, _ResponseBox(response)))
    }

    fileprivate let box: _VariantBox
}

// MARK: - Convenient properties of SourceKitVariant for well known UID.key*
extension SourceKitVariant {
    public subscript(key: UID.key) -> SourceKitVariant? {
        get { return box.dictionary?[key.uid] }
        set { box.dictionary?[key.uid] = newValue }
    }

    /// Accessibility (UID.source.lang.swift.accessibility).
    public var accessibility: UID.source.lang.swift.accessibility? {
        return self[.accessibility]?.uid.map(UID.source.lang.swift.accessibility.init)
    }
    /// Annotated declaration (String).
    public var annotatedDeclaration: String? {
        return self[.annotated_decl]?.string
    }
    /// Attributes ([SourceKitVariant]).
    public var attributes: [SourceKitVariant]? {
        return self[.attributes]?.array
    }
    /// Attribute (UID.source.decl.attribute).
    public var attribute: UID.source.decl.attribute? {
        return self[.attribute]?.uid.map(UID.source.decl.attribute.init)
    }
    /// Body length (Int).
    public var bodyLength: Int? {
        return self[.bodylength]?.int
    }
    /// Body offset (Int).
    public var bodyOffset: Int? {
        return self[.bodyoffset]?.int
    }
    /// Diagnostic stage (String).
    public var diagnosticStage: String? {
        return self[.diagnostic_stage]?.string
    }
    /// File path (String).
    public var filePath: String? {
        return self[.filepath]?.string
    }
    /// Full XML docs (String).
    public var docFullAsXML: String? {
        return self[UID.key.doc.full_as_xml.uid]?.string
    }
    /// Inheritedtype ([SourceKitVariant])
    public var inheritedTypes: [SourceKitVariant]? {
        return self[.inheritedtypes]?.array
    }
    /// Kind (SourceKitVariant.string).
    public var kind: UID? {
        return self[.kind]?.uid
    }
    /// Length (Int).
    public var length: Int? {
        return self[.length]?.int
    }
    /// Name (String).
    public var name: String? {
        return self[.name]?.string
    }
    /// Name length (Int).
    public var nameLength: Int? {
        return self[.namelength]?.int
    }
    /// Name offset (Int).
    public var nameOffset: Int? {
        return self[.nameoffset]?.int
    }
    /// Offset (Int).
    public var offset: Int? {
        return self[.offset]?.int
    }
    /// sourcetext
    public var sourceText: String? {
        return self[.sourcetext]?.string
    }
    /// Substructure ([SourceKitVariant]).
    public var subStructure: [SourceKitVariant]? {
        return self[.substructure]?.array
    }
    /// Syntax map ([SourceKitVariant]).
    public var syntaxMap: [SourceKitVariant]? {
        return self[.syntaxmap]?.array
    }
    /// Type name (String).
    public var typeName: String? {
        return self[.typename]?.string
    }
}

// MARK: - Accessors of SourceKitVariant for well known UID.key*
extension SourceKitVariant {
    public static func annotatedDeclaration(_ variant: SourceKitVariant) -> String? {
        return variant[.keyAnnotatedDecl]?.string
    }

    public static func bodyLength(_ variant: SourceKitVariant) -> Int? {
        return variant[.keyBodyLength]?.int
    }

    public static func bodyOffset(_ variant: SourceKitVariant) -> Int? {
        return variant[.keyBodyOffset]?.int
    }

    public static func diagnosticStage(_ variant: SourceKitVariant) -> String? {
        return variant[.keyDiagnosticStage]?.string
    }

    public static func filePath(_ variant: SourceKitVariant) -> String? {
        return variant[.keyFilePath]?.string
    }

    public static func docFullAsXML(_ variant: SourceKitVariant) -> String? {
        return variant[.keyDocFullAsXML]?.string
    }

    public static func kind(_ variant: SourceKitVariant) -> SourceKitVariant? {
        return variant[.keyKind]
    }

    public static func length(_ variant: SourceKitVariant) -> Int? {
        return variant[.keyLength]?.int
    }

    public static func name(_ variant: SourceKitVariant) -> String? {
        return variant[.keyName]?.string
    }

    public static func nameLength(_ variant: SourceKitVariant) -> Int? {
        return variant[.keyNameLength]?.int
    }

    public static func nameOffset(_ variant: SourceKitVariant) -> Int? {
        return variant[.keyNameOffset]?.int
    }

    public static func offset(_ variant: SourceKitVariant) -> Int? {
        return variant[.keyOffset]?.int
    }

    public static func subStructure(_ variant: SourceKitVariant) -> [SourceKitVariant]? {
        return variant[.keySubStructure]?.array
    }

    public static func syntaxMap(_ variant: SourceKitVariant) -> [SourceKitVariant]? {
        return variant[.keySyntaxMap]?.array
    }

    public static func typeName(_ variant: SourceKitVariant) -> String? {
        return variant[.keyTypeName]?.string
    }

    public static func inheritedtypes(_ variant: SourceKitVariant) -> [SourceKitVariant]? {
        return variant[.keyInheritedTypes]?.array
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
    fileprivate enum _VariantCore {
        case variant(sourcekitd_variant_t, _ResponseBox)
        case array([SourceKitVariant])
        case dictionary([UID:SourceKitVariant])
        case string(String)
        case int64(Int64)
        case bool(Bool)
        case uid(UID)
        case none

        fileprivate init(sourcekitObject: sourcekitd_variant_t, response: _ResponseBox) {
            switch sourcekitd_variant_get_type(sourcekitObject) {
            case SOURCEKITD_VARIANT_TYPE_ARRAY:
                var array = [SourceKitVariant]()
                _ = __sourcekitd_variant_array_apply(sourcekitObject) { index, value in
                    array.insert(SourceKitVariant(variant: value, response: response), at:Int(index))
                    return true
                }
                self = .array(array)
            case SOURCEKITD_VARIANT_TYPE_DICTIONARY:
                var count: Int = 0
                _ = __sourcekitd_variant_dictionary_apply(sourcekitObject) { _, _ in
                    count += 1
                    return true
                }
                var dictionary = [UID:SourceKitVariant](minimumCapacity: count)
                _ = __sourcekitd_variant_dictionary_apply(sourcekitObject) { uid, value in
                    if let uid = uid {
                        dictionary[UID(uid)] = SourceKitVariant(variant: value, response: response)
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
                self = .uid(UID(sourcekitd_variant_uid_get_value(sourcekitObject)))
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

        fileprivate init(variant: _VariantCore) { _core = variant }

        fileprivate func resolveType() ->_VariantCore {
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

        var dictionary: [UID:SourceKitVariant]? {
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
                if case let .uid(uid) = _core { return uid.string }
                switch resolveType() {
                case let .string(string): return string
                case let .uid(uid): return uid.string
                default: return nil
                }
            }
            set {
                if case .string = _core, let newValue = newValue {
                    _core = .string(newValue)
                } else if case .uid = _core, let newValue = newValue {
                    _core = .uid(UID(newValue))
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
                    _core = .bool(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var uid: UID? {
            get {
                if case let .uid(uid) = _core { return uid }
                if case let .uid(uid) = resolveType() { return uid }
                return nil
            }
            set {
                if case .uid = _core, let newValue = newValue {
                    _core = .uid(newValue)
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
                    anyDictionary[key.string] = value.any
                }
                return anyDictionary
            case let .string(string):
                return string
            case let .int64(int64):
                return Int(int64)
            case let .bool(bool):
                return bool
            case let .uid(uid):
                return uid.string
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

// MARK: - sourcekitd_variant_*_apply
// It is hard to pass multiple Swift objects in context parameter on calling
// sourcekitd's `*_apply_f` functions.
// So, I added `*_apply` compatible functions that passing Swift closure as
// context and calling them in C function.
func __sourcekitd_variant_array_apply(
    _ array: sourcekitd_variant_t,
    _ applier: @escaping (Int, sourcekitd_variant_t) -> Bool) -> Bool {
    typealias array_applier = (Int, sourcekitd_variant_t) -> Bool
    var applier = applier
    return withUnsafeMutablePointer(to: &applier) { context in
        sourcekitd_variant_array_apply_f(array, { index, value, context in
            if let context = context {
                let applier = context.assumingMemoryBound(to: array_applier.self).pointee
                return applier(index, value)
            }
            return true
            }, context)
    }
}

func __sourcekitd_variant_dictionary_apply(
    _ dict: sourcekitd_variant_t,
    _ applier: @escaping (sourcekitd_uid_t?, sourcekitd_variant_t) -> Bool) -> Bool {
    typealias dictionary_applier = (sourcekitd_uid_t?, sourcekitd_variant_t) -> Bool
    var applier = applier
    return withUnsafeMutablePointer(to: &applier) { context in
        sourcekitd_variant_dictionary_apply_f(dict, { key, value, context in
            if let context = context {
                let applier = context.assumingMemoryBound(to: dictionary_applier.self).pointee
                return applier(key, value)
            }
            return true
            }, context)
    }
}
