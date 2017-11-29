//
//  Request+CodeCompletion.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

// swiftlint:disable nesting
extension Request {
    /// A `codecomplete` request by passing in the file name, contents, offset
    /// for which to generate code completion options and array of compiler arguments.
    public struct CodeComplete: RequestType {
        public struct Source {
            public let sourceFile: String?
            public let sourceText: String?

            public static func path(_ path: String) -> Source {
                return Source(sourceFile: path, sourceText: nil)
            }

            public static func text(_ text: String, name: String? = nil) -> Source {
                return Source(sourceFile: name, sourceText: text)
            }
        }
        public let source: Source
        public let offset: Int64
        public let arguments: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .codeComplete)
            requestBuilder[.sourceFile] = source.sourceFile
            requestBuilder[.sourceText] = source.sourceText
            requestBuilder[.offset] = offset
            requestBuilder[.compilerArgs] = arguments
            return requestBuilder.makeRequest()
        }
    }

    public static func codeCompletionRequest(file: String, contents: String, offset: Int64, arguments: [String]) -> Request {
        return .codeComplete(source: .text(contents, name: file), offset: offset, arguments: arguments)
    }

    public static func codeComplete(source: CodeComplete.Source, offset: Int64, arguments: [String]) -> Request {
        return Request(type: CodeComplete(source: source, offset: offset, arguments: arguments))
    }
}
