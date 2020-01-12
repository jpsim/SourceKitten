//
//  ByteRange.swift
//  SourceKittenFramework
//
//  Created by Paul Taykalo on 11.01.2020.
//  Copyright © 2020 SourceKitten. All rights reserved.
//

import Foundation

/// Structure that represents a string range in bytes.
public struct ByteRange: Equatable {
    /// The starting location of the range.
    public let location: ByteCount

    /// The length of the range.
    public let length: ByteCount

    /// Creates a byte range from a location and a length.
    ///
    /// - parameter location: The starting location of the range.
    /// - parameter length:   The length of the range.
    public init(location: ByteCount, length: ByteCount) {
        self.location = location
        self.length = length
    }

    /// The range's upper bound.
    var upperBound: ByteCount {
        return location + length
    }

    /// The range's lower bound.
    var lowerBound: ByteCount {
        return location
    }
}
