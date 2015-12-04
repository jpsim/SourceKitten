//
//  DeclarationType.swift
//  SourceKitten
//
//  Created by Paul Young on 12/4/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

public protocol DeclarationType {
    var language: Language { get }
    var kind: DeclarationKindType? { get }
    var location: SourceLocation { get }
    var extent: Range<SourceLocation> { get } // FIXME: Type 'SourceLocation' does not conform to protocol 'ForwardIndexType'
    var name: String? { get }
    var typeName: String? { get }
    var usr: String? { get }
    var declaration: String? { get }
    var documentationComment: String? { get }
    var children: [DeclarationType] { get }
}
