//
//  Request+Demangle.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

extension Request {
    /// Demangle swift names
    public struct Demangle: RequestType {
        public let names: [String]

        public func sourcekitObject() -> sourcekitd_object_t {
            let requestBuilder = RequestBuilder(type: .demangle)
            requestBuilder[.names] = names

            return requestBuilder.makeRequest()
        }
    }

    public static func demangle(names: [String]) -> Request {
        return Request(type: Demangle(names: names))
    }
}
