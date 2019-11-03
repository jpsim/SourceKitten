//
//  ByteRange.swift
//  SourceKitten
//
//  Created by JP Simard on 2019-11-02.
//  Copyright (c) 2019 SourceKitten. All rights reserved.
//

/// Structure that represents a string range in bytes
public struct ByteRange: Equatable {
    /// The starting location of the range.
    public let location: ByteOffset

    /// The length of the range.
    public let length: Int

    /// Creates a byte range from a location and a length.
    ///
    /// - parameter location: The starting location of the range.
    /// - parameter length:   The length of the range.
    public init(location: ByteOffset, length: Int) {
        self.location = location
        self.length = length
    }

    /// The range's upper bound.
    var upperBound: ByteOffset {
        return location + length
    }
}
