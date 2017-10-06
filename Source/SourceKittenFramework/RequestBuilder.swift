//
//  RequestBuilder.swift
//  sourcekitten
//
//  Created by Zheng Li on 06/10/2017.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE
import SourceKit
#endif

public class RequestBuilder {
    private var dict: [sourcekitd_uid_t: sourcekitd_object_t] = [:]

    public init(type: SourceKitDef.Request) {
        dict[transform(key: "key.request")] = sourcekitd_request_uid_create(transform(key: type.stringRepresentation))
    }

    public subscript(_ key: SourceKitDef.Key) -> Any? {
        get { return dict[transform(key: key.stringRepresentation)] }
        set { set(newValue, for: key.stringRepresentation) }
    }

    public func makeRequest() -> sourcekitd_object_t {
        var keys = Array(dict.keys.map({ $0 as sourcekitd_uid_t? }))
        var values = Array(dict.values.map({ $0 as sourcekitd_object_t? }))
        return sourcekitd_request_dictionary_create(&keys, &values, dict.count)
    }

    private func set(_ value: Any?, for key: String) {
        if let value = value {
            if let string = value as? String, key == "key.request" {
                dict[transform(key: "key.request")] = sourcekitd_request_uid_create(transform(key: string))
            } else {
                dict[transform(key: key)] = transform(any: value)
            }
        } else {
            dict[transform(key: key)] = nil
        }
    }
}

private func transform(key: String) -> sourcekitd_uid_t {
    return sourcekitd_uid_get_from_cstr(key)
}

private func transform(string: String) -> sourcekitd_object_t {
    return sourcekitd_request_string_create(string)
}

private func transform(bool: Bool) -> sourcekitd_object_t {
    return sourcekitd_request_int64_create(bool ? 1 : 0)
}

private func transform(integer: Int64) -> sourcekitd_object_t {
    return sourcekitd_request_int64_create(integer)
}

private func transform(array: [Any]) -> sourcekitd_object_t {
    var array = array.map(transform(any:)).map { $0 as sourcekitd_object_t? }
    return sourcekitd_request_array_create(&array, array.count)
}

private func transform(dictionary: [String: Any]) -> sourcekitd_object_t {
    var keys = Array(dictionary.keys).map(transform(key:)).map { $0 as sourcekitd_uid_t? }
    var values = Array(dictionary.values).map(transform(any:)).map { $0 as sourcekitd_object_t? }
    return sourcekitd_request_dictionary_create(&keys, &values, dictionary.count)
}

private func transform(any: Any) -> sourcekitd_object_t {
    switch any {
    case let string as String:
        return transform(string: string)
    case let bool as Bool:
        return transform(bool: bool)
    case let integer as Int64:
        return transform(integer: integer)
    case let array as [Any]:
        return transform(array: array)
    case let dictionary as [String: Any]:
        return transform(dictionary: dictionary)
    default:
        fatalError("RequestBuilder: Unsupported value type: \(type(of: any)) value: \(any)")
    }
}
