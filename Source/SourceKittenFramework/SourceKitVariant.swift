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
                self = String(bytes: ptr!, length: length).map(_VariantCore.uid) ?? .none
            case SOURCEKITD_VARIANT_TYPE_INT64:
                self = .int64(sourcekitd_variant_int64_get_value(sourcekitObject))
            case SOURCEKITD_VARIANT_TYPE_BOOL:
                self = .bool(sourcekitd_variant_bool_get_value(sourcekitObject))
            case SOURCEKITD_VARIANT_TYPE_UID:
                self = String(sourceKitUID: sourcekitd_variant_uid_get_value(sourcekitObject))
                    .map(_VariantCore.uid) ?? .none
            case SOURCEKITD_VARIANT_TYPE_NULL:
                self = .none
            default:
                fatalError("Should never happen because we've checked all SourceKitRepresentable types")
            }
        }
    }

    fileprivate final class _VariantBox {
        fileprivate var _core: _VariantCore
        
        fileprivate init(variant: _VariantCore) {
            _core = variant
        }

        var array: [SourceKitVariant]? {
            get {
                if case let .array(array) = _core {
                    return array
                } else if case let .variant(sourcekitObject, response) = _core {
                    _core = _VariantCore(sourcekitObject: sourcekitObject, response: response)
                    if case let .array(array) = self._core { return array }
                }
                return nil
            }
            set {
                if case .array = _core, let newValue = newValue {
                    _core = _VariantCore.array(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var dictionary: [String: SourceKitVariant]? {
            get {
                if case let .dictionary(dictionary) = _core {
                    return dictionary
                } else if case let .variant(sourcekitObject, response) = _core {
                    _core = _VariantCore(sourcekitObject: sourcekitObject, response: response)
                    if case let .dictionary(dictionary) = _core { return dictionary }
                }
                return nil
            }
            set {
                if case .dictionary = _core, let newValue = newValue {
                    _core = _VariantCore.dictionary(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var string: String? {
            get {
                if case let .string(string) = _core {
                    return string
                } else if case let .variant(sourcekitObject, response) = _core {
                    _core = _VariantCore(sourcekitObject: sourcekitObject, response: response)
                    if case let .string(string) = _core { return string }
                }
                return nil
            }
            set {
                if case .string = _core, let newValue = newValue {
                    _core = _VariantCore.string(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var int: Int? {
            get {
                if case let .int64(int64) = _core {
                    return Int(int64)
                } else if case let .variant(sourcekitObject, response) = _core {
                    _core = _VariantCore(sourcekitObject: sourcekitObject, response: response)
                    if case let .int64(int64) = _core { return Int(int64) }
                }
                return nil
            }
            set {
                if case .int64 = _core, let newValue = newValue {
                    _core = _VariantCore.int64(Int64(newValue))
                } else {
                    fatalError()
                }
            }
        }

        var int64: Int64? {
            get {
                if case let .int64(int64) = _core {
                    return int64
                } else if case let .variant(sourcekitObject, response) = _core {
                    _core = _VariantCore(sourcekitObject: sourcekitObject, response: response)
                    if case let .int64(int64) = _core { return int64 }
                }
                return nil
            }
            set {
                if case .int64 = _core, let newValue = newValue {
                    _core = _VariantCore.int64(newValue)
                } else {
                    fatalError()
                }
            }
        }

        var bool: Bool? {
            get {
                if case let .bool(bool) = _core {
                    return bool
                } else if case let .variant(sourcekitObject, response) = _core {
                    _core = _VariantCore(sourcekitObject: sourcekitObject, response: response)
                    if case let .bool(bool) = _core { return bool }
                }
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
        init(_ response: sourcekitd_response_t) {
            self.response = response
        }
        deinit {
            sourcekitd_response_dispose(response)
        }
    }

    private init(variant: sourcekitd_variant_t, response: _ResponseBox) {
        box = _VariantBox(variant: .variant(variant, response))
    }

}
