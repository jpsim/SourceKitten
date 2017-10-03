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
        return dictionary.get(.documentationComment) ?? "_Not documented_"
    }
    var declaration: String {
        return dictionary.get(.parsedDeclaration) ?? "[NO DECLARATION]"
    }
    var typename: String {
        return dictionary.get(.typeName) ?? "[NO TYPE]"
    }

    var defaultOutput: String {
        return """
        ```swift
        \(declaration)
        ```

        \(comment)
        """
    }
}
