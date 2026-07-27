/// An attribute on an import statement (e.g. `@testable`, `@_exported`).
public struct ImportAttribute: Equatable {
    /// The SourceKit attribute key (e.g. "source.decl.attribute.testable").
    public let kind: String
    /// Byte offset of the attribute in the source file.
    public let offset: ByteCount
    /// Byte length of the attribute.
    public let length: ByteCount
}

/// Represents an import statement extracted from a Swift source file's syntax map.
public struct ImportInfo: Equatable {
    /// Full import path (e.g. "Foundation", "Foundation.NSObject", "Darwin.exit").
    public let name: String
    /// Byte offset of the import statement (including any preceding attributes like @testable).
    public let offset: ByteCount
    /// Byte length of the full import statement.
    public let length: ByteCount
    /// Attributes on the import (e.g. `@testable`, `@_exported`).
    public let attributes: [ImportAttribute]
    /// The declaration kind keyword for kind-qualified imports (e.g. "class", "struct", "func").
    /// Nil for plain imports like `import Foundation`.
    public let importKind: String?
    /// The module name (first path component) for dotted imports.
    /// Nil for plain module imports like `import Foundation`.
    public let moduleName: String?

    /// Dictionary representation using SourceKit key conventions.
    public var dictionaryRepresentation: [String: SourceKitRepresentable] {
        var dict: [String: SourceKitRepresentable] = [
            "key.name": name,
            "key.offset": Int64(offset.value),
            "key.length": Int64(length.value)
        ]
        if !attributes.isEmpty {
            dict["key.attributes"] = attributes.map { attribute -> SourceKitRepresentable in
                [
                    "key.attribute": attribute.kind,
                    "key.offset": Int64(attribute.offset.value),
                    "key.length": Int64(attribute.length.value)
                ] as [String: SourceKitRepresentable]
            } as [SourceKitRepresentable]
        }
        if let importKind = importKind {
            dict["key.import_kind"] = importKind
        }
        if let moduleName = moduleName {
            dict["key.module_name"] = moduleName
        }
        return dict
    }

    /// Extract import information from a syntax map and source file.
    ///
    /// Walks the syntax map tokens looking for `import` keywords, then collects
    /// subsequent identifier tokens on the same line to determine the module name
    /// and full import path. Handles `@testable` and `@_exported` attributes
    /// preceding the import keyword, as well as kind-qualified imports like
    /// `import class Foundation.NSObject`.
    ///
    /// - Parameters:
    ///   - syntaxMap: The syntax map from a SourceKit `editor.open` response.
    ///   - file: The source file, used to extract text from byte ranges.
    /// - Returns: Array of `ImportInfo` for each import statement found.
    public static func extractImports(from syntaxMap: SyntaxMap, in file: File) -> [ImportInfo] {
        let tokens = syntaxMap.tokens
        var imports = [ImportInfo]()
        var index = 0

        while index < tokens.count {
            let token = tokens[index]

            // Look for keyword tokens that are "import"
            guard token.type == SyntaxKind.keyword.rawValue,
                  file.stringView.substringWithByteRange(token.range) == "import" else {
                index += 1
                continue
            }

            // Collect preceding attribute tokens (e.g. @testable, @_exported)
            var collectedAttributes = [ImportAttribute]()
            var attributeStart: ByteCount?
            var lookback = index - 1
            while lookback >= 0 {
                let prev = tokens[lookback]
                guard prev.type == SyntaxKind.attributeBuiltin.rawValue ||
                      prev.type == SyntaxKind.attributeID.rawValue,
                      let attrText = file.stringView.substringWithByteRange(prev.range),
                      attrText.hasPrefix("@") else {
                    break
                }
                let sourceKitKey = "source.decl.attribute.\(attrText.dropFirst())"
                guard let kind = SwiftDeclarationAttributeKind(rawValue: sourceKitKey) else {
                    break
                }
                attributeStart = prev.offset
                collectedAttributes.append(ImportAttribute(kind: kind.rawValue, offset: prev.offset, length: prev.length))
                lookback -= 1
            }
            // Reverse so attributes appear in source order
            collectedAttributes.reverse()

            let importKeywordEnd = token.offset + token.length
            let statementStart = attributeStart ?? token.offset

            // Collect subsequent tokens on the same line to build the full import path
            var identifiers = [String]()
            var importKind: String?
            var lastTokenEnd = importKeywordEnd
            var nextIndex = index + 1

            while nextIndex < tokens.count {
                let nextToken = tokens[nextIndex]

                // Check that the gap between the previous token end and this token doesn't contain a newline
                let gapStart = lastTokenEnd
                let gapLength = nextToken.offset - gapStart
                if gapLength > ByteCount(0) {
                    let gapRange = ByteRange(location: gapStart, length: gapLength)
                    if let gapText = file.stringView.substringWithByteRange(gapRange),
                       gapText.contains("\n") {
                        break
                    }
                }

                if nextToken.type == SyntaxKind.identifier.rawValue ||
                   nextToken.type == SyntaxKind.typeidentifier.rawValue {
                    if let text = file.stringView.substringWithByteRange(nextToken.range) {
                        identifiers.append(text)
                    }
                    lastTokenEnd = nextToken.offset + nextToken.length
                } else if nextToken.type == SyntaxKind.keyword.rawValue {
                    // The kind keyword (class/struct/func/enum/protocol/typealias/var/let)
                    // e.g. `import class Foundation.NSObject`
                    if let text = file.stringView.substringWithByteRange(nextToken.range) {
                        importKind = text
                    }
                    lastTokenEnd = nextToken.offset + nextToken.length
                } else if nextToken.type == SyntaxKind.operator.rawValue {
                    // Dot operator in submodule imports like `import Foundation.NSObject`
                    lastTokenEnd = nextToken.offset + nextToken.length
                } else {
                    break
                }

                nextIndex += 1
            }

            if !identifiers.isEmpty {
                let fullPath = identifiers.joined(separator: ".")
                let moduleName: String? = identifiers.count > 1 ? identifiers[0] : nil
                let totalLength = lastTokenEnd - statementStart
                imports.append(ImportInfo(
                    name: fullPath,
                    offset: statementStart,
                    length: totalLength,
                    attributes: collectedAttributes,
                    importKind: importKind,
                    moduleName: moduleName
                ))
            }

            index = nextIndex
        }

        return imports
    }
}
