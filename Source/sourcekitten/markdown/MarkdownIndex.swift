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
        let basePath = "\(FileManager.default.currentDirectoryPath)/\(docsPath)"
        print("Writting Markdown documentation files at: \(basePath)")
        try writeFiles(content: structs, at: "\(basePath)/structs")
        try writeFiles(content: classes, at: "\(basePath)/classes")
        try writeFiles(content: flattenedExtensions(), at: "\(basePath)/extensions")
        try writeFiles(content: enums, at: "\(basePath)/enums")
        try writeFiles(content: protocols, at: "\(basePath)/protocols")
        try writeFiles(content: typealiases, at: "\(basePath)/typealiases")
        print("Done 🎉")
    }

    private func writeFiles(content: [MarkdownConvertible & SwiftDocDictionaryInitializable], at basePath: String) throws {
        for item in content {
            try MarkdownFile(filename: item.name, content: [item]).write(basePath: basePath)
        }
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
