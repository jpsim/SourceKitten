//
//  UID.swift
//  SourceKitten
//
//  Created by Norio Nomura on 10/21/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE
    import SourceKit
#endif


/// Swift representation of sourcekitd_uid_t
public struct UID {
    let uid: sourcekitd_uid_t
    init(_ uid: sourcekitd_uid_t) { self.uid = uid }

    var string: String {
        let bytes = sourcekitd_uid_get_string_ptr(uid)
        let length = sourcekitd_uid_get_length(uid)
        return String(bytes: bytes!, length: length)!
    }
}

// MARK: - Check known uid.
#if DEBUG
    extension UID {
        fileprivate var isKnown: Bool {
            return knownUIDs.contains(self)
        }
    }
#endif

// MARK: - Hashable
extension UID: Hashable {
    /// The hash value.
    ///
    /// Hash values are not guaranteed to be equal across different executions of
    /// your program. Do not save hash values to use during a future execution.
    public var hashValue: Int {
        return uid.hashValue
    }

    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: UID, rhs: UID) -> Bool {
        return lhs.uid == rhs.uid
    }
}

// MARK: - ExpressibleByStringLiteral
extension UID: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
        #if DEBUG
            precondition(isKnown, "\"\(description)\" is not predefined UID string!")
        #endif
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
        #if DEBUG
            precondition(isKnown, "\"\(description)\" is not predefined UID string!")
        #endif
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)
        #if DEBUG
            precondition(isKnown, "\"\(description)\" is not predefined UID string!")
        #endif
    }

    init(_ string: String) {
        uid = sourcekitd_uid_get_from_cstr(string)
    }
}

// MARK: - CustomStringConvertible
extension UID: CustomStringConvertible {
    public var description: String {
        return string
    }
}

// MARK: - CustomLeafReflectable
extension UID: CustomLeafReflectable {
    public var customMirror: Mirror {
        return Mirror(self, children: [])
    }
}

// MARK: - Keys defined in swift/tools/SourceKit/tools/sourcekitd/lib/API/sourcekitdAPI-Common.cpp
extension UID {
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/tools/sourcekitd/lib/API/sourcekitdAPI-Common.cpp#L36-L136
    public static let keyVersionMajor: UID = "key.version_major"
    public static let keyVersionMinor: UID = "key.version_minor"
    public static let keyResults: UID = "key.results"
    public static let keyRequest: UID = "key.request"
    public static let keyCompilerArgs: UID = "key.compilerargs"
    public static let keyOffset: UID = "key.offset"
    public static let keySourceFile: UID = "key.sourcefile"
    public static let keySourceText: UID = "key.sourcetext"
    public static let keyModuleName: UID = "key.modulename"
    public static let keyGroupName: UID = "key.groupname"
    public static let keySynthesizedExtensions: UID = "key.synthesizedextensions"
    public static let keyNotification: UID = "key.notification"
    public static let keyKeyword: UID = "key.keyword"
    public static let keyName: UID = "key.name"
    public static let keyNames: UID = "key.names"
    public static let keyUIDs: UID = "key.uids"
    public static let keyEnableSyntaxMap: UID = "key.enablesyntaxmap"
    public static let keyEnableDiagnostics: UID = "key.enablediagnostics"
    public static let keySyntacticOnly: UID = "key.syntactic_only"
    public static let keyLength: UID = "key.length"
    public static let keyKind: UID = "key.kind"
    public static let keyAccessibility: UID = "key.accessibility"
    public static let keySetterAccessibility: UID = "key.setter_accessibility"
    public static let keyUSR: UID = "key.usr"
    public static let keyOriginalUSR: UID = "key.original_usr"
    public static let keyDefaultImplementationOf: UID = "key.default_implementation_of"
    public static let keyInterestedUSR: UID = "key.interested_usr"
    public static let keyLine: UID = "key.line"
    public static let keyColumn: UID = "key.column"
    public static let keyReceiverUSR: UID = "key.receiver_usr"
    public static let keyIsDynamic: UID = "key.is_dynamic"
    public static let keyIsTestCandidate: UID = "key.is_test_candidate"
    public static let keyDescription: UID = "key.description"
    public static let keyTypeName: UID = "key.typename"
    public static let keyRuntimeName: UID = "key.runtime_name"
    public static let keySelectorName: UID = "key.selector_name"
    public static let keyOverrides: UID = "key.overrides"
    public static let keyDocBrief: UID = "key.doc.brief"
    public static let keyAssociatedUSRs: UID = "key.associated_usrs"
    public static let keyDocFullAsXML: UID = "key.doc.full_as_xml"
    public static let keyGenericParams: UID = "key.generic_params"
    public static let keyGenericRequirements: UID = "key.generic_requirements"
    public static let keyAnnotatedDecl: UID = "key.annotated_decl"
    public static let keyFullyAnnotatedDecl: UID = "key.fully_annotated_decl"
    public static let keyRelatedDecls: UID = "key.related_decls"
    public static let keyContext: UID = "key.context"
    public static let keyModuleImportDepth: UID = "key.moduleimportdepth"
    public static let keyNumBytesToErase: UID = "key.num_bytes_to_erase"
    public static let keyNotRecommended: UID = "key.not_recommended"
    public static let keyFilePath: UID = "key.filepath"
    public static let keyModuleInterfaceName: UID = "key.module_interface_name"
    public static let keyHash: UID = "key.hash"
    public static let keyRelated: UID = "key.related"
    public static let keyInherits: UID = "key.inherits"
    public static let keyConforms: UID = "key.conforms"
    public static let keyExtends: UID = "key.extends"
    public static let keyDependencies: UID = "key.dependencies"
    public static let keyEntities: UID = "key.entities"
    public static let keyDiagnostics: UID = "key.diagnostics"
    public static let keySeverity: UID = "key.severity"
    public static let keyRanges: UID = "key.ranges"
    public static let keyFixits: UID = "key.fixits"
    public static let keyAnnotations: UID = "key.annotations"
    public static let keyDiagnosticStage: UID = "key.diagnostic_stage"
    public static let keySyntaxMap: UID = "key.syntaxmap"
    public static let keyIsSystem: UID = "key.is_system"
    public static let keyEnableSubStructure: UID = "key.enablesubstructure"
    public static let keySubStructure: UID = "key.substructure"
    public static let keyElements: UID = "key.elements"
    public static let keyNameOffset: UID = "key.nameoffset"
    public static let keyNameLength: UID = "key.namelength"
    public static let keyBodyOffset: UID = "key.bodyoffset"
    public static let keyBodyLength: UID = "key.bodylength"
    public static let keyThrowOffset: UID = "key.throwoffset"
    public static let keyThrowLength: UID = "key.throwlength"
    public static let keyIsLocal: UID = "key.is_local"
    public static let keyAttributes: UID = "key.attributes"
    public static let keyAttribute: UID = "key.attribute"
    public static let keyInheritedTypes: UID = "key.inheritedtypes"
    public static let keyEditorFormatOptions: UID = "key.editor.format.options"
    public static let keyCodeCompleteOptions: UID = "key.codecomplete.options"
    public static let keyCodeCompleteFilterRules: UID = "key.codecomplete.filterrules"
    public static let keyNextRequestStart: UID = "key.nextrequeststart"
    public static let keyPopular: UID = "key.popular"
    public static let keyUnpopular: UID = "key.unpopular"
    public static let keyHide: UID = "key.hide"
    public static let keySimplified: UID = "key.simplified"

