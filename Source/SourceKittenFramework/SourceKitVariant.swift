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

/// Represent sourcekitd_variant_t as Value Type
public struct SourceKitVariant {
    fileprivate var box: _VariantBox
}

// MARK: - Basic properties of SourceKitVariant
extension SourceKitVariant {
    public var array: [SourceKitVariant]? {
        get { return box.array }
        set {
            prepareMutation()
            box.array = newValue
        }
    }

    public var dictionary: [UID:SourceKitVariant]? {
        get { return box.dictionary }
        set {
            prepareMutation()
            box.dictionary = newValue
        }
    }

    public var string: String? {
        get { return box.string }
        set {
            prepareMutation()
            box.string = newValue
        }
    }

    public var int: Int? {
        get { return box.int }
        set {
            prepareMutation()
            box.int = newValue
        }
    }

    public var bool: Bool? {
        get { return box.bool }
        set {
            prepareMutation()
            box.bool = newValue
        }
    }

    public var uid: UID? {
        get { return box.uid }
        set {
            prepareMutation()
            box.uid = newValue
        }
    }

    public var any: Any? { return box.any }

    public subscript(string: String) -> SourceKitVariant? {
        get { return box.dictionary?[UID(string)] }
        set {
            prepareMutation()
            box.dictionary?[UID(string)] = newValue
        }
    }

    public subscript(uid: UID) -> SourceKitVariant? {
        get { return box.dictionary?[uid] }
        set {
            prepareMutation()
            box.dictionary?[uid] = newValue
        }
    }

    public subscript(index: Int) -> SourceKitVariant? {
        get { return box.array?[index] }
        set {
            prepareMutation()
            box.array?[index] = newValue!
        }
    }
}

// MARK: - Convenient properties for well known UIDs
extension SourceKitVariant {
    public subscript(key: UID.Key) -> SourceKitVariant? {
        get { return box.dictionary?[key.uid] }
        set {
            prepareMutation()
            box.dictionary?[key.uid] = newValue
        }
    }

    @discardableResult
    mutating public func removeValue(forKey key: UID.Key) -> SourceKitVariant? {
        prepareMutation()
        var dictionary = box.dictionary
        let result = dictionary?.removeValue(forKey: key.uid)
        box.dictionary = dictionary
        return result
    }

