//
//  MarkdownIndex.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/4/17.
//  Copyright © 2017 SourceKitten. All rights reserved.
//

import Foundation

class MarkdownIndex {
    static let shared = MarkdownIndex()

    var structs: [MarkdownObject] = []
    var classes: [MarkdownObject] = []
    var extensions: [MarkdownExtension] = []
    var enums: [MarkdownEnum] = []
    var protocols: [MarkdownProtocol] = []
    var typealiases: [MarkdownTypealias] = []

    func write(to docsPath: String) throws {
        extensions = flattenedExtensions()

        print("Generating Markdown documentation...")
        var content: [MarkdownConvertible] = [
            """
            # Inline Reference Documentation
            This Inline Reference Documentation has been generated with [SourceKitten](https://github.com/jpsim/SourceKitten).
            Run `sourcekitten mdocs` in the repository root to update this documentation.
            """
        ]

        try content.append(writeAndIndexFiles(items: structs, to: docsPath, collectionTitle: "Structs"))
        try content.append(writeAndIndexFiles(items: classes, to: docsPath, collectionTitle: "Classes"))
        try content.append(writeAndIndexFiles(items: extensions, to: docsPath, collectionTitle: "Extensions"))
        try content.append(writeAndIndexFiles(items: enums, to: docsPath, collectionTitle: "Enums"))
        try content.append(writeAndIndexFiles(items: protocols, to: docsPath, collectionTitle: "Protocols"))
        try content.append(writeAndIndexFiles(items: typealiases, to: docsPath, collectionTitle: "Typealiases"))

        try MarkdownFile(filename: "README", basePath: docsPath, content: content).write()
        print("Done 🎉")
    }

    private func writeAndIndexFiles(items: [MarkdownConvertible & SwiftDocDictionaryInitializable],
                                    to docsPath: String, collectionTitle: String) throws -> [MarkdownConvertible] {
        if items.isEmpty {
            return []
        }

        // Make and write files
        let files = makeFiles(with: items, basePath: "\(docsPath)/\(collectionTitle.lowercased())")
        try files.forEach { try $0.write() }

        // Make links for index
        let links = files.map { MarkdownLink(title: $0.filename, url: "/\($0.filePath)") }
        return [
            "## \(collectionTitle)",
            MarkdownList(items: links.sorted { $0.title < $1.title })
        ]
    }

    private func makeFiles(with items: [MarkdownConvertible & SwiftDocDictionaryInitializable], basePath: String) -> [MarkdownFile] {
        return items.map { MarkdownFile(filename: $0.name, basePath: basePath, content: [$0]) }
    }

    /// While other types can only have one declaration within a Swift module, there can be multiple extensions for the same type.
    private func flattenedExtensions() -> [MarkdownExtension] {
        let extensionsByType = zip(extensions.map { $0.name }, extensions)
        let groupedByType = Dictionary(extensionsByType) { (existing, new) -> MarkdownExtension in
            var merged = existing
            merged.methods += new.methods
            merged.properties += new.properties
            return merged
        }
        return Array(groupedByType.values)
    }
}