    public static let keyIsDeprecated: UID = "key.is_deprecated"
    public static let keyIsUnavailable: UID = "key.is_unavailable"
    public static let keyIsOptional: UID = "key.is_optional"
    public static let keyPlatform: UID = "key.platform"
    public static let keyMessage: UID = "key.message"
    public static let keyIntroduced: UID = "key.introduced"
    public static let keyDeprecated: UID = "key.deprecated"
    public static let keyObsoleted: UID = "key.obsoleted"
    public static let keyRemoveCache: UID = "key.removecache"
    public static let keyTypeInterface: UID = "key.typeinterface"
    public static let keyTypeUsr: UID = "key.typeusr"
    public static let keyContainerTypeUsr: UID = "key.containertypeusr"
    public static let keyModuleGroups: UID = "key.modulegroups"
}

// MARK: - Keys defined in swift/tools/SourceKit/lib/SwiftLang/SwiftCompletion.cpp
extension UID {
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftCompletion.cpp#L389-L397
    public static let sourceLangSwiftLiteralArray: UID = "source.lang.swift.literal.array"
    public static let sourceLangSwiftLiteralBoolean: UID = "source.lang.swift.literal.boolean"
    public static let sourceLangSwiftLiteralColor: UID = "source.lang.swift.literal.color"
    public static let sourceLangSwiftLiteralImage: UID = "source.lang.swift.literal.image"
    public static let sourceLangSwiftLiteralDictionary: UID = "source.lang.swift.literal.dictionary"
    public static let sourceLangSwiftLiteralInteger: UID = "source.lang.swift.literal.integer"
    public static let sourceLangSwiftLiteralNil: UID = "source.lang.swift.literal.nil"
    public static let sourceLangSwiftLiteralString: UID = "source.lang.swift.literal.string"
    public static let sourceLangSwiftLiteralTuple: UID = "source.lang.swift.literal.tuple"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftCompletion.cpp#L423-L429
    public static let sourceLangSwiftKeyword: UID = "source.lang.swift.keyword"
    public static let sourceLangSwiftKeywordLet: UID = "source.lang.swift.keyword.let"
    public static let sourceLangSwiftKeywordVar: UID = "source.lang.swift.keyword.var"
    public static let sourceLangSwiftKeywordIf: UID = "source.lang.swift.keyword.if"
    public static let sourceLangSwiftKeywordFor: UID = "source.lang.swift.keyword.for"
    public static let sourceLangSwiftKeywordWhile: UID = "source.lang.swift.keyword.while"
    public static let sourceLangSwiftKeywordFunc: UID = "source.lang.swift.keyword.func"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftCompletion.cpp#L435-L436
//    public static let sourceLangSwiftKeyword: UID = "source.lang.swift.keyword"
    public static let sourceLangSwiftPattern: UID = "source.lang.swift.pattern"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftCompletion.cpp#L516-L524
    public static let sourceCodeCompletionContextNone: UID = "source.codecompletion.context.none"
    public static let sourceCodeCompletionContextExprsSpecific: UID = "source.codecompletion.context.exprspecific"
    public static let sourceCodeCompletionContextLocal: UID = "source.codecompletion.context.local"
    public static let sourceCodeCompletionContextThisClass: UID = "source.codecompletion.context.thisclass"
    public static let sourceCodeCompletionContextSuperClass: UID = "source.codecompletion.context.superclass"
    public static let sourceCodeCompletionContextOtherClass: UID = "source.codecompletion.context.otherclass"
    public static let sourceCodeCompletionContextThisModule: UID = "source.codecompletion.context.thismodule"
    public static let sourceCodeCompletionContextOtherModule: UID = "source.codecompletion.context.othermodule"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftCompletion.cpp#L594
    //
    // extracting keyword by:
    // `grep "^[^#/P]*KEYWORD(" swift/include/swift/Parse/Tokens.def|sed 's/^.*KEYWORD(\([^)]*\))/\1/'|sort|pbcopy`
    //
    public static let sourceLangSwiftKeywordAny: UID = "source.lang.swift.keyword.Any"
    public static let sourceLangSwiftKeywordSelf: UID = "source.lang.swift.keyword.Self"
    public static let sourceLangSwiftKeyword_: UID = "source.lang.swift.keyword._"
    public static let sourceLangSwiftKeyword__COLUMN__: UID = "source.lang.swift.keyword.__COLUMN__"
    public static let sourceLangSwiftKeyword__DSO_HANDLE__: UID = "source.lang.swift.keyword.__DSO_HANDLE__"
    public static let sourceLangSwiftKeyword__FILE__: UID = "source.lang.swift.keyword.__FILE__"
    public static let sourceLangSwiftKeyword__FUNCTION__: UID = "source.lang.swift.keyword.__FUNCTION__"
    public static let sourceLangSwiftKeyword__LINE__: UID = "source.lang.swift.keyword.__LINE__"
    public static let sourceLangSwiftKeywordAs: UID = "source.lang.swift.keyword.as"
    public static let sourceLangSwiftKeywordAssociatedtype: UID = "source.lang.swift.keyword.associatedtype"
    public static let sourceLangSwiftKeywordBreak: UID = "source.lang.swift.keyword.break"
    public static let sourceLangSwiftKeywordCase: UID = "source.lang.swift.keyword.case"
    public static let sourceLangSwiftKeywordCatch: UID = "source.lang.swift.keyword.catch"
    public static let sourceLangSwiftKeywordClass: UID = "source.lang.swift.keyword.class"
    public static let sourceLangSwiftKeywordContinue: UID = "source.lang.swift.keyword.continue"
    public static let sourceLangSwiftKeywordDefault: UID = "source.lang.swift.keyword.default"
    public static let sourceLangSwiftKeywordDefer: UID = "source.lang.swift.keyword.defer"
    public static let sourceLangSwiftKeywordDeinit: UID = "source.lang.swift.keyword.deinit"
    public static let sourceLangSwiftKeywordDo: UID = "source.lang.swift.keyword.do"
    public static let sourceLangSwiftKeywordElse: UID = "source.lang.swift.keyword.else"
    public static let sourceLangSwiftKeywordEnum: UID = "source.lang.swift.keyword.enum"
    public static let sourceLangSwiftKeywordExtension: UID = "source.lang.swift.keyword.extension"
    public static let sourceLangSwiftKeywordFallthrough: UID = "source.lang.swift.keyword.fallthrough"
    public static let sourceLangSwiftKeywordFalse: UID = "source.lang.swift.keyword.false"
    public static let sourceLangSwiftKeywordFileprivate: UID = "source.lang.swift.keyword.fileprivate"
//    public static let sourceLangSwiftKeywordFor: UID = "source.lang.swift.keyword.for"
//    public static let sourceLangSwiftKeywordFunc: UID = "source.lang.swift.keyword.func"
    public static let sourceLangSwiftKeywordGuard: UID = "source.lang.swift.keyword.guard"
//    public static let sourceLangSwiftKeywordIf: UID = "source.lang.swift.keyword.if"
    public static let sourceLangSwiftKeywordImport: UID = "source.lang.swift.keyword.import"
    public static let sourceLangSwiftKeywordIn: UID = "source.lang.swift.keyword.in"
    public static let sourceLangSwiftKeywordInit: UID = "source.lang.swift.keyword.init"
    public static let sourceLangSwiftKeywordInout: UID = "source.lang.swift.keyword.inout"
    public static let sourceLangSwiftKeywordInternal: UID = "source.lang.swift.keyword.internal"
    public static let sourceLangSwiftKeywordIs: UID = "source.lang.swift.keyword.is"
//    public static let sourceLangSwiftKeywordLet: UID = "source.lang.swift.keyword.let"
    public static let sourceLangSwiftKeywordNil: UID = "source.lang.swift.keyword.nil"
    public static let sourceLangSwiftKeywordOperator: UID = "source.lang.swift.keyword.operator"
    public static let sourceLangSwiftKeywordPrecedencegroup: UID = "source.lang.swift.keyword.precedencegroup"
    public static let sourceLangSwiftKeywordPrivate: UID = "source.lang.swift.keyword.private"
    public static let sourceLangSwiftKeywordProtocol: UID = "source.lang.swift.keyword.protocol"
    public static let sourceLangSwiftKeywordPublic: UID = "source.lang.swift.keyword.public"
    public static let sourceLangSwiftKeywordRepeat: UID = "source.lang.swift.keyword.repeat"
    public static let sourceLangSwiftKeywordRethrows: UID = "source.lang.swift.keyword.rethrows"
    public static let sourceLangSwiftKeywordReturn: UID = "source.lang.swift.keyword.return"
    public static let sourceLangSwiftKeywordself: UID = "source.lang.swift.keyword.self"
    public static let sourceLangSwiftKeywordSil: UID = "source.lang.swift.keyword.sil"
    public static let sourceLangSwiftKeywordSil_coverage_map: UID = "source.lang.swift.keyword.sil_coverage_map"
    public static let sourceLangSwiftKeywordSil_default_witness_table: UID = "source.lang.swift.keyword.sil_default_witness_table"
    public static let sourceLangSwiftKeywordSil_global: UID = "source.lang.swift.keyword.sil_global"
    public static let sourceLangSwiftKeywordSil_scope: UID = "source.lang.swift.keyword.sil_scope"
    public static let sourceLangSwiftKeywordSil_stage: UID = "source.lang.swift.keyword.sil_stage"
    public static let sourceLangSwiftKeywordSil_vtable: UID = "source.lang.swift.keyword.sil_vtable"
    public static let sourceLangSwiftKeywordSil_witness_table: UID = "source.lang.swift.keyword.sil_witness_table"
    public static let sourceLangSwiftKeywordStatic: UID = "source.lang.swift.keyword.static"
    public static let sourceLangSwiftKeywordStruct: UID = "source.lang.swift.keyword.struct"
    public static let sourceLangSwiftKeywordSubscript: UID = "source.lang.swift.keyword.subscript"
    public static let sourceLangSwiftKeywordSuper: UID = "source.lang.swift.keyword.super"
    public static let sourceLangSwiftKeywordSwitch: UID = "source.lang.swift.keyword.switch"
    public static let sourceLangSwiftKeywordThrow: UID = "source.lang.swift.keyword.throw"
    public static let sourceLangSwiftKeywordThrows: UID = "source.lang.swift.keyword.throws"
    public static let sourceLangSwiftKeywordTrue: UID = "source.lang.swift.keyword.true"
    public static let sourceLangSwiftKeywordTry: UID = "source.lang.swift.keyword.try"
    public static let sourceLangSwiftKeywordTypealias: UID = "source.lang.swift.keyword.typealias"
    public static let sourceLangSwiftKeywordUndef: UID = "source.lang.swift.keyword.undef"
//    public static let sourceLangSwiftKeywordVar: UID = "source.lang.swift.keyword.var"
    public static let sourceLangSwiftKeywordWhere: UID = "source.lang.swift.keyword.where"
//    public static let sourceLangSwiftKeywordWhile: UID = "source.lang.swift.keyword.while"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftCompletion.cpp#L787
    public static let sourceLangSwiftCodeCompleteGroup = "source.lang.swift.codecomplete.group"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftCompletion.cpp#L800-L818
    public static let keyCodeCompleteSortByName: UID = "key.codecomplete.sort.byname"
    public static let keyCodeCompleteUseImportDepth: UID = "key.codecomplete.sort.useimportdepth"
    public static let keyCodeCompleteGroupOverloads: UID = "key.codecomplete.group.overloads"
    public static let keyCodeCompleteGroupStems: UID = "key.codecomplete.group.stems"
    public static let keyCodeCompleteFilterText: UID = "key.codecomplete.filtertext"
    public static let keyCodeCompleteRequestLimit: UID = "key.codecomplete.requestlimit"
    public static let keyCodeCompleteRequestStart: UID = "key.codecomplete.requeststart"
    public static let keyCodeCompleteHideUnderscores: UID = "key.codecomplete.hideunderscores"
    public static let keyCodeCompleteHideLowPriority: UID = "key.codecomplete.hidelowpriority"
    public static let keyCodeCompleteHideByName: UID = "key.codecomplete.hidebyname"
    public static let keyCodeCompleteIncludeExactMatch: UID = "key.codecomplete.includeexactmatch"
    public static let keyCodeCompleteAddInnerResults: UID = "key.codecomplete.addinnerresults"
    public static let keyCodeCompleteAddInnerOperators: UID = "key.codecomplete.addinneroperators"
    public static let keyCodeCompleteAddInitsToTopLevel: UID = "key.codecomplete.addinitstotoplevel"
    public static let keyCodeCompleteFuzzyMatching: UID = "key.codecomplete.fuzzymatching"
    public static let keyCodeCompleteShowTopNonLiteralResults: UID = "key.codecomplete.showtopnonliteralresults"
    public static let keyCodeCompleteSortContextWeight: UID = "key.codecomplete.sort.contextweight"
    public static let keyCodeCompleteSortFuzzyWeight: UID = "key.codecomplete.sort.fuzzyweight"
    public static let keyCodeCompleteSortPopularityBonus: UID = "key.codecomplete.sort.popularitybonus"
}

