//
//  File.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SWXMLHash
#if SWIFT_PACKAGE
import SourceKit
#endif

/// Represents a source file.
public final class File {
    /// File path. Nil if initialized directly with `File(contents:)`.
    public let path: String?
    /// File contents.
    public var contents: String
    #if !os(Linux)
    /// File lines.
    public var lines: [Line]
    #endif

    /**
    Failable initializer by path. Fails if file contents could not be read as a UTF8 string.

    - parameter path: File path.
    */
    public init?(path: String) {
        #if os(Linux)
            self.path = path
        #else
            self.path = (path as NSString).absolutePathRepresentation()
        #endif
        do {
            contents = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            #if !os(Linux)
                lines = contents.lines()
            #endif
        } catch {
            fputs("Could not read contents of `\(path)`\n", stderr)
            return nil
        }
    }

    /**
    Initializer by file contents. File path is nil.

    - parameter contents: File contents.
    */
    public init(contents: String) {
        path = nil
        self.contents = contents
        #if !os(Linux)
            lines = contents.lines()
        #endif
    }

    /**
    Returns true if path is nil or if path has the same last path component as `key.filepath` in the
    input dictionary.

    - parameter dictionary: Dictionary to parse.
    */
    internal func shouldTreatAsSameFile(_ dictionary: [String: SourceKitRepresentable]) -> Bool {
        return path == SwiftDocKey.getFilePath(dictionary)
    }
}

/**
Returns an `[SourceKitRepresentable]` of `[String: SourceKitRepresentable]` items from `indexer` children, if any.

- parameter indexer: `XMLIndexer` to traverse.
*/
private func childrenAsArray(_ indexer: XMLIndexer) -> [SourceKitRepresentable]? {
    let children = indexer.children
    if children.count > 0 {
        return children.flatMap({ $0.element }).map {
            [$0.name: $0.text ?? ""] as [String: SourceKitRepresentable]
        } as [SourceKitRepresentable]
    }
    return nil
}
