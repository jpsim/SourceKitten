//
//  Request+CursorInfo.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

// swiftlint:disable nesting
extension Request {
    /// A `cursorinfo` request for an offset or an usr in the given file, using the `arguments` given.
    public struct CursorInfo: RequestType {
        public let name: String
        public let sourceFile: String

        public struct Location {
            public let usr: String?
            public let offset: Int64?
            public let length: Int64?
            public let retrieveRefactorActions: Bool?

            public static func offset(_ offset: Int64, length: Int64? = nil, retrieveRefactorActions: Bool? = nil) -> Location {
                return Location(usr: nil, offset: offset, length: length, retrieveRefactorActions: retrieveRefactorActions)
            }

            public static func usr(_ usr: String) -> Location {
                return Location(usr: usr, offset: nil, length: nil, retrieveRefactorActions: nil)
            }
        }
        public let location: Location
        public let cancelOnSubsequentRequest: Bool?
        public let arguments: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .cursorInfo)
            requestBuilder[.name] = name
            requestBuilder[.sourceFile] = sourceFile
            requestBuilder[.cancelOnSubsequentRequest] = cancelOnSubsequentRequest
            requestBuilder[.usr] = location.usr
            requestBuilder[.offset] = location.offset
            requestBuilder[.length] = location.length
            requestBuilder[.retrieveRefactorActions] = location.retrieveRefactorActions
            requestBuilder[.compilerArgs] = arguments
            return requestBuilder.makeRequest()
        }
    }

    public static func cursorInfo(file: String, offset: Int64, arguments: [String]) -> Request {
        return .cursorInfo(name: file, file: file, location: .offset(offset), arguments: arguments)
    }

    public static func cursorInfo(
        name: String,
        file: String,
        location: CursorInfo.Location,
        cancelOnSubsequentRequest: Bool? = nil,
        arguments: [String]
        ) -> Request {
        return Request(type: CursorInfo(
            name: name,
            sourceFile: file,
            location: location,
            cancelOnSubsequentRequest: cancelOnSubsequentRequest,
            arguments: arguments
        ))
    }
}

// MARK: - CursorInfo reuse

extension Request {

    /**
     Create a Request.CursorInfo.sourcekitObject() from a file path and compiler arguments.

     - parameter filePath:  Path of the file to create request.
     - parameter arguments: Compiler arguments.

     - returns: sourcekitd_object_t representation of the Request, if successful.
     */
    internal static func cursorInfoRequest(filePath: String?, arguments: [String]) -> sourcekitd_object_t? {
        if let path = filePath {
            return Request.cursorInfo(file: path, offset: 0, arguments: arguments).type.sourcekitObject()
        }
        return nil
    }

    /**
     Send a Request.CursorInfo by updating its offset. Returns SourceKit response if successful.

     - parameter cursorInfoRequest: sourcekitd_object_t representation of Request.CursorInfo
     - parameter offset:            Offset to update request.

     - returns: SourceKit response if successful.
     */
    internal static func send(cursorInfoRequest: sourcekitd_object_t, atOffset offset: Int64) -> [String: SourceKitRepresentable]? {
        if offset == 0 {
            return nil
        }
        sourcekitd_request_dictionary_set_int64(cursorInfoRequest, sourcekitd_uid_get_from_cstr(SwiftDocKey.offset.rawValue)!, offset)
        return try? Request.customRequest(request: cursorInfoRequest).failableSend()
    }
}
