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

// MARK: - Check known uid.
#if DEBUG
    extension UID {
        fileprivate var isKnown: Bool {
            return knownUIDs.contains(self)
        }
    }
#endif

// MARK: - Hashable
extension UID: Hashable {
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return uid.hashValue
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: UID, rhs: UID) -> Bool {
        return lhs.uid == rhs.uid
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
}

// MARK: - CustomStringConvertible
extension UID: CustomStringConvertible {
    public var description: String {
        return string
    }
}

// MARK: - CustomLeafReflectable
extension UID: CustomLeafReflectable {
    public var customMirror: Mirror {
        return Mirror(self, children: [])
    }
}