    /// Accessibility (UID.SourceLangSwiftAccessibility).
    public var accessibility: UID.SourceLangSwiftAccessibility? {
        return self[.accessibility]?.uid.map(UID.SourceLangSwiftAccessibility.init)
    }
    /// Annotated declaration (String).
    public var annotatedDeclaration: String? {
        return self[.annotated_decl]?.string
    }
    /// associated_usrs (String).
    public var associated_usrs: String? {
        return self[.associated_usrs]?.string
    }
    /// Attributes ([SourceKitVariant]).
    public var attributes: [SourceKitVariant]? {
        return self[.attributes]?.array
    }
    /// Attribute (UID.SourceDeclAttribute).
    public var attribute: UID.SourceDeclAttribute? {
        return self[.attribute]?.uid.map(UID.SourceDeclAttribute.init)
    }
    /// Body length (Int).
    public var bodyLength: Int? {
        return self[.bodylength]?.int
    }
    /// Body offset (Int).
    public var bodyOffset: Int? {
        return self[.bodyoffset]?.int
    }
    /// context (String).
    public var context: String? {
        return self[.context]?.string
    }
    /// description (String).
    public var description: String? {
        return self[.description]?.string
    }
    /// Diagnostic stage (UID.SourceDiagnosticStageSwift).
    public var diagnosticStage: UID.SourceDiagnosticStageSwift? {
        return self[.diagnostic_stage]?.uid.map(UID.SourceDiagnosticStageSwift.init)
    }
    /// docBrief (String).
    public var docBrief: String? {
        return self[.docBrief]?.string
    }
    /// File path (String).
    public var filePath: String? {
        return self[.filepath]?.string
    }
    /// Full XML docs (String).
    public var docFullAsXML: String? {
        return self[.docFull_As_Xml]?.string
    }
    /// Inheritedtype ([SourceKitVariant])
    public var inheritedTypes: [SourceKitVariant]? {
        return self[.inheritedtypes]?.array
    }
    /// Kind (UID).
    public var kind: UID? {
        return self[.kind]?.uid
    }
    /// Length (Int).
    public var length: Int? {
        return self[.length]?.int
    }
    /// ModuleName (String).
    public var moduleName: String? {
        return self[.modulename]?.string
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
    /// results ([SourceKitVariant]).
    public var results: [SourceKitVariant]? {
        get { return self[.results]?.array }
        set { self[.results] = SourceKitVariant(newValue) }
    }
    /// sourcetext
    public var sourceText: String? {
        return self[.sourcetext]?.string
    }
    /// Substructure ([SourceKitVariant]).
    public var subStructure: [SourceKitVariant]? {
        get { return self[.substructure]?.array }
        set { self[.substructure] = SourceKitVariant(newValue) }
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

// MARK: - Convenient properties for Custom Keys
extension SourceKitVariant {
    private struct Custom {
        static let docColumn: UID = "key.doc.column"
        static let documentationComment: UID = "key.doc.comment"
        static let docDeclaration: UID = "key.doc.declaration"
        static let docDiscussion: UID = "key.doc.discussion"
        static let docFile: UID = "key.doc.file"
        static let docLine: UID = "key.doc.line"
        static let docName: UID = "key.doc.name"
        static let docParameters: UID = "key.doc.parameters"
        static let docResultDiscussion: UID = "key.doc.result_discussion"
        static let docType: UID = "key.doc.type"
        // static let usr: UID.Key = "key.usr"
        static let parsedDeclaration: UID = "key.parsed_declaration"
        static let parsedScopeEnd: UID = "key.parsed_scope.end"
        static let parsedScopeStart: UID = "key.parsed_scope.start"
        static let swiftDeclaration: UID = "key.swift_declaration"
        static let alwaysDeprecated: UID = "key.always_deprecated"
        static let alwaysUnavailable: UID = "key.always_unavailable"
        static let deprecationMessage: UID = "key.deprecation_message"
        static let unavailableMessage: UID = "key.unavailable_message"
    }

    /// Column where the token's declaration begins (Int).
    public var docColumn: Int? {
        get { return self[Custom.docColumn]?.int }
        set { self[Custom.docColumn] = SourceKitVariant(newValue) }
    }

    /// Documentation comment (String).
    public var documentationComment: String? {
        get { return self[Custom.documentationComment]?.string }
        set { self[Custom.documentationComment] = SourceKitVariant(newValue) }
    }

    /// Declaration of documented token (String).
    public var docDeclaration: String? {
        get { return self[Custom.docDeclaration]?.string }
        set { self[Custom.docDeclaration] = SourceKitVariant(newValue) }
    }

    /// Discussion documentation of documented token ([SourceKitVariant]).
    public var docDiscussion: [SourceKitVariant]? {
        get { return self[Custom.docDiscussion]?.array }
        set { self[Custom.docDiscussion] = SourceKitVariant(newValue) }
    }

    /// File where the documented token is located (String).
    public var docFile: String? {
        get { return self[Custom.docFile]?.string }
        set { self[Custom.docFile] = SourceKitVariant(newValue) }
    }

    /// Line where the token's declaration begins (Int).
    public var docLine: Int? {
        get { return self[Custom.docLine]?.int }
        set { self[Custom.docLine] = SourceKitVariant(newValue) }
    }

    /// Name of documented token (String).
    public var docName: String? {
        get { return self[Custom.docName]?.string }
        set { self[Custom.docName] = SourceKitVariant(newValue) }
    }

    /// Parameters of documented token ([SourceKitVariant]).
    public var docParameters: [SourceKitVariant]? {
        get { return self[Custom.docParameters]?.array }
        set { self[Custom.docParameters] = SourceKitVariant(newValue) }
    }

    /// Doc result discussion ([SourceKitVariant]).
    public var docResultDiscussion: [SourceKitVariant]? {
        get { return self[Custom.docResultDiscussion]?.array }
        set { self[Custom.docResultDiscussion] = SourceKitVariant(newValue) }
    }

    /// Type of documented token (String).
    public var docType: String? {
        get { return self[Custom.docType]?.string }
        set { self[Custom.docType] = SourceKitVariant(newValue) }
    }

    /// USR (String).
    public var usr: String? {
        get { return self[.usr]?.string }
        set { self[.usr] = SourceKitVariant(newValue) }
    }

    /// Parsed Declaration (String)
    public var parsedDeclaration: String? {
        get { return self[Custom.parsedDeclaration]?.string }
        set { self[Custom.parsedDeclaration] = SourceKitVariant(newValue) }
    }

    /// Parsed scope end (Int).
    public var parsedScopeEnd: Int? {
        get { return self[Custom.parsedScopeEnd]?.int }
        set { self[Custom.parsedScopeEnd] = SourceKitVariant(newValue) }
    }

    /// Parsed scope start (Int).
    public var parsedScopeStart: Int? {
        get { return self[Custom.parsedScopeStart]?.int }
        set { self[Custom.parsedScopeStart] = SourceKitVariant(newValue) }
    }

    /// Swift Declaration (String).
    public var swiftDeclaration: String? {
        get { return self[Custom.swiftDeclaration]?.string }
        set { self[Custom.swiftDeclaration] = SourceKitVariant(newValue) }
    }

    /// Always deprecated (Bool).
    public var alwaysDeprecated: Bool? {
        get { return self[Custom.alwaysDeprecated]?.bool }
        set { self[Custom.alwaysDeprecated] = SourceKitVariant(newValue) }
    }

    /// Always unavailable (Bool).
    public var alwaysUnavailable: Bool? {
        get { return self[Custom.alwaysUnavailable]?.bool }
        set { self[Custom.alwaysUnavailable] = SourceKitVariant(newValue) }
    }

    /// Deprecation message (String).
    public var deprecationMessage: String? {
        get { return self[Custom.deprecationMessage]?.string }
        set { self[Custom.deprecationMessage] = SourceKitVariant(newValue) }
    }

    /// Unavailable message (String).
    public var unavailableMessage: String? {
        get { return self[Custom.unavailableMessage]?.string }
        set { self[Custom.unavailableMessage] = SourceKitVariant(newValue) }
    }

}

// MARK: - ExpressibleByArrayLiteral
extension SourceKitVariant: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: SourceKitVariant...) {
        box = _VariantBox(variant: .array(elements))
    }
}

// MARK: - ExpressibleByBooleanLiteral
extension SourceKitVariant: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        box = _VariantBox(variant: .bool(value))
    }
}

