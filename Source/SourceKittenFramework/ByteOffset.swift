//
//  ByteOffset.swift
//  SourceKitten
//
//  Created by JP Simard on 2019-11-02.
//  Copyright (c) 2019 SourceKitten. All rights reserved.
//

/// Wrapper over a string offset to represent offset in bytes.
public struct ByteOffset: ExpressibleByIntegerLiteral {
    /// The byte value as an integer.
    var value: Int

    /// Create a byte offset by its integer value.
    ///
    /// - parameter value: Integer offset value.
    public init(integerLiteral value: Int) {
        self.value = value
    }

    /// Create a byte offset by its integer value.
    ///
    /// - parameter value: Integer offset value.
    public init(_ value: Int) {
        self.value = value
    }
}

extension ByteOffset: CustomStringConvertible {
    public var description: String {
        return value.description
    }
}

extension ByteOffset: Comparable {
    public static func < (lhs: ByteOffset, rhs: ByteOffset) -> Bool {
        return lhs.value < rhs.value
    }
}

extension ByteOffset: AdditiveArithmetic {
    public static func - (lhs: ByteOffset, rhs: ByteOffset) -> ByteOffset {
        return ByteOffset(lhs.value - rhs.value)
    }

    public static func -= (lhs: inout ByteOffset, rhs: ByteOffset) {
        lhs.value -= rhs.value
    }

    public static func + (lhs: ByteOffset, rhs: ByteOffset) -> ByteOffset {
        return ByteOffset(lhs.value + rhs.value)
    }

    public static func += (lhs: inout ByteOffset, rhs: ByteOffset) {
        lhs.value += rhs.value
    }
}
