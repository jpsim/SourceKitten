//
//  UID.swift
//  SourceKitten
//
//  Created by Norio Nomura on 10/21/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE
    import SourceKit
#endif


/// Swift representation of sourcekitd_uid_t
public struct UID {
    let uid: sourcekitd_uid_t
    init(_ uid: sourcekitd_uid_t, _ string: String? = nil) {
        self.uid = uid
        _string = string
    }

    fileprivate let _string: String?
    var string: String {
        if let _string = _string ?? knownSourceKitUIDStringMap[uid] {
            return _string
        }
        let bytes = sourcekitd_uid_get_string_ptr(uid)
        let length = sourcekitd_uid_get_length(uid)
        return String(bytes: bytes!, length: length)!
    }
}

// MARK: - CustomStringConvertible
extension UID: CustomStringConvertible {
    public var description: String {
        return string
    }
}

// MARK: - ExpressibleByStringLiteral
extension UID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        if let knownUID = knownUIDStringUIDMap[value] {
            self.init(knownUID, value)
        } else {
            self.init(value)
            #if DEBUG
                preconditionFailure("\"\(value)\" is not predefined UID string!")
            #endif
        }
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        if let knownUID = knownUIDStringUIDMap[value] {
            self.init(knownUID, value)
        } else {
            self.init(value)
            #if DEBUG
                preconditionFailure("\"\(value)\" is not predefined UID string!")
            #endif
        }
    }

    public init(unicodeScalarLiteral value: String) {
        if let knownUID = knownUIDStringUIDMap[value] {
            self.init(knownUID, value)
        } else {
            self.init(value)
            #if DEBUG
                preconditionFailure("\"\(value)\" is not predefined UID string!")
            #endif
        }
    }

    init(_ string: String) {
        uid = sourcekitd_uid_get_from_cstr(string)
        _string = string
    }

    // Check known uid.
    var isKnown: Bool {
        return knownSourceKitUIDStringMap.index(forKey: uid) != nil
    }
}

// MARK: - Hashable
extension UID: Hashable {
    public var hashValue: Int {
        return uid.hashValue
    }

    public static func ==(lhs: UID, rhs: UID) -> Bool {
        return lhs.uid == rhs.uid
    }
}

// MARK: - SourceKitObjectConvertible
extension UID: SourceKitObjectConvertible {
    public var object: sourcekitd_object_t? {
        return sourcekitd_request_uid_create(uid)
    }
}

// MARK: - Known UID caches
fileprivate let countOfKnownUIDs = knownUIDsSets.reduce(0, { $0 + $1.count })

/// SourceKit UID to String map.
fileprivate let knownSourceKitUIDStringMap: [sourcekitd_uid_t:String] = knownUIDsSets
    .reduce(Dictionary(minimumCapacity: countOfKnownUIDs), {
        dictionary, set in
        var dictionary = dictionary
        set.forEach { dictionary[$0.uid] = $0._string }
        return dictionary
    })

/// String to SourceKit UID map.
fileprivate let knownUIDStringUIDMap: [String:sourcekitd_uid_t] = knownUIDsSets
    .reduce(Dictionary(minimumCapacity: countOfKnownUIDs), {
        dictionary, set in
        var dictionary = dictionary
        set.forEach { dictionary[$0._string!] = $0.uid }
        return dictionary
    })