// MARK: - Keys defined in swift/tools/SourceKit/lib/SwiftLang/SwiftDocSupport.cpp
extension UID {
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftDocSupport.cpp#L502-L510
    public static let sourceLangSwiftAttributeAvailability: UID = "source.lang.swift.attribute.availability"
    public static let sourceAvailabilityPlatformIOS: UID = "source.availability.platform.ios"
    public static let sourceAvailabilityPlatformOSX: UID = "source.availability.platform.osx"
    public static let sourceAvailabilityPlatformtvOS: UID = "source.availability.platform.tvos"
    public static let sourceAvailabilityPlatformWatchOS: UID = "source.availability.platform.watchos"
    public static let sourceAvailabilityPlatformIOSAppExt: UID = "source.availability.platform.ios_app_extension"
    public static let sourceAvailabilityPlatformOSXAppExt: UID = "source.availability.platform.osx_app_extension"
    public static let sourceAvailabilityPlatformtvOSAppExt: UID = "source.availability.platform.tvos_app_extension"
    public static let sourceAvailabilityPlatformWatchOSAppExt: UID = "source.availability.platform.watchos_app_extension"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftDocSupport.cpp#L557
    public static let sourceLangSwiftSyntaxTypeArgument: UID = "source.lang.swift.syntaxtype.argument"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftDocSupport.cpp#L663
    public static let sourceLangSwiftSyntaxTypeParameter: UID = "source.lang.swift.syntaxtype.parameter"
}

