//
//  Request.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 JP Simard. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE
import sourcekitd
#endif

public protocol SourceKitRepresentable {
    func isEqualTo(rhs: SourceKitRepresentable) -> Bool
}
extension Array: SourceKitRepresentable {}
extension Dictionary: SourceKitRepresentable {}
extension String: SourceKitRepresentable {}
extension Int64: SourceKitRepresentable {}
extension Bool: SourceKitRepresentable {}

extension SourceKitRepresentable {
    public func isEqualTo(rhs: SourceKitRepresentable) -> Bool {
        switch self {
        case let lhs as [SourceKitRepresentable]:
            for (idx, value) in lhs.enumerate() {
                if let rhs = rhs as? [SourceKitRepresentable] where rhs[idx].isEqualTo(value) {
                    continue
                }
                return false
            }
            return true
        case let lhs as [String: SourceKitRepresentable]:
            for (key, value) in lhs {
                if let rhs = rhs as? [String: SourceKitRepresentable],
                    rhsValue = rhs[key] where rhsValue.isEqualTo(value) {
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

private func fromSourceKit(sourcekitObject: sourcekitd_variant_t) -> SourceKitRepresentable? {
    switch sourcekitd_variant_get_type(sourcekitObject) {
    case SOURCEKITD_VARIANT_TYPE_ARRAY:
        var array = [SourceKitRepresentable]()
        sourcekitd_variant_array_apply(sourcekitObject) { index, value in
            if let value = fromSourceKit(value) {
                array.insert(value, atIndex: Int(index))
            }
            return true
        }
        return array
    case SOURCEKITD_VARIANT_TYPE_DICTIONARY:
        var dict = [String: SourceKitRepresentable]()
        sourcekitd_variant_dictionary_apply(sourcekitObject) { key, value in
            if let key = stringForSourceKitUID(key), value = fromSourceKit(value) {
                dict[key] = value
            }
            return true
        }
        return dict
    case SOURCEKITD_VARIANT_TYPE_STRING:
        return swiftStringFrom(sourcekitd_variant_string_get_ptr(sourcekitObject),
            length: sourcekitd_variant_string_get_length(sourcekitObject))!
    case SOURCEKITD_VARIANT_TYPE_INT64:
        return sourcekitd_variant_int64_get_value(sourcekitObject)
    case SOURCEKITD_VARIANT_TYPE_BOOL:
        return sourcekitd_variant_bool_get_value(sourcekitObject)
    case SOURCEKITD_VARIANT_TYPE_UID:
        return stringForSourceKitUID(sourcekitd_variant_uid_get_value(sourcekitObject))!
    case SOURCEKITD_VARIANT_TYPE_NULL:
        return nil
    default:
        fatalError("Should never happen because we've checked all SourceKitRepresentable types")
    }
}

/// dispatch_once_t token used to only initialize SourceKit once per session.
private var sourceKitInitializationToken: dispatch_once_t = 0

/// SourceKit UID to String map.
private var uidStringMap = [sourcekitd_uid_t: String]()

/**
Cache SourceKit requests for strings from UIDs

- parameter uid: UID received from sourcekitd* responses.

- returns: Cached UID string if available, nil otherwise.
*/
internal func stringForSourceKitUID(uid: sourcekitd_uid_t) -> String? {
    if let string = uidStringMap[uid] {
        return string
    }
    let length = sourcekitd_uid_get_length(uid)
    let pointer = UnsafeMutablePointer<Int8>(sourcekitd_uid_get_string_ptr(uid))
    if let uidString = String(bytesNoCopy: pointer, length: length,
        encoding: NSUTF8StringEncoding, freeWhenDone: false) {
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
        let uidString = sourceKittenRawValueStringFrom(uidString) ?? "\(uidString)"
        uidStringMap[uid] = uidString
        return uidString
    }
    return nil
}

/**
Returns SourceKitten defined enum's rawValue String from string

- parameter uidString: String created from sourcekitd_uid_get_string_ptr().

- returns: rawValue String if defined in SourceKitten, nil otherwise.
*/
private func sourceKittenRawValueStringFrom(uidString: String) -> String? {
    return SwiftDocKey(rawValue: uidString)?.rawValue ??
        SwiftDeclarationKind(rawValue: uidString)?.rawValue ??
        SyntaxKind(rawValue: uidString)?.rawValue
}

/**
Returns Swift's native String from NSUTF8StringEncoding bytes and length

`String(UTF8String:)` creates `String` based on `NSString`.
That is slower than Swift's native String on some scene.
 
- parameter bytes: UnsafePointer<Int8>
- parameter length: length of bytes

- returns: String Swift's native String
*/
private func swiftStringFrom(bytes: UnsafePointer<Int8>, length: Int) -> String? {
    let pointer = UnsafeMutablePointer<Int8>(bytes)
    return String(bytesNoCopy: pointer, length: length, encoding: NSUTF8StringEncoding,
        freeWhenDone: false).map { "\($0)" }
}

/// Represents a SourceKit request.
public enum Request {
    /// An `editor.open` request for the given File.
    case EditorOpen(File)
    /// A `cursorinfo` request for an offset in the given file, using the `arguments` given.
    case CursorInfo(file: String, offset: Int64, arguments: [String])
    /// A custom request by passing in the sourcekitd_object_t directly.
    case CustomRequest(sourcekitd_object_t)
    /// A `codecomplete` request by passing in the file name, contents, offset
    /// for which to generate code completion options and array of compiler arguments.
    case CodeCompletionRequest(file: String, contents: String, offset: Int64, arguments: [String])

    private var sourcekitObject: sourcekitd_object_t {
        var dict: [sourcekitd_uid_t : sourcekitd_object_t]
        switch self {
        case .EditorOpen(let file):
            if let path = file.path {
                dict = [
                    sourcekitd_uid_get_from_cstr("key.request"): sourcekitd_request_uid_create(sourcekitd_uid_get_from_cstr("source.request.editor.open")),
                    sourcekitd_uid_get_from_cstr("key.name"): sourcekitd_request_string_create(path),
                    sourcekitd_uid_get_from_cstr("key.sourcefile"): sourcekitd_request_string_create(path)
                ]
            } else {
                dict = [
                    sourcekitd_uid_get_from_cstr("key.request"): sourcekitd_request_uid_create(sourcekitd_uid_get_from_cstr("source.request.editor.open")),
                    sourcekitd_uid_get_from_cstr("key.name"): sourcekitd_request_string_create(String(file.contents.hash)),
                    sourcekitd_uid_get_from_cstr("key.sourcetext"): sourcekitd_request_string_create(file.contents)
                ]
            }
        case .CursorInfo(let file, let offset, let arguments):
            var compilerargs = arguments.map({ sourcekitd_request_string_create($0) })
            dict = [
                sourcekitd_uid_get_from_cstr("key.request"): sourcekitd_request_uid_create(sourcekitd_uid_get_from_cstr("source.request.cursorinfo")),
                sourcekitd_uid_get_from_cstr("key.name"): sourcekitd_request_string_create(file),
                sourcekitd_uid_get_from_cstr("key.sourcefile"): sourcekitd_request_string_create(file),
                sourcekitd_uid_get_from_cstr("key.offset"): sourcekitd_request_int64_create(offset),
                sourcekitd_uid_get_from_cstr("key.compilerargs"): sourcekitd_request_array_create(&compilerargs, compilerargs.count)
            ]
        case .CustomRequest(let request):
            return request
        case .CodeCompletionRequest(let file, let contents, let offset, let arguments):
            var compilerargs = arguments.map({ sourcekitd_request_string_create($0) })
            dict = [
                sourcekitd_uid_get_from_cstr("key.request"): sourcekitd_request_uid_create(sourcekitd_uid_get_from_cstr("source.request.codecomplete")),
                sourcekitd_uid_get_from_cstr("key.name"): sourcekitd_request_string_create(file),
                sourcekitd_uid_get_from_cstr("key.sourcefile"): sourcekitd_request_string_create(file),
                sourcekitd_uid_get_from_cstr("key.sourcetext"): sourcekitd_request_string_create(contents),
                sourcekitd_uid_get_from_cstr("key.offset"): sourcekitd_request_int64_create(offset),
                sourcekitd_uid_get_from_cstr("key.compilerargs"): sourcekitd_request_array_create(&compilerargs, compilerargs.count)
            ]
        }
        var keys = Array(dict.keys)
        var values = Array(dict.values)
        return sourcekitd_request_dictionary_create(&keys, &values, dict.count)
    }

    /**
    Create a Request.CursorInfo.sourcekitObject() from a file path and compiler arguments.

    - parameter filePath:  Path of the file to create request.
    - parameter arguments: Compiler arguments.

    - returns: sourcekitd_object_t representation of the Request, if successful.
    */
    internal static func cursorInfoRequestForFilePath(filePath: String?, arguments: [String]) -> sourcekitd_object_t? {
        if let path = filePath {
            return Request.CursorInfo(file: path, offset: 0, arguments: arguments).sourcekitObject
        }
        return nil
    }

    /**
    Send a Request.CursorInfo by updating its offset. Returns SourceKit response if successful.

    - parameter request: sourcekitd_object_t representation of Request.CursorInfo
    - parameter offset:  Offset to update request.

    - returns: SourceKit response if successful.
    */
    internal static func sendCursorInfoRequest(request: sourcekitd_object_t, atOffset offset: Int64) -> [String: SourceKitRepresentable]? {
        if offset == 0 {
            return nil
        }
        sourcekitd_request_dictionary_set_int64(request, sourcekitd_uid_get_from_cstr(SwiftDocKey.Offset.rawValue), offset)
        return Request.CustomRequest(request).send()
    }

    /**
    Sends the request to SourceKit and return the response as an [String: SourceKitRepresentable].

    - returns: SourceKit output as a dictionary.
    */
    public func send() -> [String: SourceKitRepresentable] {
        dispatch_once(&sourceKitInitializationToken) {
            sourcekitd_initialize()
        }
        let response = sourcekitd_send_request_sync(sourcekitObject)
        defer { sourcekitd_response_dispose(response) }
        return fromSourceKit(sourcekitd_response_get_value(response)) as! [String: SourceKitRepresentable]
    }
}

// MARK: CustomStringConvertible

extension Request: CustomStringConvertible {
    /// A textual representation of `Request`.
    public var description: String { return String(UTF8String: sourcekitd_request_description_copy(sourcekitObject))! }
}
