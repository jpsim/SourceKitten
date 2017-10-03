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
        }
        else {
            properties = []
            methods = []
        }
    }

    var propertiesOutput: String {
        return properties.isEmpty ? "" : """
        ## Properties

        \(properties.output)
        """
    }

    var methodsOutput: String {
        return methods.isEmpty ? "" : """
        ## Methods

        \(methods.output)
        """
    }

    var output: String {
        return """
        # \(name)

        \(defaultOutput)

        ---

        \(propertiesOutput)

        \(methodsOutput)
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

        \(defaultOutput)
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
        }
        else {
            parameters = []
        }
    }

    var output: String {
        return """
        ### \(name)

        \(defaultOutput)

        #### Parameters
        | Name | Description |
        | ---- | ----------- |
        \(parameters.map { $0.output }.joined(separator: "\n"))
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
        }
        else {
            discussion = []
        }
    }

    var output: String {
        return """
        | *\(name)* | \(discussion.joined(separator: "\n")) |
        """
    }
}
