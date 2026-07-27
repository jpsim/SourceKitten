/// Represents the structural information in a Swift source file.
public struct Structure {
    /// Structural information as an [String: SourceKitRepresentable].
    public let dictionary: [String: SourceKitRepresentable]

    /**
    Create a Structure from a SourceKit `editor.open` response.
     
    - parameter sourceKitResponse: SourceKit `editor.open` response.
    */
    public init(sourceKitResponse: [String: SourceKitRepresentable]) {
        var sourceKitResponse = sourceKitResponse
        _ = sourceKitResponse.removeValue(forKey: SwiftDocKey.syntaxMap.rawValue)
        dictionary = sourceKitResponse
    }

    /**
    Create a Structure from a SourceKit `editor.open` response, extracting import
    information from the syntax map before discarding it.

    - parameter sourceKitResponse: SourceKit `editor.open` response.
    - parameter file: The source file, used to resolve import names from byte ranges.
    */
    public init(sourceKitResponse: [String: SourceKitRepresentable], file: File, extractImports: Bool = false) {
        var sourceKitResponse = sourceKitResponse
        if extractImports, let syntaxMapData = SwiftDocKey.getSyntaxMap(sourceKitResponse) {
            let syntaxMap = SyntaxMap(data: syntaxMapData)
            let imports = ImportInfo.extractImports(from: syntaxMap, in: file)
            if !imports.isEmpty {
                sourceKitResponse["key.imports"] = imports.map { $0.dictionaryRepresentation } as [SourceKitRepresentable]
            } else {
                sourceKitResponse["key.imports"] = [SourceKitRepresentable]()
            }
        }
        _ = sourceKitResponse.removeValue(forKey: SwiftDocKey.syntaxMap.rawValue)
        dictionary = sourceKitResponse
    }

    /**
    Initialize a Structure by passing in a File.

    - parameter file: File to parse for structural information.
    - parameter extractImports: Whether to extract import information from the syntax map. Defaults to `false`.
    - throws: Request.Error
    */
    public init(file: File, extractImports: Bool = false) throws {
        let response = try Request.editorOpen(file: file).send()
        self.init(sourceKitResponse: response, file: file, extractImports: extractImports)
    }
}

// MARK: CustomStringConvertible

extension Structure: CustomStringConvertible {
    /// A textual JSON representation of `Structure`.
    public var description: String { return toJSON(toNSDictionary(dictionary)) }
}

// MARK: Equatable

extension Structure: Equatable {}

/**
Returns true if `lhs` Structure is equal to `rhs` Structure.

- parameter lhs: Structure to compare to `rhs`.
- parameter rhs: Structure to compare to `lhs`.

- returns: True if `lhs` Structure is equal to `rhs` Structure.
*/
public func == (lhs: Structure, rhs: Structure) -> Bool {
    return lhs.dictionary.isEqualTo(rhs.dictionary)
}
