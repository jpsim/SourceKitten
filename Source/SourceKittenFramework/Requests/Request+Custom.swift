//
//  Request+Custom.swift
//  SourceKittenFramework
//
//  Created by Zheng Li on 25/11/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

extension Request {
    /// A custom request by passing in the sourcekitd_object_t directly.
    public struct Custom: RequestType {
        public let request: sourcekitd_object_t

        public func sourcekitObject() -> sourcekitd_object_t {
            return request
        }
    }

    public static func customRequest(request: sourcekitd_object_t) -> Request {
        return Request(type: Custom(request: request))
    }
}
