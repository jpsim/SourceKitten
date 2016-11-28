//
//  CodeCompletionItem.swift
//  SourceKitten
//
//  Created by JP Simard on 9/4/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import Foundation

fileprivate extension Dictionary {
    mutating func addIfNotNil(_ key: Key, _ value: Value?) {
        if let value = value {
            self[key] = value
        }
    }
}

public struct CodeCompletionItem: CustomStringConvertible {
    public let kind: String
    public let context: String
    public let name: String?
    public let descriptionKey: String?
    public let sourcetext: String?
    public let typeName: String?
    public let moduleName: String?
    public let docBrief: String?
    public let associatedUSRs: String?

    /// Dictionary representation of CodeCompletionItem. Useful for NSJSONSerialization.
    public var dictionaryValue: [String: Any] {
        var dict = ["kind": kind, "context": context]
        dict.addIfNotNil("name", name)
        dict.addIfNotNil("descriptionKey", descriptionKey)
        dict.addIfNotNil("sourcetext", sourcetext)
        dict.addIfNotNil("typeName", typeName)
        dict.addIfNotNil("moduleName", moduleName)
        dict.addIfNotNil("docBrief", docBrief)
        dict.addIfNotNil("associatedUSRs", associatedUSRs)
        return dict
    }

    public var description: String {
        return toJSON(dictionaryValue)
    }

    public static func parse(response: SourceKitVariant) -> [CodeCompletionItem] {
        return response.results?.map { dict in
            return CodeCompletionItem(kind: dict.kind?.description ?? "",
                context: dict.context!,
                name: dict.name,
                descriptionKey: dict.description,
                sourcetext: dict.sourceText,
                typeName: dict.typeName,
                moduleName: dict.moduleName,
                docBrief: dict.docBrief,
                associatedUSRs: dict.associated_usrs)
        } ?? []
    }
}

// MARK: - migration support
extension CodeCompletionItem {
    @available(*, unavailable, renamed: "parse(response:)")
    public static func parseResponse(_ response: [String: Any]) -> [CodeCompletionItem] {
        fatalError()
    }
}
