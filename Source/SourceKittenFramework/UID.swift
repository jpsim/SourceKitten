//
//  UID.swift
//  SourceKitten
//
//  Created by Norio Nomura on 2/07/18.
//  Copyright © 2018 SourceKitten. All rights reserved.
//

#if SWIFT_PACKAGE
import SourceKit
#endif

/// Swift representation of sourcekitd_uid_t
@dynamicMemberLookup
public struct UID {
    enum Box {
        case string(String)
        case uid(sourcekitd_uid_t)
    }

    let box: Box

    init(_ uid: sourcekitd_uid_t) {
        box = .uid(uid)
    }

    public init(_ string: String) {
        box = .string(string)
    }

    public init<T>(_ rawRepresentable: T) where T: RawRepresentable, T.RawValue == String {
        self.init(rawRepresentable.rawValue)
    }

    var string: String {
        switch box {
        case .string(let string):
            return string
        case .uid(let uid):
            return String(cString: sourcekitd_uid_get_string_ptr(uid)!)
        }
    }

    public subscript(dynamicMember member: StaticString) -> UID {
        return .init("\(string).\(member)")
    }

    var uid: sourcekitd_uid_t {
        switch box {
        case .string(let string):
            return sourcekitd_uid_get_from_cstr(string)!
        case .uid(let uid):
            return uid
        }
    }
}

extension UID: CustomStringConvertible {
    public var description: String {
        return string
    }
}

extension UID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension UID: Hashable {
    public var hashValue: Int {
        return uid.hashValue
    }

    public static func == (lhs: UID, rhs: UID) -> Bool {
        return lhs.uid == rhs.uid
    }
}

extension UID: SourceKitObjectConvertible {
    public var sourcekitdObject: sourcekitd_object_t? {
        return sourcekitd_request_uid_create(uid)
    }
}

extension UID {
    public static let key = UID("key")
    public static let source = UID("source")
}

public let key = UID.key
public let source = UID.source