// MARK: - Keys defined in swift/tools/SourceKit/lib/SwiftLang/SwiftEditor.cpp
extension UID {
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftEditor.cpp#L959-L963
    public static let sourceLangSwiftAccessibilityOpen: UID = "source.lang.swift.accessibility.open"
    public static let sourceLangSwiftAccessibilityPublic: UID = "source.lang.swift.accessibility.public"
    public static let sourceLangSwiftAccessibilityInternal: UID = "source.lang.swift.accessibility.internal"
    public static let sourceLangSwiftAccessibilityFilePrivate: UID = "source.lang.swift.accessibility.fileprivate"
    public static let sourceLangSwiftAccessibilityPrivate: UID = "source.lang.swift.accessibility.private"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftEditor.cpp#L1787-L1788
    public static let sourceDiagnosticStageSwiftSema: UID = "source.diagnostic.stage.swift.sema"
    public static let sourceDiagnosticStageSwiftParse: UID = "source.diagnostic.stage.swift.parse"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftEditor.cpp#L1807-L1809
    public static let keyEditorFormatUseTabs: UID = "key.editor.format.usetabs"
    public static let keyEditorFormatIndentWidth: UID = "key.editor.format.indentwidth"
    public static let keyEditorFormatTabWidth: UID = "key.editor.format.tabwidth"
}

