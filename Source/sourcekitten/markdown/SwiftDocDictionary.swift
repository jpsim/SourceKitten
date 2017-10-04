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
        guard let declaration: String = dictionary.get(.parsedDeclaration) else {
            return ""
        }
        return codeBlock(title: "Declaration", code: declaration)
    }
    var typename: String {
        guard let typename: String = dictionary.get(.typeName) else {
            return ""
        }
        return codeBlock(title: "Infered Type", code: typename)
    }

    func codeBlock(title: String, code: String) -> String {
        return """
        <sub>**\(title)**</sub>
        ```swift
        \(code)
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
