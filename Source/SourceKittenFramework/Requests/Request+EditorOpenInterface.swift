//
//  Request+EditorOpenInterface.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

// swiftlint:disable nesting
extension Request {
    /// Generate interface for a swift module.
    public struct EditorOpenInterface: RequestType {
        public let name: String
        public let moduleName: String

        public struct Group {
            public let groupName: String?
            public let interestedUSR: String?

            public static func name(_ name: String) -> Group {
                return Group(groupName: name, interestedUSR: nil)
            }

            public static func containsInterestedUSR(_ usr: String) -> Group {
                return Group(groupName: nil, interestedUSR: usr)
            }
        }
        public let group: Group?
        public let synthesizedExtension: Bool?
        public let arguments: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .editorOpenInterface)
            requestBuilder[.name] = name
            requestBuilder[.moduleName] = moduleName
            requestBuilder[.synthesizedExtension] = synthesizedExtension
            requestBuilder[.compilerArgs] = arguments
            requestBuilder[.groupName] = group?.groupName
            requestBuilder[.interestedUSR] = group?.interestedUSR
            return requestBuilder.makeRequest()
        }
    }

    public static func editorOpenInterface(
        name: String,
        moduleName: String,
        group: EditorOpenInterface.Group? = nil,
        synthesizedExtension: Bool? = nil,
        arguments: [String] = []
        ) -> Request {
        return Request(type: EditorOpenInterface(
            name: name,
            moduleName: moduleName,
            group: group,
            synthesizedExtension: synthesizedExtension,
            arguments: arguments
        ))
    }
}
