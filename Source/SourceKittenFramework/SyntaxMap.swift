//
//  SyntaxMap.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation

/// Represents a Swift file's syntax information.
public struct SyntaxMap {
    /// Array of SyntaxToken's.
    public let tokens: [SyntaxToken]

    /**
    Create a SyntaxMap by passing in tokens directly.

    - parameter tokens: Array of SyntaxToken's.
    */
    public init(tokens: [SyntaxToken]) {
        self.tokens = tokens
    }

    /**
    Create a SyntaxMap by passing in NSData from a SourceKit `editor.open` response to be parsed.

    - parameter data: NSData from a SourceKit `editor.open` response
    */
    public init(data: [SourceKitRepresentable]) {
        tokens = data.map { item in
            let dict = item as! [String: SourceKitRepresentable]
            return SyntaxToken(type: dict["key.kind"] as! String, offset: Int(dict["key.offset"] as! Int64), length: Int(dict["key.length"] as! Int64))
        }
    }

    /**
    Create a SyntaxMap from a SourceKit `editor.open` response.

    - parameter sourceKitResponse: SourceKit `editor.open` response.
    */
    public init(sourceKitResponse: [String: SourceKitRepresentable]) {
        self.init(data: SwiftDocKey.getSyntaxMap(sourceKitResponse)!)
    }

    /**
    Create a SyntaxMap from a File to be parsed.

    - parameter file: File to be parsed.
    */
    public init(file: File) {
        self.init(sourceKitResponse: Request.EditorOpen(file).send())
    }

    /**
    Returns the range of the last contiguous doc comment block from the tokens in `self` prior to
    `offset`. If finds identifier earlier than doc comment, stops searching and returns nil,
    because doc comment belong to identifier.

    - parameter offset: Last possible byte offset of the range's start.
    */
    public func commentRangeBeforeOffset(offset: Int, string: NSString? = nil, isExtension: Bool = false) -> Range<Int>? {
        let tokensBeforeOffset = tokens.reverse().filter { $0.offset < offset }

        let docTypes = SyntaxKind.docComments().map({ $0.rawValue })
        let isDoc = { (token: SyntaxToken) in docTypes.contains(token.type) }
        let isNotDoc = { !isDoc($0) }
        let isIdentifier = { (token: SyntaxToken) in
            return token.type == SyntaxKind.Identifier.rawValue &&
                // ignore identifiers starting with '@' because they may be placed between
                // declarations and their documentation.
                string?.rangeOfString("@", options: [], range: NSRange(location: token.offset, length: 1)) == nil
        }
        let isDocOrIdentifier = { isDoc($0) || isIdentifier($0) }

        // if finds identifier earlier than comment, stops searching and returns nil.
        guard let commentBegin = tokensBeforeOffset.indexOf(isDocOrIdentifier)
            where !isIdentifier(tokensBeforeOffset[commentBegin]) else { return nil }
        let tokensBeginningComment = tokensBeforeOffset.suffixFrom(commentBegin)

        // For avoiding declaring `var` with type annotation before `if let`, use `map()`
        let commentEnd = tokensBeginningComment.indexOf(isNotDoc)
        let commentTokensImmediatelyPrecedingOffset = (
            commentEnd.map(tokensBeginningComment.prefixUpTo) ?? tokensBeginningComment
        ).reverse()

        if isExtension {
            // Return nil if tokens between found documentation comment and offset are of types other
            // than builtin or keyword, since it means it's the documentation for some other declaration.
            let tokensBetweenCommentAndOffset = tokensBeforeOffset.filter {
                $0.offset > commentTokensImmediatelyPrecedingOffset.last?.offset
            }
            if !tokensBetweenCommentAndOffset.filter({ ![.AttributeBuiltin, .Keyword].contains(SyntaxKind(rawValue: $0.type)!) }).isEmpty,
                let lastCommentTokenOffset = commentTokensImmediatelyPrecedingOffset.last?.offset,
                lastCommentLine = string?.lineAndCharacterForByteOffset(lastCommentTokenOffset)?.line,
                offsetLine = string?.lineAndCharacterForByteOffset(offset)?.line
                where offsetLine - lastCommentLine > 2 {
                        return nil
            }
        }

        return commentTokensImmediatelyPrecedingOffset.first.flatMap { firstToken in
            return commentTokensImmediatelyPrecedingOffset.last.map { lastToken in
                return firstToken.offset...lastToken.offset + lastToken.length
            }
        }
    }
}

// MARK: CustomStringConvertible

extension SyntaxMap: CustomStringConvertible {
    /// A textual JSON representation of `SyntaxMap`.
    public var description: String {
        return toJSON(tokens.map { $0.dictionaryValue })
    }
}

// MARK: Equatable

extension SyntaxMap: Equatable {}

/**
Returns true if `lhs` SyntaxMap is equal to `rhs` SyntaxMap.

- parameter lhs: SyntaxMap to compare to `rhs`.
- parameter rhs: SyntaxMap to compare to `lhs`.

- returns: True if `lhs` SyntaxMap is equal to `rhs` SyntaxMap.
*/
public func ==(lhs: SyntaxMap, rhs: SyntaxMap) -> Bool {
    if lhs.tokens.count != rhs.tokens.count {
        return false
    }
    for (index, value) in lhs.tokens.enumerate() {
        if rhs.tokens[index] != value {
            return false
        }
    }
    return true
}
