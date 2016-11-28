//
//  Structure.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-06.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation

/// Represents the structural information in a Swift source file.
public struct Structure {
    /// Structural information as an [String: SourceKitRepresentable].
    public var dictionary: NSDictionary {
        var dictionary = variant.any as! [String:Any]
        dictionary.removeValue(forKey: UID.Key.syntaxmap.description)
        return dictionary.bridge()
    }
    ///
    public let variant: SourceKitVariant

    /**
    Create a Structure from a SourceKit `editor.open` response.
     
    - parameter sourceKitResponse: SourceKit `editor.open` response.
    */
    @available(*, unavailable, message: "use Structure.init(sourceKitVariant:)")
    public init(sourceKitResponse: [String: SourceKitRepresentable]) {
        fatalError()
    }

    init(sourceKitVariant: SourceKitVariant) {
        variant = sourceKitVariant
    }

    /**
    Initialize a Structure by passing in a File.

    - parameter file: File to parse for structural information.
    - throws: Request.Error
    */
    public init(file: File) throws {
        self.init(sourceKitVariant: try Request.editorOpen(file: file).failableSend())
    }
}

// MARK: CustomStringConvertible

extension Structure: CustomStringConvertible {
    /// A textual JSON representation of `Structure`.
    public var description: String { return toJSON(dictionary) }
}

// MARK: Equatable

extension Structure: Equatable {}

/**
Returns true if `lhs` Structure is equal to `rhs` Structure.

- parameter lhs: Structure to compare to `rhs`.
- parameter rhs: Structure to compare to `lhs`.

- returns: True if `lhs` Structure is equal to `rhs` Structure.
*/
public func == (lhs: Structure, rhs: Structure) -> Bool {
    return lhs.variant == rhs.variant
}
