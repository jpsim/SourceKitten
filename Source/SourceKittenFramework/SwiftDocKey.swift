//
//  SwiftDocKey.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-05.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation

/// SourceKit response dictionary keys.
public enum SwiftDocKey: String {
    // MARK: SourceKit Keys

    /// Annotated declaration (String).
    case AnnotatedDeclaration = "key.annotated_decl"
    /// Body length (Int64).
    case BodyLength           = "key.bodylength"
    /// Body offset (Int64).
    case BodyOffset           = "key.bodyoffset"
    /// Diagnostic stage (String).
    case DiagnosticStage      = "key.diagnostic_stage"
    /// File path (String).
    case FilePath             = "key.filepath"
    /// Full XML docs (String).
    case FullXMLDocs          = "key.doc.full_as_xml"
    /// Kind (String).
    case Kind                 = "key.kind"
    /// Length (Int64).
    case Length               = "key.length"
    /// Name (String).
    case Name                 = "key.name"
    /// Name length (Int64).
    case NameLength           = "key.namelength"
    /// Name offset (Int64).
    case NameOffset           = "key.nameoffset"
    /// Offset (Int64).
    case Offset               = "key.offset"
    /// Substructure ([SourceKitRepresentable]).
    case Substructure         = "key.substructure"
    /// Syntax map (NSData).
    case SyntaxMap            = "key.syntaxmap"
    /// Type name (String).
    case TypeName             = "key.typename"
    /// Inheritedtype ([SourceKitRepresentable])
    case Inheritedtypes       = "key.inheritedtypes"

    // MARK: Custom Keys

    /// Column where the token's declaration begins (Int64).
    case DocColumn            = "key.doc.column"
    /// Documentation comment (String).
    case DocumentationComment = "key.doc.comment"
    /// Declaration of documented token (String).
    case DocDeclaration       = "key.doc.declaration"
    /// Discussion documentation of documented token ([SourceKitRepresentable]).
    case DocDiscussion        = "key.doc.discussion"
    /// File where the documented token is located (String).
    case DocFile              = "key.doc.file"
    /// Line where the token's declaration begins (Int64).
    case DocLine              = "key.doc.line"
    /// Name of documented token (String).
    case DocName              = "key.doc.name"
    /// Parameters of documented token ([SourceKitRepresentable]).
    case DocParameters        = "key.doc.parameters"
    /// Parsed declaration (String).
    case DocResultDiscussion  = "key.doc.result_discussion"
    /// Parsed scope start (Int64).
    case DocType              = "key.doc.type"
    /// Parsed scope start end (Int64).
    case USR                  = "key.usr"
    /// Result discussion documentation of documented token ([SourceKitRepresentable]).
    case ParsedDeclaration    = "key.parsed_declaration"
    /// Type of documented token (String).
    case ParsedScopeEnd       = "key.parsed_scope.end"
    /// USR of documented token (String).
    case ParsedScopeStart     = "key.parsed_scope.start"
    /// Swift Declaration (String).
    case SwiftDeclaration     = "key.swift_declaration"
    /// Always deprecated (Bool).
    case AlwaysDeprecated     = "key.always_deprecated"
    /// Always unavailable (Bool).
    case AlwaysUnavailable    = "key.always_unavailable"
    /// Always deprecated (String).
    case DeprecationMessage   = "key.deprecation_message"
    /// Always unavailable (String).
    case UnavailableMessage   = "key.unavailable_message"


    // MARK: Typed SwiftDocKey Getters

    /**
    Returns the typed value of a dictionary key.

    - parameter key:        SwiftDoctKey to get from the dictionary.
    - parameter dictionary: Dictionary to get value from.

    - returns: Typed value of a dictionary key.
    */
    private static func get<T>(_ key: SwiftDocKey, _ dictionary: [String: SourceKitRepresentable]) -> T? {
        return dictionary[key.rawValue] as! T?
    }

    /**
    Get kind string from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Kind string if successful.
    */
    internal static func getKind(_ dictionary: [String: SourceKitRepresentable]) -> String? {
        return get(.Kind, dictionary)
    }

    /**
    Get syntax map data from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Syntax map data if successful.
    */
    internal static func getSyntaxMap(_ dictionary: [String: SourceKitRepresentable]) -> [SourceKitRepresentable]? {
        return get(.SyntaxMap, dictionary)
    }

    /**
    Get offset int from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Offset int if successful.
    */
    internal static func getOffset(_ dictionary: [String: SourceKitRepresentable]) -> Int64? {
        return get(.Offset, dictionary)
    }

    /**
    Get length int from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Length int if successful.
    */
    internal static func getLength(_ dictionary: [String: SourceKitRepresentable]) -> Int64? {
        return get(.Length, dictionary)
    }

    /**
    Get type name string from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Type name string if successful.
    */
    internal static func getTypeName(_ dictionary: [String: SourceKitRepresentable]) -> String? {
        return get(.TypeName, dictionary)
    }

    /**
    Get annotated declaration string from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Annotated declaration string if successful.
    */
    internal static func getAnnotatedDeclaration(_ dictionary: [String: SourceKitRepresentable]) -> String? {
        return get(.AnnotatedDeclaration, dictionary)
    }

    /**
    Get substructure array from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Substructure array if successful.
    */
    internal static func getSubstructure(_ dictionary: [String: SourceKitRepresentable]) -> [SourceKitRepresentable]? {
        return get(.Substructure, dictionary)
    }

    /**
    Get name offset int from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Name offset int if successful.
    */
    internal static func getNameOffset(_ dictionary: [String: SourceKitRepresentable]) -> Int64? {
        return get(.NameOffset, dictionary)
    }

    /**
    Get length int from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Length int if successful.
    */
    internal static func getNameLength(_ dictionary: [String: SourceKitRepresentable]) -> Int64? {
        return get(.NameLength, dictionary)
    }

    /**
    Get body offset int from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Body offset int if successful.
    */
    internal static func getBodyOffset(_ dictionary: [String: SourceKitRepresentable]) -> Int64? {
        return get(.BodyOffset, dictionary)
    }

    /**
    Get body length int from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Body length int if successful.
    */
    internal static func getBodyLength(_ dictionary: [String: SourceKitRepresentable]) -> Int64? {
        return get(.BodyLength, dictionary)
    }

    /**
    Get file path string from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: File path string if successful.
    */
    internal static func getFilePath(_ dictionary: [String: SourceKitRepresentable]) -> String? {
        return get(.FilePath, dictionary)
    }

    /**
    Get full xml docs string from dictionary.

    - parameter dictionary: Dictionary to get value from.

    - returns: Full xml docs string if successful.
    */
    internal static func getFullXMLDocs(_ dictionary: [String: SourceKitRepresentable]) -> String? {
        return get(.FullXMLDocs, dictionary)
    }
}
