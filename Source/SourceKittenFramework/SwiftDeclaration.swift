//
//  SwiftDeclaration.swift
//  SourceKitten
//
//  Created by Paul Young on 12/4/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import SwiftXPC

public struct SwiftDeclaration: DeclarationType {
    public let language: Language = .Swift
    public let kind: DeclarationKindType?
    public let location: SourceLocation
    public let extent: Range<SourceLocation> // FIXME: Type 'SourceLocation' does not conform to protocol 'ForwardIndexType'
    public let name: String?
    public let typeName: String?
    public let usr: String?
    public let declaration: String?
    public let documentationComment: String?
    public let children: [DeclarationType]
    public let accessibility: Accessibility?
}

extension SwiftDeclaration {
    public init(dictionary: XPCDictionary) {
        kind = SwiftDocKey.getKind(dictionary).flatMap { SwiftDeclarationKind(rawValue: $0) } // FIXME: why doesn't .flatMap(SwiftDeclarationKind.init) work here?
        location = // FIXME
        extent = // FIXME
        name = SwiftDocKey.getName(dictionary)
        typeName = SwiftDocKey.getTypeName(dictionary)
        usr = SwiftDocKey.getUSR(dictionary)
        declaration = SwiftDocKey.getParsedDeclaration(dictionary)
        documentationComment = // FIXME
        children = SwiftDocKey.getSubstructure(dictionary) // FIXME: Cannot assign value of type 'XPCArray?' to type '[DeclarationType]'
        accessibility = // FIXME: Accessibility(rawValue: ...)
    }
}

// MARK: Hashable

extension SwiftDeclaration: Hashable  {
    public var hashValue: Int {
        return usr?.hashValue ?? 0
    }
}

public func ==(lhs: SwiftDeclaration, rhs: SwiftDeclaration) -> Bool {
    return lhs.usr == rhs.usr &&
        lhs.location == rhs.location
}

// MARK: Comparable

/// A [strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order)
/// over instances of `Self`.
public func <(lhs: SwiftDeclaration, rhs: SwiftDeclaration) -> Bool {
    return lhs.location < rhs.location
}
