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
    case invalidArgument(description: String)

    /// Failed to read a file at the given path.
    case readFailed(path: String)

    /// Failed to generate documentation.
    case docFailed

    /// failed with Error
    case failed(Swift.Error)

    /// An error message corresponding to this error.
    var description: String {
        switch self {
        case let .invalidArgument(description):
            return description
        case let .readFailed(path):
            return "Failed to read file at '\(path)'"
        case .docFailed:
            return "Failed to generate documentation"
        case let .failed(error):
            return error.localizedDescription
        }
    }
}
