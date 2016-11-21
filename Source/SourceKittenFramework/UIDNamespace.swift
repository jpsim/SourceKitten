//
//  UIDNamespace.swift
//  SourceKitten
//
//  Created by Norio Nomura on 10/22/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation

// MARK: - UIDNamespace
public protocol UIDNamespace: CustomStringConvertible, ExpressibleByStringLiteral, Equatable {
    var uid: UID { get }
}

extension UIDNamespace {
    // CustomStringConvertible
    public var description: String {
        return uid.description
    }

    internal static func _inferUID(from string: String) -> UID {
        let namespace = _typeName(type(of:self))
            .components(separatedBy: ".")
            .dropFirst(2)
            .dropLast()
            .joined(separator: ".")
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
        return UID(fullyQualifiedName)
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
