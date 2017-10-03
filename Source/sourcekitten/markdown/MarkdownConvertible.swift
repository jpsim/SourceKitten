//
//  MarkdownConvertible.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/2/17.
//

import Foundation
import SourceKittenFramework


protocol MarkdownConvertible {
    var output: String { get }
}

func get<T>(_ key: SwiftDocKey, from dictionary: [String: Any]) -> T? {
    return dictionary[key.rawValue] as? T
}

struct MarkdownStruct: MarkdownConvertible {
    let name: String
    let overview: String
    let declaration: String

    init(dictionary: [String: Any]) {
        name = get(.name, from: dictionary) ?? ""
        overview = get(.documentationComment, from: dictionary) ?? ""
        declaration = get(.docDeclaration, from: dictionary) ?? ""
    }

    var output: String {
        return """
        # \(name)

        ```swift
        \(declaration)
        ```

        \(overview)

        ---

        """
    }
}
