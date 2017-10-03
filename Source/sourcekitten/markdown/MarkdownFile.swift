//
//  MarkdownFile.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/2/17.
//

import Foundation

struct MarkdownFile {
    let filename: String
    let content: [MarkdownConvertible]

    func write() {
        let output = content.map { $0.output }.joined(separator: "\n")
        try? output.write(toFile: "docs/\(filename).md", atomically: true, encoding: .utf8)
    }

}
