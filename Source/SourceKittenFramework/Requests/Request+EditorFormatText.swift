//
//  Request+EditorFormat.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

extension Request {
    /// Format
    public struct EditorFormatText: RequestType {
        public let name: String
        public let line: Int64

        public struct Options {
            public let indentWidth: Int64
            public let tabWidth: Int64
            public let useTabs: Bool
        }
        public let options: Options

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .editorFormatText)
            requestBuilder[.name] = name
            requestBuilder[.line] = line

            let formatOptions: [String: Any] = [
                "key.editor.format.indentwidth": options.indentWidth,
                "key.editor.format.tabwidth": options.tabWidth,
                "key.editor.format.usetabs": options.useTabs
            ]
            requestBuilder[.formatOptions] = formatOptions

            return requestBuilder.makeRequest()
        }
    }

    public static func format(file: String, line: Int64, useTabs: Bool, indentWidth: Int64) -> Request {
        let options = EditorFormatText.Options(
            indentWidth: indentWidth,
            tabWidth: indentWidth,
            useTabs: useTabs
        )
        return Request(type: EditorFormatText(name: file, line: line, options: options))
    }
}