// MARK: - Keys defined in swift/tools/SourceKit/lib/SwiftLang/SwiftIndexing.cpp
extension UID {
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftIndexing.cpp#L31-L32
    public static let sourceLangSwiftImportModuleClang: UID = "source.lang.swift.import.module.clang"
    public static let sourceLangSwiftImportModuleSwift: UID = "source.lang.swift.import.module.swift"
}

// MARK: - Keys defined in swift/tools/SourceKit/lib/SwiftLang/SwiftLangSupport.cpp
extension UID {
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftLangSupport.cpp#L47-L154
    public static let sourceLangSwiftDeclFunctionFree: UID = "source.lang.swift.decl.function.free"
    public static let sourceLangSwiftRefFunctionFree: UID = "source.lang.swift.ref.function.free"
    public static let sourceLangSwiftDeclMethodInstance: UID = "source.lang.swift.decl.function.method.instance"
    public static let sourceLangSwiftRefMethodInstance: UID = "source.lang.swift.ref.function.method.instance"
    public static let sourceLangSwiftDeclMethodStatic: UID = "source.lang.swift.decl.function.method.static"
    public static let sourceLangSwiftRefMethodStatic: UID = "source.lang.swift.ref.function.method.static"
    public static let sourceLangSwiftDeclMethodClass: UID = "source.lang.swift.decl.function.method.class"
    public static let sourceLangSwiftRefMethodClass: UID = "source.lang.swift.ref.function.method.class"
    public static let sourceLangSwiftDeclAccessorGetter: UID = "source.lang.swift.decl.function.accessor.getter"
    public static let sourceLangSwiftRefAccessorGetter: UID = "source.lang.swift.ref.function.accessor.getter"
    public static let sourceLangSwiftDeclAccessorSetter: UID = "source.lang.swift.decl.function.accessor.setter"
    public static let sourceLangSwiftRefAccessorSetter: UID = "source.lang.swift.ref.function.accessor.setter"
    public static let sourceLangSwiftDeclAccessorWillSet: UID = "source.lang.swift.decl.function.accessor.willset"
    public static let sourceLangSwiftRefAccessorWillSet: UID = "source.lang.swift.ref.function.accessor.willset"
    public static let sourceLangSwiftDeclAccessorDidSet: UID = "source.lang.swift.decl.function.accessor.didset"
    public static let sourceLangSwiftRefAccessorDidSet: UID = "source.lang.swift.ref.function.accessor.didset"
    public static let sourceLangSwiftDeclAccessorAddress: UID = "source.lang.swift.decl.function.accessor.address"
    public static let sourceLangSwiftRefAccessorAddress: UID = "source.lang.swift.ref.function.accessor.address"
    public static let sourceLangSwiftDeclAccessorMutableAddress: UID = "source.lang.swift.decl.function.accessor.mutableaddress"
    public static let sourceLangSwiftRefAccessorMutableAddress: UID = "source.lang.swift.ref.function.accessor.mutableaddress"
    public static let sourceLangSwiftDeclConstructor: UID = "source.lang.swift.decl.function.constructor"
    public static let sourceLangSwiftRefConstructor: UID = "source.lang.swift.ref.function.constructor"
    public static let sourceLangSwiftDeclDestructor: UID = "source.lang.swift.decl.function.destructor"
    public static let sourceLangSwiftRefDestructor: UID = "source.lang.swift.ref.function.destructor"
    public static let sourceLangSwiftDeclFunctionPrefixOperator: UID = "source.lang.swift.decl.function.operator.prefix"
    public static let sourceLangSwiftDeclFunctionPostfixOperator: UID = "source.lang.swift.decl.function.operator.postfix"
    public static let sourceLangSwiftDeclFunctionInfixOperator: UID = "source.lang.swift.decl.function.operator.infix"
    public static let sourceLangSwiftRefFunctionPrefixOperator: UID = "source.lang.swift.ref.function.operator.prefix"
    public static let sourceLangSwiftRefFunctionPostfixOperator: UID = "source.lang.swift.ref.function.operator.postfix"
    public static let sourceLangSwiftRefFunctionInfixOperator: UID = "source.lang.swift.ref.function.operator.infix"
    public static let sourceLangSwiftDeclPrecedenceGroup: UID = "source.lang.swift.decl.precedencegroup"
    public static let sourceLangSwiftRefPrecedenceGroup: UID = "source.lang.swift.ref.precedencegroup"
    public static let sourceLangSwiftDeclSubscript: UID = "source.lang.swift.decl.function.subscript"
    public static let sourceLangSwiftRefSubscript: UID = "source.lang.swift.ref.function.subscript"
    public static let sourceLangSwiftDeclVarGlobal: UID = "source.lang.swift.decl.var.global"
    public static let sourceLangSwiftRefVarGlobal: UID = "source.lang.swift.ref.var.global"
    public static let sourceLangSwiftDeclVarInstance: UID = "source.lang.swift.decl.var.instance"
    public static let sourceLangSwiftRefVarInstance: UID = "source.lang.swift.ref.var.instance"
    public static let sourceLangSwiftDeclVarStatic: UID = "source.lang.swift.decl.var.static"
    public static let sourceLangSwiftRefVarStatic: UID = "source.lang.swift.ref.var.static"
    public static let sourceLangSwiftDeclVarClass: UID = "source.lang.swift.decl.var.class"
    public static let sourceLangSwiftRefVarClass: UID = "source.lang.swift.ref.var.class"
    public static let sourceLangSwiftDeclVarLocal: UID = "source.lang.swift.decl.var.local"
    public static let sourceLangSwiftRefVarLocal: UID = "source.lang.swift.ref.var.local"
    public static let sourceLangSwiftDeclVarParam: UID = "source.lang.swift.decl.var.parameter"
    public static let sourceLangSwiftDeclModule: UID = "source.lang.swift.decl.module"
    public static let sourceLangSwiftDeclClass: UID = "source.lang.swift.decl.class"
    public static let sourceLangSwiftRefClass: UID = "source.lang.swift.ref.class"
    public static let sourceLangSwiftDeclStruct: UID = "source.lang.swift.decl.struct"
    public static let sourceLangSwiftRefStruct: UID = "source.lang.swift.ref.struct"
    public static let sourceLangSwiftDeclEnum: UID = "source.lang.swift.decl.enum"
    public static let sourceLangSwiftRefEnum: UID = "source.lang.swift.ref.enum"
    public static let sourceLangSwiftDeclEnumCase: UID = "source.lang.swift.decl.enumcase"
    public static let sourceLangSwiftDeclEnumElement: UID = "source.lang.swift.decl.enumelement"
    public static let sourceLangSwiftRefEnumElement: UID = "source.lang.swift.ref.enumelement"
    public static let sourceLangSwiftDeclProtocol: UID = "source.lang.swift.decl.protocol"
    public static let sourceLangSwiftRefProtocol: UID = "source.lang.swift.ref.protocol"
    public static let sourceLangSwiftDeclExtension: UID = "source.lang.swift.decl.extension"
    public static let sourceLangSwiftDeclExtensionStruct: UID = "source.lang.swift.decl.extension.struct"
    public static let sourceLangSwiftDeclExtensionClass: UID = "source.lang.swift.decl.extension.class"
    public static let sourceLangSwiftDeclExtensionEnum: UID = "source.lang.swift.decl.extension.enum"
    public static let sourceLangSwiftDeclExtensionProtocol: UID = "source.lang.swift.decl.extension.protocol"
    public static let sourceLangSwiftDeclAssociatedType: UID = "source.lang.swift.decl.associatedtype"
    public static let sourceLangSwiftRefAssociatedType: UID = "source.lang.swift.ref.associatedtype"
    public static let sourceLangSwiftDeclTypeAlias: UID = "source.lang.swift.decl.typealias"
    public static let sourceLangSwiftRefTypeAlias: UID = "source.lang.swift.ref.typealias"
    public static let sourceLangSwiftDeclGenericTypeParam: UID = "source.lang.swift.decl.generic_type_param"
    public static let sourceLangSwiftRefGenericTypeParam: UID = "source.lang.swift.ref.generic_type_param"
    public static let sourceLangSwiftRefModule: UID = "source.lang.swift.ref.module"
    public static let sourceLangSwiftStmtForEach: UID = "source.lang.swift.stmt.foreach"
    public static let sourceLangSwiftStmtFor: UID = "source.lang.swift.stmt.for"
    public static let sourceLangSwiftStmtWhile: UID = "source.lang.swift.stmt.while"
    public static let sourceLangSwiftStmtRepeatWhile: UID = "source.lang.swift.stmt.repeatwhile"
    public static let sourceLangSwiftStmtIf: UID = "source.lang.swift.stmt.if"
    public static let sourceLangSwiftStmtGuard: UID = "source.lang.swift.stmt.guard"
    public static let sourceLangSwiftStmtSwitch: UID = "source.lang.swift.stmt.switch"
    public static let sourceLangSwiftStmtCase: UID = "source.lang.swift.stmt.case"
    public static let sourceLangSwiftStmtBrace: UID = "source.lang.swift.stmt.brace"
    public static let sourceLangSwiftExprCall: UID = "source.lang.swift.expr.call"
    public static let sourceLangSwiftExprArg: UID = "source.lang.swift.expr.argument"
    public static let sourceLangSwiftExprArray: UID = "source.lang.swift.expr.array"
    public static let sourceLangSwiftExprDictionary: UID = "source.lang.swift.expr.dictionary"
    public static let sourceLangSwiftExprObjectLiteral: UID = "source.lang.swift.expr.object_literal"

