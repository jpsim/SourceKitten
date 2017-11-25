//
//  Request+EditorOpen.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

// swiftlint:disable nesting
extension Request {

    /// An `editor.open` request for the given File.
    public struct EditorOpen: RequestType {
        public let name: String

        public struct Source {
            public let sourceFile: String?
            public let sourceText: String?

            public static func path(_ path: String) -> Source {
                return Source(sourceFile: path, sourceText: nil)
            }

            public static func text(_ text: String) -> Source {
                return Source(sourceFile: nil, sourceText: text)
            }
        }
        public let source: Source
        public let enableSyntaxMap: Bool?
        public let enableStructure: Bool?
        public let enableDiagnostics: Bool?
        public let syntacticOnly: Bool?
        public let arguments: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .editorOpen)
            requestBuilder[.name] = name
            requestBuilder[.sourceFile] = source.sourceFile
            requestBuilder[.sourceText] = source.sourceText
            requestBuilder[.enableSyntaxMap] = enableSyntaxMap
            requestBuilder[.enableStructure] = enableStructure
            requestBuilder[.enableDiagnostics] = enableDiagnostics
            requestBuilder[.syntacticOnly] = syntacticOnly
            requestBuilder[.compilerArgs] = arguments
            return requestBuilder.makeRequest()
        }
    }

    public static func editorOpen(file: File, arguments: [String] = []) -> Request {
        let name: String
        let source: EditorOpen.Source
        if let path = file.path {
            name = path
            source = .path(path)
        } else {
            name = String(file.contents.hash)
            source = .text(file.contents)
        }

        return .editorOpen(name: name, source: source, arguments: arguments)
    }

    public static func editorOpen(
        name: String,
        source: EditorOpen.Source,
        enableSyntaxMap: Bool? = nil,
        enableStructure: Bool? = nil,
        enableDiagnostics: Bool? = nil,
        syntacticOnly: Bool? = nil,
        arguments: [String] = []
        ) -> Request {
        return Request(type: EditorOpen(
            name: name,
            source: source,
            enableSyntaxMap: enableSyntaxMap,
            enableStructure: enableStructure,
            enableDiagnostics: enableDiagnostics,
            syntacticOnly: syntacticOnly,
            arguments: arguments
        ))
    }
}
