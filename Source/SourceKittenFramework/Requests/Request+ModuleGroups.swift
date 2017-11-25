//
//  Request+ModuleGroups.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

extension Request {
    /// Request groups for module
    public struct ModuleGroups: RequestType {
        public let moduleName: String
        public let arguments: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .moduleGroups)
            requestBuilder[.moduleName] = moduleName
            requestBuilder[.compilerArgs] = arguments

            return requestBuilder.makeRequest()
        }
    }

    public static func moduleGroups(module: String, arguments: [String]) -> Request {
        return Request(type: ModuleGroups(moduleName: module, arguments: arguments))
    }
}
