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
    init(_ uid: sourcekitd_uid_t) { self.uid = uid }

    var string: String {
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
        self.init(value)
        #if DEBUG
            precondition(isKnown, "\"\(description)\" is not predefined UID string!")
        #endif
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
        #if DEBUG
            precondition(isKnown, "\"\(description)\" is not predefined UID string!")
        #endif
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)
        #if DEBUG
            precondition(isKnown, "\"\(description)\" is not predefined UID string!")
        #endif
    }

    init(_ string: String) {
        uid = sourcekitd_uid_get_from_cstr(string)
    }

    // Check known uid.
    #if DEBUG
    var isKnown: Bool {
        return knownUIDs.contains(self)
    }
    #endif
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
