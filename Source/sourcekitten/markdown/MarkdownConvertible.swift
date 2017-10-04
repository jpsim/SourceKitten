//
//  MarkdownConvertible.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/2/17.
//

import Foundation

protocol MarkdownConvertible {
    var output: String { get }
}

extension String: MarkdownConvertible {
    var output: String {
        return self
    }
}

extension Array: MarkdownConvertible {
    var output: String {
        return self.flatMap { ($0 as? MarkdownConvertible)?.output }.joined(separator: "\n\n")
    }
}
