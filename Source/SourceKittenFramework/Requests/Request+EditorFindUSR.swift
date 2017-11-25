//
//  Request+EditorFindUSR.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

extension Request {
    /// Find USR
    public struct EditorFindUSR: RequestType {
        public let sourceFile: String
        public let usr: String

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .editorFindUSR)
            requestBuilder[.sourceFile] = sourceFile
            requestBuilder[.uSR] = usr
            return requestBuilder.makeRequest()
        }
    }

    public static func findUSR(file: String, usr: String) -> Request {
        return Request(type: EditorFindUSR(sourceFile: file, usr: usr))
    }
}
