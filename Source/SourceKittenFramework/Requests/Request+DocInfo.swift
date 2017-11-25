//
//  Request+DocInfo.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

extension Request {
    /// A documentation request for the given source text.
    /// Or a documentation request for the given module.
    public struct DocInfo: RequestType {
        public let name: String

        public struct Source {
            public let sourceText: String?
            public let moduleName: String?

            public static func text(_ sourceText: String) -> Source {
                return Source(sourceText: sourceText, moduleName: nil)
            }

            public static func module(name moduleName: String) -> Source {
                return Source(sourceText: nil, moduleName: moduleName)
            }
        }
        public let source: Source
        public let arguments: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .docInfo)
            requestBuilder[.name] = name
            requestBuilder[.sourceText] = source.sourceText
            requestBuilder[.moduleName] = source.moduleName
            requestBuilder[.compilerArgs] = arguments

            return requestBuilder.makeRequest()
        }
    }

    public static func docInfo(text: String, arguments: [String]) -> Request {
        return Request(type: DocInfo(name: NSUUID().uuidString, source: .text(text), arguments: arguments))
    }

    public static func moduleInfo(module: String, arguments: [String]) -> Request {
        return Request(type: DocInfo(name: NSUUID().uuidString, source: .module(name: module), arguments: arguments))
    }
}
