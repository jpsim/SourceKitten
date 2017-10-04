//
//  MarkdownElements.swift
//  sourcekitten
//
//  Created by Eneko Alonso on 10/3/17.
//

import Foundation
import SourceKittenFramework

struct MarkdownObject: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.struct, .class]) else {
            return nil
        }
        self.dictionary = dictionary

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            properties = structure.flatMap { MarkdownVariable(dictionary: $0) }
            methods = structure.flatMap { MarkdownMethod(dictionary: $0) }
        } else {
            properties = []
            methods = []
        }
    }

    var elementType: String {
        if dictionary.isKind(.struct) {
            return "struct"
        }
        if dictionary.isKind(.class) {
            return "class"
        }
        return ""
    }

    var output: String {
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        <sub>**\(elementType.uppercased())**</sub>
        # \(name)

        \(declarationOutput)

        \(comment)

        --------------------

        \(properties)

        \(methods)
        """
    }
}

struct MarkdownEnum: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let cases: [MarkdownEnumCaseElement]
    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.enum]) else {
            return nil
        }
        self.dictionary = dictionary

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            cases = structure.flatMap {
                guard let substructure: [SwiftDocDictionary] = $0.get(.substructure), let first = substructure.first else {
                    return nil
                }
                return MarkdownEnumCaseElement(dictionary: first)
            }
            properties = structure.flatMap { MarkdownVariable(dictionary: $0) }
            methods = structure.flatMap { MarkdownMethod(dictionary: $0) }
        } else {
            cases = []
            properties = []
            methods = []
        }
    }

    var output: String {
        let cases = collectionOutput(title: "## Cases", collection: self.cases)
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        <sub>**ENUM**</sub>
        # \(name)

        \(declarationOutput)

        \(comment)

        --------------------

        \(cases)

        \(properties)

        \(methods)
        """
    }
}

struct MarkdownEnumCaseElement: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.isKind([.enumelement]) else {
            return nil
        }
        self.dictionary = dictionary
    }

    var output: String {
        return """
        ### \(name)

        \(declarationOutput)

        \(comment)
        """
    }
}

struct MarkdownProtocol: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.protocol]) else {
            return nil
        }
        self.dictionary = dictionary

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            properties = structure.flatMap { MarkdownVariable(dictionary: $0) }
            methods = structure.flatMap { MarkdownMethod(dictionary: $0) }
        } else {
            properties = []
            methods = []
        }
    }

    var output: String {
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        <sub>**PROTOCOL**</sub>
        # \(name)

        \(declarationOutput)

        \(comment)

        --------------------

        \(properties)

        \(methods)
        """
    }
}

struct MarkdownTypealias: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.protocol]) else {
            return nil
        }
        self.dictionary = dictionary
    }

    var output: String {
        return """
        <sub>**TYPEALIAS**</sub>
        # \(name)

        \(declarationOutput)

        \(comment)

        --------------------
        """
    }
}

struct MarkdownExtension: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let properties: [MarkdownVariable]
    let methods: [MarkdownMethod]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.isKind([.extension, .extensionEnum, .extensionClass, .extensionStruct, .extensionProtocol]) else {
            return nil
        }
        self.dictionary = dictionary

        if let structure: [SwiftDocDictionary] = dictionary.get(.substructure) {
            properties = structure.flatMap { MarkdownVariable(dictionary: $0) }
            methods = structure.flatMap { MarkdownMethod(dictionary: $0) }
        } else {
            properties = []
            methods = []
        }

        // Extensions ACL is defined by their properties and methods
        if properties.isEmpty && methods.isEmpty {
            return nil
        }
    }

    var output: String {
        let properties = collectionOutput(title: "## Properties", collection: self.properties)
        let methods = collectionOutput(title: "## Methods", collection: self.methods)
        return """
        <sub>**EXTENSION**</sub>
        # \(name)

        \(declarationOutput)

        \(comment)

        --------------------

        \(properties)

        \(methods)
        """
    }
}

struct MarkdownVariable: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind(.varInstance) else {
            return nil
        }
        self.dictionary = dictionary
    }

    var output: String {
        return """
        ### \(name)

        \(declarationOutput)

        \(comment)
        """
    }
}

struct MarkdownMethod: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let parameters: [MarkdownMethodParameter]

    init?(dictionary: SwiftDocDictionary) {
        guard dictionary.hasPublicACL && dictionary.isKind([.functionMethodInstance, .functionMethodStatic, .functionMethodClass]) else {
            return nil
        }
        self.dictionary = dictionary
        if let params: [SwiftDocDictionary] = dictionary.get(.docParameters) {
            parameters = params.flatMap { MarkdownMethodParameter(dictionary: $0) }
        } else {
            parameters = []
        }
    }

    var parametersTable: String {
        if parameters.isEmpty {
            return ""
        }
        return """
        #### Parameters
        | Name | Description |
        | ---- | ----------- |
        \(parameters.map { $0.output }.joined(separator: "\n"))
        """
    }

    var output: String {
        return """
        ### \(name)

        \(declarationOutput)

        \(comment)

        \(parametersTable)
        """
    }
}

struct MarkdownMethodParameter: SwiftDocDictionaryInitializable, MarkdownConvertible {
    let dictionary: SwiftDocDictionary
    let name: String
    let discussion: [String]

    init?(dictionary: SwiftDocDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String ?? "[NO NAME]"
        if let discussion = dictionary["discussion"] as? [SwiftDocDictionary] {
            self.discussion = discussion.flatMap { $0["Para"] as? String }
        } else {
            discussion = []
        }
    }

    var output: String {
        return """
        | *\(name)* | \(discussion.joined(separator: "\n")) |
        """
    }
}
