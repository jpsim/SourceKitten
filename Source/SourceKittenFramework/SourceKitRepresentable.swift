//
//  SourceKitRepresentable.swift
//  SourceKittenFramework
//
//  Created by JP Simard on 7/24/17.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE
import SourceKit
#endif

public protocol SourceKitRepresentable {
    func isEqualTo(_ rhs: SourceKitRepresentable) -> Bool
}
extension Array: SourceKitRepresentable {}
extension Dictionary: SourceKitRepresentable {}
extension String: SourceKitRepresentable {}
extension Int64: SourceKitRepresentable {}
extension Bool: SourceKitRepresentable {}

extension SourceKitRepresentable {
    public func isEqualTo(_ rhs: SourceKitRepresentable) -> Bool {
        switch self {
        case let lhs as [SourceKitRepresentable]:
            for (idx, value) in lhs.enumerated() {
                if let rhs = rhs as? [SourceKitRepresentable], rhs[idx].isEqualTo(value) {
                    continue
                }
                return false
            }
            return true
        case let lhs as [String: SourceKitRepresentable]:
            for (key, value) in lhs {
                if let rhs = rhs as? [String: SourceKitRepresentable],
                    let rhsValue = rhs[key], rhsValue.isEqualTo(value) {
                    continue
                }
                return false
            }
            return true
        case let lhs as String:
            return lhs == rhs as? String
        case let lhs as Int64:
            return lhs == rhs as? Int64
        case let lhs as Bool:
            return lhs == rhs as? Bool
        default:
            fatalError("Should never happen because we've checked all SourceKitRepresentable types")
        }
    }
}

public func fromSourceKit(_ sourcekitObject: sourcekitd_variant_t) -> SourceKitRepresentable? {
    switch sourcekitd_variant_get_type(sourcekitObject) {
    case SOURCEKITD_VARIANT_TYPE_ARRAY:
        var array = [SourceKitRepresentable]()
        _ = withUnsafeMutablePointer(to: &array) { arrayPtr in
            sourcekitd_variant_array_apply_f(sourcekitObject, { index, value, context in
                if let value = fromSourceKit(value), let context = context {
                    let localArray = context.assumingMemoryBound(to: [SourceKitRepresentable].self)
                    localArray.pointee.insert(value, at: Int(index))
                }
                return true
            }, arrayPtr)
        }
        return array
    case SOURCEKITD_VARIANT_TYPE_DICTIONARY:
        var dict = [String: SourceKitRepresentable]()
        _ = withUnsafeMutablePointer(to: &dict) { dictPtr in
            sourcekitd_variant_dictionary_apply_f(sourcekitObject, { key, value, context in
                if let key = String(sourceKitUID: key!), let value = fromSourceKit(value), let context = context {
                    let localDict = context.assumingMemoryBound(to: [String: SourceKitRepresentable].self)
                    localDict.pointee[key] = value
                }
                return true
            }, dictPtr)
        }
        return dict
    case SOURCEKITD_VARIANT_TYPE_STRING:
        return String(bytes: sourcekitd_variant_string_get_ptr(sourcekitObject),
                      length: sourcekitd_variant_string_get_length(sourcekitObject))
    case SOURCEKITD_VARIANT_TYPE_INT64:
        return sourcekitd_variant_int64_get_value(sourcekitObject)
    case SOURCEKITD_VARIANT_TYPE_BOOL:
        return sourcekitd_variant_bool_get_value(sourcekitObject)
    case SOURCEKITD_VARIANT_TYPE_UID:
        return String(sourceKitUID: sourcekitd_variant_uid_get_value(sourcekitObject))
    case SOURCEKITD_VARIANT_TYPE_NULL:
        return nil
    default:
        fatalError("Should never happen because we've checked all SourceKitRepresentable types")
    }
}

public func toSourceKit(_ object: SourceKitRepresentable) -> sourcekitd_object_t? {
    switch object {
    case let object as [SourceKitRepresentable]:
        return object.map(toSourceKit).withUnsafeBufferPointer { buffer in
            return sourcekitd_request_array_create(buffer.baseAddress, buffer.count)
        }
    case let object as [String: SourceKitRepresentable]:
        var dictKeys: [sourcekitd_uid_t?] = Array(object.keys).map {
            sourcekitd_uid_get_from_cstr($0) as sourcekitd_uid_t?
        }
        var dictValues = Array(object.values.map(toSourceKit))
        return sourcekitd_request_dictionary_create(&dictKeys, &dictValues, dictKeys.count)
    case let object as String:
        if object.range(of: "source.")?.lowerBound == object.startIndex {
            return sourcekitd_request_uid_create(sourcekitd_uid_get_from_cstr(object))
        }
        return sourcekitd_request_string_create(object)
    case let object as Bool:
        return sourcekitd_request_int64_create(object ? 1 : 0)
    case let object as Int64:
        return sourcekitd_request_int64_create(object)
    default:
        fatalError("toSourceKit hasn't added \(type(of: object)) support yet")
    }
}

internal extension String {
    /**
     Cache SourceKit requests for strings from UIDs

     - returns: Cached UID string if available, nil otherwise.
     */
    init?(sourceKitUID: sourcekitd_uid_t) {
        let length = sourcekitd_uid_get_length(sourceKitUID)
        let bytes = sourcekitd_uid_get_string_ptr(sourceKitUID)
        if let uidString = String(bytes: bytes!, length: length) {
            /*
             `String` created by `String(UTF8String:)` is based on `NSString`.
             `NSString` base `String` has performance penalty on getting `hashValue`.
             Everytime on getting `hashValue`, it calls `decomposedStringWithCanonicalMapping` for
             "Unicode Normalization Form D" and creates autoreleased `CFString (mutable)` and
             `CFString (store)`. Those `CFString` are created every time on using `hashValue`, such as
             using `String` for Dictionary's key or adding to Set.

             For avoiding those penalty, replaces with enum's rawValue String if defined in SourceKitten.
             That does not cause calling `decomposedStringWithCanonicalMapping`.
             */

            self = String(uidString: uidString)
            return
        }
        return nil
    }

    /**
     Assigns SourceKitten defined enum's rawValue String from string.
     rawValue String if defined in SourceKitten, nil otherwise.

     - parameter uidString: String created from sourcekitd_uid_get_string_ptr().
     */
    init(uidString: String) {
        if let rawValue = SwiftDocKey(rawValue: uidString)?.rawValue {
            self = rawValue
        } else if let rawValue = SwiftDeclarationKind(rawValue: uidString)?.rawValue {
            self = rawValue
        } else if let rawValue = SyntaxKind(rawValue: uidString)?.rawValue {
            self = rawValue
        } else {
            self = "\(uidString)"
        }
    }

    /**
     Returns Swift's native String from NSUTF8StringEncoding bytes and length

     `String(bytesNoCopy:length:encoding:)` creates `String` based on `NSString`.
     That is slower than Swift's native String on some scene.

     - parameter bytes: UnsafePointer<Int8>
     - parameter length: length of bytes

     - returns: String Swift's native String
     */
    init?(bytes: UnsafePointer<Int8>, length: Int) {
        let pointer = UnsafeMutablePointer<Int8>(mutating: bytes)
        // It seems SourceKitService returns string in other than NSUTF8StringEncoding.
        // We'll try another encodings if fail.
        for encoding in [String.Encoding.utf8, .nextstep, .ascii] {
            if let string = String(bytesNoCopy: pointer, length: length, encoding: encoding,
                                   freeWhenDone: false) {
                self = "\(string)"
                return
            }
        }
        return nil
    }
}
