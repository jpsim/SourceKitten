//
//  Errors.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-15.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

/// Possible errors within SourceKitten.
enum SourceKittenError: Error, CustomStringConvertible {
    /// One or more argument was invalid.
    case InvalidArgument(description: String)

    /// Failed to read a file at the given path.
    case ReadFailed(path: String)

    /// Failed to generate documentation.
    case DocFailed

    /// An error message corresponding to this error.
    var description: String {
        switch self {
        case let .InvalidArgument(description):
            return description
        case let .ReadFailed(path):
            return "Failed to read file at '\(path)'"
        case .DocFailed:
            return "Failed to generate documentation"
        }
    }
}
