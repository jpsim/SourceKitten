//
//  Request+EditorOpenHeaderInterface.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

extension Request {
    /// ObjC Swift Interface
    public struct EditorOpenHeaderInterface: RequestType {
        public let name: String
        public let filePath: String
        public let arguments: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .editorOpenHeaderInterface)
            requestBuilder[.name] = name
            requestBuilder[.filePath] = filePath
            requestBuilder[.compilerArgs] = arguments
            return requestBuilder.makeRequest()
        }
    }

    public static func interface(file: String, uuid: String, arguments: [String]) -> Request {
        var arguments = arguments
        if !arguments.contains("-x") {
            arguments.append(contentsOf: ["-x", "objective-c"])
        }
        if !arguments.contains("-isysroot") {
            arguments.append(contentsOf: ["-isysroot", sdkPath()])
        }

        arguments = [file] + arguments

        return Request(type: EditorOpenHeaderInterface(name: uuid, filePath: file, arguments: arguments))
    }
}
