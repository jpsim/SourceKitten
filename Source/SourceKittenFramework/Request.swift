//
//  Request.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 JP Simard. All rights reserved.
//

import Foundation
import SwiftXPC

/// dispatch_once_t token used to only initialize SourceKit once per session.
private var sourceKitInitializationToken = dispatch_once_t(0)

/// SourceKit UID to String map.
private var uidStringMap = [COpaquePointer: String]()

/**
Cache SourceKit requests for strings from UIDs

- parameter uid: UID received from sourcekitd* responses.

- returns: Cached UID string if available, nil otherwise.
*/
internal func stringForSourceKitUID(uid: COpaquePointer) -> String? {
    if let string = uidStringMap[uid] {
        return string
    } else if let uidString = String(UTF8String: sourcekitd_uid_get_string_ptr(uid)) {
        uidStringMap[uid] = uidString
        return uidString
    }
    return nil
}

/// Represents a SourceKit request.
public enum Request {
    /// An `editor.open` request for the given File.
    case EditorOpen(File)
    /// A `cursorinfo` request for an offset in the given file, using the `arguments` given.
    case CursorInfo(file: String, offset: Int64, arguments: [String])
    /// A custom request by passing in the xpc_object_t directly.
    case CustomRequest(sourcekitd_object_t)
    /// A `codecomplete` request by passing in the file name, contents, offset
    /// for which to generate code completion options and array of compiler arguments.
    case CodeCompletionRequest(file: String, contents: String, offset: Int64, arguments: [String])

    /// xpc_object_t version of the Request to be sent to SourceKit.
    private var xpcValue: sourcekitd_object_t {
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
    Create a Request.CursorInfo.xpcValue() from a file path and compiler arguments.

    - parameter filePath:  Path of the file to create request.
    - parameter arguments: Compiler arguments.

    - returns: xpc_object_t representation of the Request, if successful.
    */
    internal static func cursorInfoRequestForFilePath(filePath: String?, arguments: [String]) -> sourcekitd_object_t? {
        if let path = filePath {
            return Request.CursorInfo(file: path, offset: 0, arguments: arguments).xpcValue
        }
        return nil
    }

    /**
    Send a Request.CursorInfo by updating its offset. Returns SourceKit response if successful.

    - parameter request: xpc_object_t representation of Request.CursorInfo
    - parameter offset:  Offset to update request.

    - returns: SourceKit response if successful.
    */
    internal static func sendCursorInfoRequest(request: sourcekitd_object_t, atOffset offset: Int64) -> XPCDictionary? {
        if offset == 0 {
            return nil
        }
        sourcekitd_request_dictionary_set_int64(request, sourcekitd_uid_get_from_cstr(SwiftDocKey.Offset.rawValue), offset)
        return Request.CustomRequest(request).send()
    }

    /**
    Sends the request to SourceKit and return the response as an XPCDictionary.

    - returns: SourceKit output as an XPC dictionary.
    */
    public func send() -> XPCDictionary {
        dispatch_once(&sourceKitInitializationToken) {
            sourcekitd_initialize()
        }
        return replaceUIDsWithSourceKitStrings(fromXPC(unsafeBitCast(sourcekitd_send_request_sync(xpcValue), xpc_object_t.self)))
    }
}

// MARK: CustomStringConvertible

extension Request: CustomStringConvertible {
    /// A textual representation of `Request`.
    public var description: String { return String.fromCString(sourcekitd_request_description_copy(xpcValue))! }
}