// MARK: - ExpressibleByDictionaryLiteral
extension SourceKitVariant: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (UID, SourceKitVariant)...) {
        var dictionary = [UID:SourceKitVariant](minimumCapacity: elements.count)
        elements.forEach { dictionary[$0.0] = $0.1 }
        box = _VariantBox(variant: .dictionary(dictionary))
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension SourceKitVariant: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        box = _VariantBox(variant: .int64(Int64(value)))
    }
}

// MARK: - ExpressibleByStringLiteral
extension SourceKitVariant: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        box = _VariantBox(variant: .string(value))
    }

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterType) {
        box = _VariantBox(variant: .string(value))
    }

    public init(unicodeScalarLiteral value: UnicodeScalarType) {
        box = _VariantBox(variant: .string(value))
    }
}

// MARK: - Equatable
extension SourceKitVariant: Equatable {
    public static func ==(lhs: SourceKitVariant, rhs: SourceKitVariant) -> Bool {
        return lhs.box == rhs.box
    }
}

// MARK: - Initializers
extension SourceKitVariant {
    internal init(_ array: [SourceKitVariant]?) {
        box = _VariantBox(variant: array.map(_VariantCore.array) ?? .none)
    }

    internal init(_ dictionary: [UID:SourceKitVariant]? = [:]) {
        box = _VariantBox(variant: dictionary.map(_VariantCore.dictionary) ?? .none)
    }

    internal init(_ string: String?) {
        box = _VariantBox(variant: string.map(_VariantCore.string) ?? .none)
    }

    internal init(_ int: Int?) {
        box = _VariantBox(variant: int.map({ _VariantCore.int64(Int64($0)) }) ?? .none)
    }

    internal init(_ bool: Bool?) {
        box = _VariantBox(variant: bool.map(_VariantCore.bool) ?? .none)
    }

    internal init(_ uid: UID) {
        box = _VariantBox(variant: .uid(uid))
    }

    internal init(variant: sourcekitd_variant_t, response: sourcekitd_response_t) {
        box = _VariantBox(variant: .variant(variant, _ResponseBox(response)))
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

        fileprivate func copy() -> _VariantBox {
            return .init(variant: _core)
        }
    }

    fileprivate final class _ResponseBox {
        private let response: sourcekitd_response_t
        init(_ response: sourcekitd_response_t) { self.response = response }
        deinit { sourcekitd_response_dispose(response) }
    }
}

// MARK: - Copy on write
extension SourceKitVariant {
    fileprivate mutating func prepareMutation() {
        if !isKnownUniquelyReferenced(&box) {
            box = box.copy()
        }
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

extension SourceKitVariant {
    /// Merged SourceKitVariant
    /// If both of variants has same key, value will be overwritten by one of given variant.
    ///
    /// - Parameters:
    ///   - variant: SourceKitVariant
    /// - Returns: Merged SourceKitVariant
    func merging(with variant: SourceKitVariant?) -> SourceKitVariant {
        if var dictionary = dictionary,
            let dict2 = variant?.dictionary {
            for (key, value) in dict2 {
                dictionary[key] = value
            }
            return SourceKitVariant(dictionary)
        }
        return self
    }
}
