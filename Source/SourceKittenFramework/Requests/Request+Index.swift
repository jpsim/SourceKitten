//
//  Request+Index.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

extension Request {
    /// Index
    public struct Index: RequestType {
        public let sourceFile: String
        public let arguments: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .index)
            requestBuilder[.sourceFile] = sourceFile
            requestBuilder[.compilerArgs] = arguments
            return requestBuilder.makeRequest()
        }
    }

    public static func index(file: String, arguments: [String]) -> Request {
        return Request(type: Index(sourceFile: file, arguments: arguments))
    }
}
