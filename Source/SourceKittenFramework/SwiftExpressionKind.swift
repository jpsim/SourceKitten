//
//  SwiftDeclarationKind.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-05.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

/// Swift expression kinds.
/// Found in `strings SourceKitService | grep source.lang.swift.expr.`.
public enum SwiftExpressionKind: String, SwiftLangSyntax {
    /// Function argument
    case argument = "source.lang.swift.expr.argument"

    /// Array expression
    case array = "source.lang.swift.expr.array"

    /// General call
    case call = "source.lang.swift.expr.call"

    /// Dictionary expression
    case dictionary = "source.lang.swift.expr.dictionary"

    /// Object literal (objective c?)
    case objectLiteral = "source.lang.swift.expr.object_literal"

}
