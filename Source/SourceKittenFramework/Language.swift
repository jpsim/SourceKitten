//
//  Language.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

/// Language Enum.
public enum Language: CustomStringConvertible {
    /// Swift.
    case swift
    /// Objective-C.
    case objc

    /// User-facing name of the language
    public var description: String {
        switch self {
        case .swift: return "Swift"
        case .objc: return "Objective-C"
        }
    }
}
