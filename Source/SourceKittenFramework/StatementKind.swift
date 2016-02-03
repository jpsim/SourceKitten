//
//  SwiftStatementKind.swift
//  SourceKitten
//
//  Created by Denis Lebedev on 03/02/2016.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

/// Swift declaration kinds.
/// Found in `strings SourceKitService | grep source.lang.swift.stmt.`.
public enum StatementKind: String {
    /// `brace`.
    case Brace = "source.lang.swift.stmt.brace"
    /// `case`.
    case Case = "source.lang.swift.stmt.case"
    /// `for`.
    case For = "source.lang.swift.stmt.for"
    /// `foreach`.
    case ForEach = "source.lang.swift.stmt.foreach"
    /// `guard`.
    case Guard = "source.lang.swift.stmt.guard"
    /// `if`.
    case If = "source.lang.swift.stmt.if"
    /// `repeatewhile`.
    case RepeatWhile = "source.lang.swift.stmt.repeatwhile"
    /// `switch`.
    case Switch = "source.lang.swift.stmt.switch"
    /// `while`.
    case While = "source.lang.swift.stmt.while"
}