    public static let sourceLangSwiftStructureElemId: UID = "source.lang.swift.structure.elem.id"
    public static let sourceLangSwiftStructureElemExpr: UID = "source.lang.swift.structure.elem.expr"
    public static let sourceLangSwiftStructureElemInitExpr: UID = "source.lang.swift.structure.elem.init_expr"
    public static let sourceLangSwiftStructureElemCondExpr: UID = "source.lang.swift.structure.elem.condition_expr"
    public static let sourceLangSwiftStructureElemPattern: UID = "source.lang.swift.structure.elem.pattern"
    public static let sourceLangSwiftStructureElemTypeRef: UID = "source.lang.swift.structure.elem.typeref"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftLangSupport.cpp#L396-L412
    public static let sourceLangSwiftSyntaxTypeKeyword: UID = "source.lang.swift.syntaxtype.keyword"
    public static let sourceLangSwiftSyntaxTypeIdentifier: UID = "source.lang.swift.syntaxtype.identifier"
    public static let sourceLangSwiftSyntaxTypeTypeIdentifier: UID = "source.lang.swift.syntaxtype.typeidentifier"
    public static let sourceLangSwiftSyntaxTypeBuildConfigKeyword: UID = "source.lang.swift.syntaxtype.buildconfig.keyword"
    public static let sourceLangSwiftSyntaxTypeBuildConfigId: UID = "source.lang.swift.syntaxtype.buildconfig.id"
    public static let sourceLangSwiftSyntaxTypeAttributeId: UID = "source.lang.swift.syntaxtype.attribute.id"
    public static let sourceLangSwiftSyntaxTypeAttributeBuiltin: UID = "source.lang.swift.syntaxtype.attribute.builtin"
    public static let sourceLangSwiftSyntaxTypeNumber: UID = "source.lang.swift.syntaxtype.number"
    public static let sourceLangSwiftSyntaxTypeString: UID = "source.lang.swift.syntaxtype.string"
    public static let sourceLangSwiftSyntaxTypeStringInterpolation: UID = "source.lang.swift.syntaxtype.string_interpolation_anchor"
    public static let sourceLangSwiftSyntaxTypeComment: UID = "source.lang.swift.syntaxtype.comment"
    public static let sourceLangSwiftSyntaxTypeDocComment: UID = "source.lang.swift.syntaxtype.doccomment"
    public static let sourceLangSwiftSyntaxTypeDocCommentField: UID = "source.lang.swift.syntaxtype.doccomment.field"
    public static let sourceLangSwiftSyntaxTypeCommentMarker: UID = "source.lang.swift.syntaxtype.comment.mark"
    public static let sourceLangSwiftSyntaxTypeCommentURL: UID = "source.lang.swift.syntaxtype.comment.url"
    public static let sourceLangSwiftSyntaxTypePlaceholder: UID = "source.lang.swift.syntaxtype.placeholder"
    public static let sourceLangSwiftSyntaxTypeObjectLiteral: UID = "source.lang.swift.syntaxtype.objectliteral"

    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftLangSupport.cpp#L623
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftLangSupport.cpp#L632-L658
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/lib/SwiftLang/SwiftLangSupport.cpp#L683
    //
    // extracting attribute by:
    // `strings /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/sourcekitd.framework/XPCServices/SourceKitService.xpc/Contents/MacOS/SourceKitService /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/sourcekitd.framework/sourcekitd |grep "source\.decl\.attribute\."|sort|pbcopy`

