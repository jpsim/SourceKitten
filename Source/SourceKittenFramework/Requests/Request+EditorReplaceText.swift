//
//  Request+EditorReplaceText.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

extension Request {
    /// ReplaceText
    public struct EditorReplaceText: RequestType {
        public let name: String
        public let offset: Int64
        public let length: Int64
        public let sourceText: String

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .editorReplaceText)
            requestBuilder[.name] = name
            requestBuilder[.offset] = offset
            requestBuilder[.length] = length
            requestBuilder[.sourceText] = sourceText

            return requestBuilder.makeRequest()
        }
    }

    public static func replaceText(file: String, offset: Int64, length: Int64, sourceText: String) -> Request {
        return Request(type: EditorReplaceText(name: file, offset: offset, length: length, sourceText: sourceText))
    }
}
