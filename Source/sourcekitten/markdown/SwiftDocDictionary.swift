//
//  SwiftDocDictionary.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/3/17.
//

import Foundation
import SourceKittenFramework

typealias SwiftDocDictionary = [String: Any]

extension Dictionary where Key == String, Value == Any {
    func get<T>(_ key: SwiftDocKey) -> T? {
        return self[key.rawValue] as? T
    }

    var hasPublicACL: Bool {
        return get(.accessibility) == "source.lang.swift.accessibility.public"
    }

    func isKind(_ kind: SwiftDeclarationKind) -> Bool {
        return SwiftDeclarationKind(rawValue: get(.kind) ?? "") == kind
    }

    func isKind(_ kinds: [SwiftDeclarationKind]) -> Bool {
        guard let value: String = get(.kind), let kind = SwiftDeclarationKind(rawValue: value) else {
            return false
        }
        return kinds.contains(kind)
    }
}

protocol SwiftDocDictionaryInitializable {
    var dictionary: SwiftDocDictionary { get }

    init?(dictionary: SwiftDocDictionary)
}

extension SwiftDocDictionaryInitializable {
    var name: String {
        return dictionary.get(.name) ?? "[NO NAME]"
    }
    var comment: String {
        return dictionary.get(.documentationComment) ?? ""
    }
    var declaration: String {
        return dictionary.get(.parsedDeclaration) ?? ""
    }
    var typename: String {
        return dictionary.get(.typeName) ?? ""
    }

    var declarationOutput: String {
        return declaration.isEmpty ? "" : """
        ```swift
        \(declaration)
        ```
        """
    }

    func collectionOutput(title: String, collection: [MarkdownConvertible]) -> String {
        return collection.isEmpty ? "" : """
        \(title)
        \(collection.output)
        """
    }
}