    public static let sourceDeclAttributeLLDBDebuggerFunction: UID = "source.decl.attribute.LLDBDebuggerFunction"
    public static let sourceDeclAttributeNSApplicationMain: UID = "source.decl.attribute.NSApplicationMain"
    public static let sourceDeclAttributeNSCopying: UID = "source.decl.attribute.NSCopying"
    public static let sourceDeclAttributeNSManaged: UID = "source.decl.attribute.NSManaged"
    public static let sourceDeclAttributeUIApplicationMain: UID = "source.decl.attribute.UIApplicationMain"
    public static let sourceDeclAttribute__objcBridged: UID = "source.decl.attribute.__objc_bridged"
    public static let sourceDeclAttribute__synthesizedProtocol: UID = "source.decl.attribute.__synthesized_protocol"
    public static let sourceDeclAttribute_alignment: UID = "source.decl.attribute._alignment"
    public static let sourceDeclAttribute_cdecl: UID = "source.decl.attribute._cdecl"
    public static let sourceDeclAttribute_exported: UID = "source.decl.attribute._exported"
    public static let sourceDeclAttribute_fixedLayout: UID = "source.decl.attribute._fixed_layout"
    public static let sourceDeclAttribute_semantics: UID = "source.decl.attribute._semantics"
    public static let sourceDeclAttribute_silgenName: UID = "source.decl.attribute._silgen_name"
    public static let sourceDeclAttribute_specialize: UID = "source.decl.attribute._specialize"
    public static let sourceDeclAttribute_swift_native_objc_runtime_base: UID = "source.decl.attribute._swift_native_objc_runtime_base"
    public static let sourceDeclAttribute_transparent: UID = "source.decl.attribute._transparent"
    public static let sourceDeclAttribute_versioned: UID = "source.decl.attribute._versioned"
    public static let sourceDeclAttributeAutoclosure: UID = "source.decl.attribute.autoclosure"
    public static let sourceDeclAttributeAvailable: UID = "source.decl.attribute.available"
    public static let sourceDeclAttributeConvenience: UID = "source.decl.attribute.convenience"
    public static let sourceDeclAttributeDiscardableResult: UID = "source.decl.attribute.discardableResult"
    public static let sourceDeclAttributeDynamic: UID = "source.decl.attribute.dynamic"
    public static let sourceDeclAttributeEffects: UID = "source.decl.attribute.effects"
    public static let sourceDeclAttributeEscaping: UID = "source.decl.attribute.escaping"
    public static let sourceDeclAttributeFinal: UID = "source.decl.attribute.final"
    public static let sourceDeclAttributeGkinspectable: UID = "source.decl.attribute.gkinspectable"
    public static let sourceDeclAttributeIbaction: UID = "source.decl.attribute.ibaction"
    public static let sourceDeclAttributeIbdesignable: UID = "source.decl.attribute.ibdesignable"
    public static let sourceDeclAttributeIbinspectable: UID = "source.decl.attribute.ibinspectable"
    public static let sourceDeclAttributeIboutlet: UID = "source.decl.attribute.iboutlet"
    public static let sourceDeclAttributeIndirect: UID = "source.decl.attribute.indirect"
    public static let sourceDeclAttributeInfix: UID = "source.decl.attribute.infix"
    public static let sourceDeclAttributeInline: UID = "source.decl.attribute.inline"
    public static let sourceDeclAttributeLazy: UID = "source.decl.attribute.lazy"
    public static let sourceDeclAttributeMutating: UID = "source.decl.attribute.mutating"
    public static let sourceDeclAttributeNoescape: UID = "source.decl.attribute.noescape"
    public static let sourceDeclAttributeNonmutating: UID = "source.decl.attribute.nonmutating"
    public static let sourceDeclAttributeNonobjc: UID = "source.decl.attribute.nonobjc"
    public static let sourceDeclAttributeNoreturn: UID = "source.decl.attribute.noreturn"
    public static let sourceDeclAttributeObjc: UID = "source.decl.attribute.objc"
    public static let sourceDeclAttributeObjcName: UID = "source.decl.attribute.objc.name"
    public static let sourceDeclAttributeObjcNonLazyRealization: UID = "source.decl.attribute.objc_non_lazy_realization"
    public static let sourceDeclAttributeOptional: UID = "source.decl.attribute.optional"
    public static let sourceDeclAttributeOverride: UID = "source.decl.attribute.override"
    public static let sourceDeclAttributePostfix: UID = "source.decl.attribute.postfix"
    public static let sourceDeclAttributePrefix: UID = "source.decl.attribute.prefix"
    public static let sourceDeclAttributeRequired: UID = "source.decl.attribute.required"
    public static let sourceDeclAttributeRequiresStoredPropertyInits: UID = "source.decl.attribute.requires_stored_property_inits"
    public static let sourceDeclAttributeRethrows: UID = "source.decl.attribute.rethrows"
    public static let sourceDeclAttributeSilStored: UID = "source.decl.attribute.sil_stored"
    public static let sourceDeclAttributeSwift3Migration: UID = "source.decl.attribute.swift3_migration"
    public static let sourceDeclAttributeTestable: UID = "source.decl.attribute.testable"
    public static let sourceDeclAttributeUnsafeNoObjcTaggedPointer: UID = "source.decl.attribute.unsafe_no_objc_tagged_pointer"
    public static let sourceDeclAttributeWarnUnqualifiedAccess: UID = "source.decl.attribute.warn_unqualified_access"
    public static let sourceDeclAttributeWeak: UID = "source.decl.attribute.weak"
}

