//
//  UIDNamespace.swift
//  SourceKitten
//
//  Created by Norio Nomura on 10/22/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation

// MARK: - UIDNamespace
public protocol UIDNamespace: CustomStringConvertible, Equatable, ExpressibleByStringLiteral {
    var uid: UID { get }
    static var __uid_prefix: String { get }
}

extension UIDNamespace {
    // CustomStringConvertible
    public var description: String {
        return uid.description
    }

    static func _inferUID(from string: String) -> UID {
        let namespace = __uid_prefix
        let fullyQualifiedName: String
        if string.hasPrefix(".") {
            fullyQualifiedName = namespace + string
        } else {
            // Check string begins with targeting namespace if DEBUG.
            #if DEBUG
            precondition(string.hasPrefix(namespace + "."), "string must begin with \"\(namespace).\".")
            #endif
            fullyQualifiedName = string
        }
        let result = UID(fullyQualifiedName)
        #if DEBUG
        precondition(result.isKnown, "\"\(fullyQualifiedName)\" is not predefined UID string!")
        #endif
        return result
    }

    // ExpressibleByStringLiteral
    // 
    // FIXME: Use following implementation when https://bugs.swift.org/browse/SR-3173 will be resolved.
    /*
    public init(stringLiteral value: String) {
        self.init(uid: UID(value))
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(uid: UID(value))
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(uid: UID(value))
    }
     */
}