// MARK: - Keys defined in swift/tools/SourceKit/tools/sourcekitd/bin/XPC/Client/sourcekitd.cpp
extension UID {
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/tools/sourcekitd/bin/XPC/Client/sourcekitd.cpp#L29-L31
    //    public static let keyNotification: UID = "key.notification"
    public static let keyDuration: UID = "key.duration"
    public static let sourceNotificationSemaDisabled: UID = "source.notification.sema_disabled"
}

// MARK: - Keys defined in swift/tools/SourceKit/tools/sourcekitd/lib/API/Requests.cpp
extension UID {
    // - SeeAlso: https://github.com/apple/swift/blob/swift-3.0.1-PREVIEW-3/tools/SourceKit/tools/sourcekitd/lib/API/Requests.cpp#L62-L121
    public static let sourceRequestProtocolVersion: UID = "source.request.protocol_version"
    public static let sourceRequestCrashWithExit: UID = "source.request.crash_exit"
    public static let sourceRequestDemangle: UID = "source.request.demangle"
    public static let sourceRequestMangleSimpleClass: UID = "source.request.mangle_simple_class"
    public static let sourceRequestIndexSource: UID = "source.request.indexsource"
    public static let sourceRequestDocInfo: UID = "source.request.docinfo"
    public static let sourceRequestCodeComplete: UID = "source.request.codecomplete"
    public static let sourceRequestCodeCompleteOpen: UID = "source.request.codecomplete.open"
    public static let sourceRequestCodeCompleteClose: UID = "source.request.codecomplete.close"
    public static let sourceRequestCodeCompleteUpdate: UID = "source.request.codecomplete.update"
    public static let sourceRequestCodeCompleteCacheOnDisk: UID = "source.request.codecomplete.cache.ondisk"
    public static let sourceRequestCodeCompleteSetPopularAPI: UID = "source.request.codecomplete.setpopularapi"
    public static let sourceRequestCodeCompleteSetCustom: UID = "source.request.codecomplete.setcustom"
    public static let sourceRequestCursorInfo: UID = "source.request.cursorinfo"
    public static let sourceRequestRelatedIdents: UID = "source.request.relatedidents"
    public static let sourceRequestEditorOpen: UID = "source.request.editor.open"
    public static let sourceRequestEditorOpenInterface: UID = "source.request.editor.open.interface"
    public static let sourceRequestEditorOpenInterfaceHeader: UID = "source.request.editor.open.interface.header"
    public static let sourceRequestEditorOpenInterfaceSwiftSource: UID = "source.request.editor.open.interface.swiftsource"
    public static let sourceRequestEditorOpenInterfaceSwiftType: UID = "source.request.editor.open.interface.swifttype"
    public static let sourceRequestEditorExtractComment: UID = "source.request.editor.extract.comment"
    public static let sourceRequestEditorClose: UID = "source.request.editor.close"
    public static let sourceRequestEditorReplaceText: UID = "source.request.editor.replacetext"
    public static let sourceRequestEditorFormatText: UID = "source.request.editor.formattext"
    public static let sourceRequestEditorExpandPlaceholder: UID = "source.request.editor.expand_placeholder"
    public static let sourceRequestEditorFindUSR: UID = "source.request.editor.find_usr"
    public static let sourceRequestEditorFindInterfaceDoc: UID = "source.request.editor.find_interface_doc"
    public static let sourceRequestBuildSettingsRegister: UID = "source.request.buildsettings.register"
    public static let sourceRequestModuleGroups: UID = "source.request.module.groups"

    public static let sourceLangSwiftExpr: UID = "source.lang.swift.expr"
    public static let sourceLangSwiftStmt: UID = "source.lang.swift.stmt"
    public static let sourceLangSwiftType: UID = "source.lang.swift.type"

    public static let sourceCodeCompletionEverything: UID = "source.codecompletion.everything"
    public static let sourceCodeCompletionModule: UID = "source.codecompletion.module"
    public static let sourceCodeCompletionKeyword: UID = "source.codecompletion.keyword"
    public static let sourceCodeCompletionLiteral: UID = "source.codecompletion.literal"
    public static let sourceCodeCompletionCustom: UID = "source.codecompletion.custom"
    public static let sourceCodeCompletionIdentifier: UID = "source.codecompletion.identifier"

    public static let sourceDiagnosticSeverityNote: UID = "source.diagnostic.severity.note"
    public static let sourceDiagnosticSeverityWarning: UID = "source.diagnostic.severity.warning"
    public static let sourceDiagnosticSeverityError: UID = "source.diagnostic.severity.error"
}
