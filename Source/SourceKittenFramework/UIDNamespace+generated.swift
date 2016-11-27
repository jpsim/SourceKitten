extension UID {
    public struct Key {
        public let uid: UID
        /// key.accessibility
        public static let accessibility: Key = "key.accessibility"
        /// key.annotated_decl
        public static let annotated_decl: Key = "key.annotated_decl"
        /// key.annotations
        public static let annotations: Key = "key.annotations"
        /// key.associated_usrs
        public static let associated_usrs: Key = "key.associated_usrs"
        /// key.attribute
        public static let attribute: Key = "key.attribute"
        /// key.attributes
        public static let attributes: Key = "key.attributes"
        /// key.bodylength
        public static let bodylength: Key = "key.bodylength"
        /// key.bodyoffset
        public static let bodyoffset: Key = "key.bodyoffset"
        /// key.codecomplete.addinitstotoplevel
        public static let codecompleteAddinitstotoplevel: Key = "key.codecomplete.addinitstotoplevel"
        /// key.codecomplete.addinneroperators
        public static let codecompleteAddinneroperators: Key = "key.codecomplete.addinneroperators"
        /// key.codecomplete.addinnerresults
        public static let codecompleteAddinnerresults: Key = "key.codecomplete.addinnerresults"
        /// key.codecomplete.filterrules
        public static let codecompleteFilterrules: Key = "key.codecomplete.filterrules"
        /// key.codecomplete.filtertext
        public static let codecompleteFiltertext: Key = "key.codecomplete.filtertext"
        /// key.codecomplete.fuzzymatching
        public static let codecompleteFuzzymatching: Key = "key.codecomplete.fuzzymatching"
        /// key.codecomplete.group.overloads
        public static let codecompleteGroupOverloads: Key = "key.codecomplete.group.overloads"
        /// key.codecomplete.group.stems
        public static let codecompleteGroupStems: Key = "key.codecomplete.group.stems"
        /// key.codecomplete.hidebyname
        public static let codecompleteHidebyname: Key = "key.codecomplete.hidebyname"
        /// key.codecomplete.hidelowpriority
        public static let codecompleteHidelowpriority: Key = "key.codecomplete.hidelowpriority"
        /// key.codecomplete.hideunderscores
        public static let codecompleteHideunderscores: Key = "key.codecomplete.hideunderscores"
        /// key.codecomplete.includeexactmatch
        public static let codecompleteIncludeexactmatch: Key = "key.codecomplete.includeexactmatch"
        /// key.codecomplete.options
        public static let codecompleteOptions: Key = "key.codecomplete.options"
        /// key.codecomplete.requestlimit
        public static let codecompleteRequestlimit: Key = "key.codecomplete.requestlimit"
        /// key.codecomplete.requeststart
        public static let codecompleteRequeststart: Key = "key.codecomplete.requeststart"
        /// key.codecomplete.showtopnonliteralresults
        public static let codecompleteShowtopnonliteralresults: Key = "key.codecomplete.showtopnonliteralresults"
        /// key.codecomplete.sort.byname
        public static let codecompleteSortByname: Key = "key.codecomplete.sort.byname"
        /// key.codecomplete.sort.contextweight
        public static let codecompleteSortContextweight: Key = "key.codecomplete.sort.contextweight"
        /// key.codecomplete.sort.fuzzyweight
        public static let codecompleteSortFuzzyweight: Key = "key.codecomplete.sort.fuzzyweight"
        /// key.codecomplete.sort.popularitybonus
        public static let codecompleteSortPopularitybonus: Key = "key.codecomplete.sort.popularitybonus"
        /// key.codecomplete.sort.useimportdepth
        public static let codecompleteSortUseimportdepth: Key = "key.codecomplete.sort.useimportdepth"
        /// key.column
        public static let column: Key = "key.column"
        /// key.compilerargs
        public static let compilerargs: Key = "key.compilerargs"
        /// key.conforms
        public static let conforms: Key = "key.conforms"
        /// key.containertypeusr
        public static let containertypeusr: Key = "key.containertypeusr"
        /// key.context
        public static let context: Key = "key.context"
        /// key.default_implementation_of
        public static let default_implementation_of: Key = "key.default_implementation_of"
        /// key.dependencies
        public static let dependencies: Key = "key.dependencies"
        /// key.deprecated
        public static let deprecated: Key = "key.deprecated"
        /// key.description
        public static let description: Key = "key.description"
        /// key.diagnostic_stage
        public static let diagnostic_stage: Key = "key.diagnostic_stage"
        /// key.diagnostics
        public static let diagnostics: Key = "key.diagnostics"
        /// key.doc.brief
        public static let docBrief: Key = "key.doc.brief"
        /// key.doc.full_as_xml
        public static let docFull_As_Xml: Key = "key.doc.full_as_xml"
        /// key.duration
        public static let duration: Key = "key.duration"
        /// key.editor.format.indentwidth
        public static let editorFormatIndentwidth: Key = "key.editor.format.indentwidth"
        /// key.editor.format.options
        public static let editorFormatOptions: Key = "key.editor.format.options"
        /// key.editor.format.tabwidth
        public static let editorFormatTabwidth: Key = "key.editor.format.tabwidth"
        /// key.editor.format.usetabs
        public static let editorFormatUsetabs: Key = "key.editor.format.usetabs"
        /// key.elements
        public static let elements: Key = "key.elements"
        /// key.enablediagnostics
        public static let enablediagnostics: Key = "key.enablediagnostics"
        /// key.enablesubstructure
        public static let enablesubstructure: Key = "key.enablesubstructure"
        /// key.enablesyntaxmap
        public static let enablesyntaxmap: Key = "key.enablesyntaxmap"
        /// key.entities
        public static let entities: Key = "key.entities"
        /// key.extends
        public static let extends: Key = "key.extends"
        /// key.filepath
        public static let filepath: Key = "key.filepath"
        /// key.fixits
        public static let fixits: Key = "key.fixits"
        /// key.fully_annotated_decl
        public static let fully_annotated_decl: Key = "key.fully_annotated_decl"
        /// key.generic_params
        public static let generic_params: Key = "key.generic_params"
        /// key.generic_requirements
        public static let generic_requirements: Key = "key.generic_requirements"
        /// key.groupname
        public static let groupname: Key = "key.groupname"
        /// key.hash
        public static let hash: Key = "key.hash"
        /// key.hide
        public static let hide: Key = "key.hide"
        /// key.inheritedtypes
        public static let inheritedtypes: Key = "key.inheritedtypes"
        /// key.inherits
        public static let inherits: Key = "key.inherits"
        /// key.interested_usr
        public static let interested_usr: Key = "key.interested_usr"
        /// key.introduced
        public static let introduced: Key = "key.introduced"
        /// key.is_deprecated
        public static let is_deprecated: Key = "key.is_deprecated"
        /// key.is_dynamic
        public static let is_dynamic: Key = "key.is_dynamic"
        /// key.is_local
        public static let is_local: Key = "key.is_local"
        /// key.is_optional
        public static let is_optional: Key = "key.is_optional"
        /// key.is_system
        public static let is_system: Key = "key.is_system"
        /// key.is_test_candidate
        public static let is_test_candidate: Key = "key.is_test_candidate"
        /// key.is_unavailable
        public static let is_unavailable: Key = "key.is_unavailable"
        /// key.keyword
        public static let keyword: Key = "key.keyword"
        /// key.kind
        public static let kind: Key = "key.kind"
        /// key.length
        public static let length: Key = "key.length"
        /// key.line
        public static let line: Key = "key.line"
        /// key.message
        public static let message: Key = "key.message"
        /// key.module_interface_name
        public static let module_interface_name: Key = "key.module_interface_name"
        /// key.modulegroups
        public static let modulegroups: Key = "key.modulegroups"
        /// key.moduleimportdepth
        public static let moduleimportdepth: Key = "key.moduleimportdepth"
        /// key.modulename
        public static let modulename: Key = "key.modulename"
        /// key.name
        public static let name: Key = "key.name"
        /// key.namelength
        public static let namelength: Key = "key.namelength"
        /// key.nameoffset
        public static let nameoffset: Key = "key.nameoffset"
        /// key.names
        public static let names: Key = "key.names"
        /// key.nextrequeststart
        public static let nextrequeststart: Key = "key.nextrequeststart"
        /// key.not_recommended
        public static let not_recommended: Key = "key.not_recommended"
        /// key.notification
        public static let notification: Key = "key.notification"
        /// key.num_bytes_to_erase
        public static let num_bytes_to_erase: Key = "key.num_bytes_to_erase"
        /// key.obsoleted
        public static let obsoleted: Key = "key.obsoleted"
        /// key.offset
        public static let offset: Key = "key.offset"
        /// key.original_usr
        public static let original_usr: Key = "key.original_usr"
        /// key.overrides
        public static let overrides: Key = "key.overrides"
        /// key.platform
        public static let platform: Key = "key.platform"
        /// key.popular
        public static let popular: Key = "key.popular"
        /// key.ranges
        public static let ranges: Key = "key.ranges"
        /// key.receiver_usr
        public static let receiver_usr: Key = "key.receiver_usr"
        /// key.related
        public static let related: Key = "key.related"
        /// key.related_decls
        public static let related_decls: Key = "key.related_decls"
        /// key.removecache
        public static let removecache: Key = "key.removecache"
        /// key.request
        public static let request: Key = "key.request"
        /// key.results
        public static let results: Key = "key.results"
        /// key.runtime_name
        public static let runtime_name: Key = "key.runtime_name"
        /// key.selector_name
        public static let selector_name: Key = "key.selector_name"
        /// key.setter_accessibility
        public static let setter_accessibility: Key = "key.setter_accessibility"
        /// key.severity
        public static let severity: Key = "key.severity"
        /// key.simplified
        public static let simplified: Key = "key.simplified"
        /// key.sourcefile
        public static let sourcefile: Key = "key.sourcefile"
        /// key.sourcetext
        public static let sourcetext: Key = "key.sourcetext"
        /// key.substructure
        public static let substructure: Key = "key.substructure"
        /// key.syntactic_only
        public static let syntactic_only: Key = "key.syntactic_only"
        /// key.syntaxmap
        public static let syntaxmap: Key = "key.syntaxmap"
        /// key.synthesizedextensions
        public static let synthesizedextensions: Key = "key.synthesizedextensions"
        /// key.throwlength
        public static let throwlength: Key = "key.throwlength"
        /// key.throwoffset
        public static let throwoffset: Key = "key.throwoffset"
        /// key.typeinterface
        public static let typeinterface: Key = "key.typeinterface"
        /// key.typename
        public static let typename: Key = "key.typename"
        /// key.typeusr
        public static let typeusr: Key = "key.typeusr"
        /// key.uids
        public static let uids: Key = "key.uids"
        /// key.unpopular
        public static let unpopular: Key = "key.unpopular"
        /// key.usr
        public static let usr: Key = "key.usr"
        /// key.version_major
        public static let version_major: Key = "key.version_major"
        /// key.version_minor
        public static let version_minor: Key = "key.version_minor"
    }
    public struct SourceAvailabilityPlatform {
        public let uid: UID
        /// source.availability.platform.ios
        public static let ios: SourceAvailabilityPlatform = "source.availability.platform.ios"
        /// source.availability.platform.ios_app_extension
        public static let ios_app_extension: SourceAvailabilityPlatform = "source.availability.platform.ios_app_extension"
        /// source.availability.platform.osx
        public static let osx: SourceAvailabilityPlatform = "source.availability.platform.osx"
        /// source.availability.platform.osx_app_extension
        public static let osx_app_extension: SourceAvailabilityPlatform = "source.availability.platform.osx_app_extension"
        /// source.availability.platform.tvos
        public static let tvos: SourceAvailabilityPlatform = "source.availability.platform.tvos"
        /// source.availability.platform.tvos_app_extension
        public static let tvos_app_extension: SourceAvailabilityPlatform = "source.availability.platform.tvos_app_extension"
        /// source.availability.platform.watchos
        public static let watchos: SourceAvailabilityPlatform = "source.availability.platform.watchos"
        /// source.availability.platform.watchos_app_extension
        public static let watchos_app_extension: SourceAvailabilityPlatform = "source.availability.platform.watchos_app_extension"
    }
    public struct SourceCodecompletion {
        public let uid: UID
        /// source.codecompletion.context.exprspecific
        public static let contextExprspecific: SourceCodecompletion = "source.codecompletion.context.exprspecific"
        /// source.codecompletion.context.local
        public static let contextLocal: SourceCodecompletion = "source.codecompletion.context.local"
        /// source.codecompletion.context.none
        public static let contextNone: SourceCodecompletion = "source.codecompletion.context.none"
        /// source.codecompletion.context.otherclass
        public static let contextOtherclass: SourceCodecompletion = "source.codecompletion.context.otherclass"
        /// source.codecompletion.context.othermodule
        public static let contextOthermodule: SourceCodecompletion = "source.codecompletion.context.othermodule"
        /// source.codecompletion.context.superclass
        public static let contextSuperclass: SourceCodecompletion = "source.codecompletion.context.superclass"
        /// source.codecompletion.context.thisclass
        public static let contextThisclass: SourceCodecompletion = "source.codecompletion.context.thisclass"
        /// source.codecompletion.context.thismodule
        public static let contextThismodule: SourceCodecompletion = "source.codecompletion.context.thismodule"
        /// source.codecompletion.custom
        public static let custom: SourceCodecompletion = "source.codecompletion.custom"
        /// source.codecompletion.everything
        public static let everything: SourceCodecompletion = "source.codecompletion.everything"
        /// source.codecompletion.identifier
        public static let identifier: SourceCodecompletion = "source.codecompletion.identifier"
        /// source.codecompletion.keyword
        public static let keyword: SourceCodecompletion = "source.codecompletion.keyword"
        /// source.codecompletion.literal
        public static let literal: SourceCodecompletion = "source.codecompletion.literal"
        /// source.codecompletion.module
        public static let module: SourceCodecompletion = "source.codecompletion.module"
    }
    public struct SourceDeclAttribute {
        public let uid: UID
        /// source.decl.attribute.LLDBDebuggerFunction
        public static let LLDBDebuggerFunction: SourceDeclAttribute = "source.decl.attribute.LLDBDebuggerFunction"
        /// source.decl.attribute.NSApplicationMain
        public static let NSApplicationMain: SourceDeclAttribute = "source.decl.attribute.NSApplicationMain"
        /// source.decl.attribute.NSCopying
        public static let NSCopying: SourceDeclAttribute = "source.decl.attribute.NSCopying"
        /// source.decl.attribute.NSManaged
        public static let NSManaged: SourceDeclAttribute = "source.decl.attribute.NSManaged"
        /// source.decl.attribute.UIApplicationMain
        public static let UIApplicationMain: SourceDeclAttribute = "source.decl.attribute.UIApplicationMain"
        /// source.decl.attribute.__objc_bridged
        public static let __objc_bridged: SourceDeclAttribute = "source.decl.attribute.__objc_bridged"
        /// source.decl.attribute.__synthesized_protocol
        public static let __synthesized_protocol: SourceDeclAttribute = "source.decl.attribute.__synthesized_protocol"
        /// source.decl.attribute._alignment
        public static let _alignment: SourceDeclAttribute = "source.decl.attribute._alignment"
        /// source.decl.attribute._cdecl
        public static let _cdecl: SourceDeclAttribute = "source.decl.attribute._cdecl"
        /// source.decl.attribute._exported
        public static let _exported: SourceDeclAttribute = "source.decl.attribute._exported"
        /// source.decl.attribute._fixed_layout
        public static let _fixed_layout: SourceDeclAttribute = "source.decl.attribute._fixed_layout"
        /// source.decl.attribute._semantics
        public static let _semantics: SourceDeclAttribute = "source.decl.attribute._semantics"
        /// source.decl.attribute._silgen_name
        public static let _silgen_name: SourceDeclAttribute = "source.decl.attribute._silgen_name"
        /// source.decl.attribute._specialize
        public static let _specialize: SourceDeclAttribute = "source.decl.attribute._specialize"
        /// source.decl.attribute._swift_native_objc_runtime_base
        public static let _swift_native_objc_runtime_base: SourceDeclAttribute = "source.decl.attribute._swift_native_objc_runtime_base"
        /// source.decl.attribute._transparent
        public static let _transparent: SourceDeclAttribute = "source.decl.attribute._transparent"
        /// source.decl.attribute._versioned
        public static let _versioned: SourceDeclAttribute = "source.decl.attribute._versioned"
        /// source.decl.attribute.autoclosure
        public static let autoclosure: SourceDeclAttribute = "source.decl.attribute.autoclosure"
        /// source.decl.attribute.available
        public static let available: SourceDeclAttribute = "source.decl.attribute.available"
        /// source.decl.attribute.convenience
        public static let convenience: SourceDeclAttribute = "source.decl.attribute.convenience"
        /// source.decl.attribute.discardableResult
        public static let discardableResult: SourceDeclAttribute = "source.decl.attribute.discardableResult"
        /// source.decl.attribute.dynamic
        public static let dynamic: SourceDeclAttribute = "source.decl.attribute.dynamic"
        /// source.decl.attribute.effects
        public static let effects: SourceDeclAttribute = "source.decl.attribute.effects"
        /// source.decl.attribute.escaping
        public static let escaping: SourceDeclAttribute = "source.decl.attribute.escaping"
        /// source.decl.attribute.final
        public static let final: SourceDeclAttribute = "source.decl.attribute.final"
        /// source.decl.attribute.gkinspectable
        public static let gkinspectable: SourceDeclAttribute = "source.decl.attribute.gkinspectable"
        /// source.decl.attribute.ibaction
        public static let ibaction: SourceDeclAttribute = "source.decl.attribute.ibaction"
        /// source.decl.attribute.ibdesignable
        public static let ibdesignable: SourceDeclAttribute = "source.decl.attribute.ibdesignable"
        /// source.decl.attribute.ibinspectable
        public static let ibinspectable: SourceDeclAttribute = "source.decl.attribute.ibinspectable"
        /// source.decl.attribute.iboutlet
        public static let iboutlet: SourceDeclAttribute = "source.decl.attribute.iboutlet"
        /// source.decl.attribute.indirect
        public static let indirect: SourceDeclAttribute = "source.decl.attribute.indirect"
        /// source.decl.attribute.infix
        public static let infix: SourceDeclAttribute = "source.decl.attribute.infix"
        /// source.decl.attribute.inline
        public static let inline: SourceDeclAttribute = "source.decl.attribute.inline"
        /// source.decl.attribute.lazy
        public static let lazy: SourceDeclAttribute = "source.decl.attribute.lazy"
        /// source.decl.attribute.mutating
        public static let mutating: SourceDeclAttribute = "source.decl.attribute.mutating"
        /// source.decl.attribute.noescape
        public static let noescape: SourceDeclAttribute = "source.decl.attribute.noescape"
        /// source.decl.attribute.nonmutating
        public static let nonmutating: SourceDeclAttribute = "source.decl.attribute.nonmutating"
        /// source.decl.attribute.nonobjc
        public static let nonobjc: SourceDeclAttribute = "source.decl.attribute.nonobjc"
        /// source.decl.attribute.noreturn
        public static let noreturn: SourceDeclAttribute = "source.decl.attribute.noreturn"
        /// source.decl.attribute.objc
        public static let objc: SourceDeclAttribute = "source.decl.attribute.objc"
        /// source.decl.attribute.objc.name
        public static let objcName: SourceDeclAttribute = "source.decl.attribute.objc.name"
        /// source.decl.attribute.objc_non_lazy_realization
        public static let objc_non_lazy_realization: SourceDeclAttribute = "source.decl.attribute.objc_non_lazy_realization"
        /// source.decl.attribute.optional
        public static let optional: SourceDeclAttribute = "source.decl.attribute.optional"
        /// source.decl.attribute.override
        public static let override: SourceDeclAttribute = "source.decl.attribute.override"
        /// source.decl.attribute.postfix
        public static let postfix: SourceDeclAttribute = "source.decl.attribute.postfix"
        /// source.decl.attribute.prefix
        public static let prefix: SourceDeclAttribute = "source.decl.attribute.prefix"
        /// source.decl.attribute.required
        public static let required: SourceDeclAttribute = "source.decl.attribute.required"
        /// source.decl.attribute.requires_stored_property_inits
        public static let requires_stored_property_inits: SourceDeclAttribute = "source.decl.attribute.requires_stored_property_inits"
        /// source.decl.attribute.rethrows
        public static let `rethrows`: SourceDeclAttribute = "source.decl.attribute.rethrows"
        /// source.decl.attribute.sil_stored
        public static let sil_stored: SourceDeclAttribute = "source.decl.attribute.sil_stored"
        /// source.decl.attribute.swift3_migration
        public static let swift3_migration: SourceDeclAttribute = "source.decl.attribute.swift3_migration"
        /// source.decl.attribute.testable
        public static let testable: SourceDeclAttribute = "source.decl.attribute.testable"
        /// source.decl.attribute.unsafe_no_objc_tagged_pointer
        public static let unsafe_no_objc_tagged_pointer: SourceDeclAttribute = "source.decl.attribute.unsafe_no_objc_tagged_pointer"
        /// source.decl.attribute.warn_unqualified_access
        public static let warn_unqualified_access: SourceDeclAttribute = "source.decl.attribute.warn_unqualified_access"
        /// source.decl.attribute.weak
        public static let weak: SourceDeclAttribute = "source.decl.attribute.weak"
    }
    public struct SourceDiagnosticSeverity {
        public let uid: UID
        /// source.diagnostic.severity.error
        public static let error: SourceDiagnosticSeverity = "source.diagnostic.severity.error"
        /// source.diagnostic.severity.note
        public static let note: SourceDiagnosticSeverity = "source.diagnostic.severity.note"
        /// source.diagnostic.severity.warning
        public static let warning: SourceDiagnosticSeverity = "source.diagnostic.severity.warning"
    }
    public struct SourceDiagnosticStageSwift {
        public let uid: UID
        /// source.diagnostic.stage.swift.parse
        public static let parse: SourceDiagnosticStageSwift = "source.diagnostic.stage.swift.parse"
        /// source.diagnostic.stage.swift.sema
        public static let sema: SourceDiagnosticStageSwift = "source.diagnostic.stage.swift.sema"
    }
    public struct SourceLangSwift {
        public let uid: UID
        /// source.lang.swift.expr
        public static let expr: SourceLangSwift = "source.lang.swift.expr"
        /// source.lang.swift.keyword
        public static let keyword: SourceLangSwift = "source.lang.swift.keyword"
        /// source.lang.swift.pattern
        public static let pattern: SourceLangSwift = "source.lang.swift.pattern"
        /// source.lang.swift.stmt
        public static let stmt: SourceLangSwift = "source.lang.swift.stmt"
        /// source.lang.swift.type
        public static let type: SourceLangSwift = "source.lang.swift.type"
    }
    public struct SourceLangSwiftAccessibility {
        public let uid: UID
        /// source.lang.swift.accessibility.fileprivate
        public static let `fileprivate`: SourceLangSwiftAccessibility = "source.lang.swift.accessibility.fileprivate"
        /// source.lang.swift.accessibility.internal
        public static let `internal`: SourceLangSwiftAccessibility = "source.lang.swift.accessibility.internal"
        /// source.lang.swift.accessibility.open
        public static let open: SourceLangSwiftAccessibility = "source.lang.swift.accessibility.open"
        /// source.lang.swift.accessibility.private
        public static let `private`: SourceLangSwiftAccessibility = "source.lang.swift.accessibility.private"
        /// source.lang.swift.accessibility.public
        public static let `public`: SourceLangSwiftAccessibility = "source.lang.swift.accessibility.public"
    }
    public struct SourceLangSwiftAttribute {
        public let uid: UID
        /// source.lang.swift.attribute.availability
        public static let availability: SourceLangSwiftAttribute = "source.lang.swift.attribute.availability"
    }
    public struct SourceLangSwiftCodecomplete {
        public let uid: UID
        /// source.lang.swift.codecomplete.group
        public static let group: SourceLangSwiftCodecomplete = "source.lang.swift.codecomplete.group"
    }
    public struct SourceLangSwiftDecl {
        public let uid: UID
        /// source.lang.swift.decl.associatedtype
        public static let `associatedtype`: SourceLangSwiftDecl = "source.lang.swift.decl.associatedtype"
        /// source.lang.swift.decl.class
        public static let `class`: SourceLangSwiftDecl = "source.lang.swift.decl.class"
        /// source.lang.swift.decl.enum
        public static let `enum`: SourceLangSwiftDecl = "source.lang.swift.decl.enum"
        /// source.lang.swift.decl.enumcase
        public static let enumcase: SourceLangSwiftDecl = "source.lang.swift.decl.enumcase"
        /// source.lang.swift.decl.enumelement
        public static let enumelement: SourceLangSwiftDecl = "source.lang.swift.decl.enumelement"
        /// source.lang.swift.decl.extension
        public static let `extension`: SourceLangSwiftDecl = "source.lang.swift.decl.extension"
        /// source.lang.swift.decl.extension.class
        public static let extensionClass: SourceLangSwiftDecl = "source.lang.swift.decl.extension.class"
        /// source.lang.swift.decl.extension.enum
        public static let extensionEnum: SourceLangSwiftDecl = "source.lang.swift.decl.extension.enum"
        /// source.lang.swift.decl.extension.protocol
        public static let extensionProtocol: SourceLangSwiftDecl = "source.lang.swift.decl.extension.protocol"
        /// source.lang.swift.decl.extension.struct
        public static let extensionStruct: SourceLangSwiftDecl = "source.lang.swift.decl.extension.struct"
        /// source.lang.swift.decl.function.accessor.address
        public static let functionAccessorAddress: SourceLangSwiftDecl = "source.lang.swift.decl.function.accessor.address"
        /// source.lang.swift.decl.function.accessor.didset
        public static let functionAccessorDidset: SourceLangSwiftDecl = "source.lang.swift.decl.function.accessor.didset"
        /// source.lang.swift.decl.function.accessor.getter
        public static let functionAccessorGetter: SourceLangSwiftDecl = "source.lang.swift.decl.function.accessor.getter"
        /// source.lang.swift.decl.function.accessor.mutableaddress
        public static let functionAccessorMutableaddress: SourceLangSwiftDecl = "source.lang.swift.decl.function.accessor.mutableaddress"
        /// source.lang.swift.decl.function.accessor.setter
        public static let functionAccessorSetter: SourceLangSwiftDecl = "source.lang.swift.decl.function.accessor.setter"
        /// source.lang.swift.decl.function.accessor.willset
        public static let functionAccessorWillset: SourceLangSwiftDecl = "source.lang.swift.decl.function.accessor.willset"
        /// source.lang.swift.decl.function.constructor
        public static let functionConstructor: SourceLangSwiftDecl = "source.lang.swift.decl.function.constructor"
        /// source.lang.swift.decl.function.destructor
        public static let functionDestructor: SourceLangSwiftDecl = "source.lang.swift.decl.function.destructor"
        /// source.lang.swift.decl.function.free
        public static let functionFree: SourceLangSwiftDecl = "source.lang.swift.decl.function.free"
        /// source.lang.swift.decl.function.method.class
        public static let functionMethodClass: SourceLangSwiftDecl = "source.lang.swift.decl.function.method.class"
        /// source.lang.swift.decl.function.method.instance
        public static let functionMethodInstance: SourceLangSwiftDecl = "source.lang.swift.decl.function.method.instance"
        /// source.lang.swift.decl.function.method.static
        public static let functionMethodStatic: SourceLangSwiftDecl = "source.lang.swift.decl.function.method.static"
        /// source.lang.swift.decl.function.operator.infix
        public static let functionOperatorInfix: SourceLangSwiftDecl = "source.lang.swift.decl.function.operator.infix"
        /// source.lang.swift.decl.function.operator.postfix
        public static let functionOperatorPostfix: SourceLangSwiftDecl = "source.lang.swift.decl.function.operator.postfix"
        /// source.lang.swift.decl.function.operator.prefix
        public static let functionOperatorPrefix: SourceLangSwiftDecl = "source.lang.swift.decl.function.operator.prefix"
        /// source.lang.swift.decl.function.subscript
        public static let functionSubscript: SourceLangSwiftDecl = "source.lang.swift.decl.function.subscript"
        /// source.lang.swift.decl.generic_type_param
        public static let generic_type_param: SourceLangSwiftDecl = "source.lang.swift.decl.generic_type_param"
        /// source.lang.swift.decl.module
        public static let module: SourceLangSwiftDecl = "source.lang.swift.decl.module"
        /// source.lang.swift.decl.precedencegroup
        public static let `precedencegroup`: SourceLangSwiftDecl = "source.lang.swift.decl.precedencegroup"
        /// source.lang.swift.decl.protocol
        public static let `protocol`: SourceLangSwiftDecl = "source.lang.swift.decl.protocol"
        /// source.lang.swift.decl.struct
        public static let `struct`: SourceLangSwiftDecl = "source.lang.swift.decl.struct"
        /// source.lang.swift.decl.typealias
        public static let `typealias`: SourceLangSwiftDecl = "source.lang.swift.decl.typealias"
        /// source.lang.swift.decl.var.class
        public static let varClass: SourceLangSwiftDecl = "source.lang.swift.decl.var.class"
        /// source.lang.swift.decl.var.global
        public static let varGlobal: SourceLangSwiftDecl = "source.lang.swift.decl.var.global"
        /// source.lang.swift.decl.var.instance
        public static let varInstance: SourceLangSwiftDecl = "source.lang.swift.decl.var.instance"
        /// source.lang.swift.decl.var.local
        public static let varLocal: SourceLangSwiftDecl = "source.lang.swift.decl.var.local"
        /// source.lang.swift.decl.var.parameter
        public static let varParameter: SourceLangSwiftDecl = "source.lang.swift.decl.var.parameter"
        /// source.lang.swift.decl.var.static
        public static let varStatic: SourceLangSwiftDecl = "source.lang.swift.decl.var.static"
    }
    public struct SourceLangSwiftExpr {
        public let uid: UID
        /// source.lang.swift.expr.argument
        public static let argument: SourceLangSwiftExpr = "source.lang.swift.expr.argument"
        /// source.lang.swift.expr.array
        public static let array: SourceLangSwiftExpr = "source.lang.swift.expr.array"
        /// source.lang.swift.expr.call
        public static let call: SourceLangSwiftExpr = "source.lang.swift.expr.call"
        /// source.lang.swift.expr.dictionary
        public static let dictionary: SourceLangSwiftExpr = "source.lang.swift.expr.dictionary"
        /// source.lang.swift.expr.object_literal
        public static let object_literal: SourceLangSwiftExpr = "source.lang.swift.expr.object_literal"
    }
    public struct SourceLangSwiftImportModule {
        public let uid: UID
        /// source.lang.swift.import.module.clang
        public static let clang: SourceLangSwiftImportModule = "source.lang.swift.import.module.clang"
        /// source.lang.swift.import.module.swift
        public static let swift: SourceLangSwiftImportModule = "source.lang.swift.import.module.swift"
    }
    public struct SourceLangSwiftKeyword {
        public let uid: UID
        /// source.lang.swift.keyword.Any
        public static let `Any`: SourceLangSwiftKeyword = "source.lang.swift.keyword.Any"
        /// source.lang.swift.keyword.Self
        public static let `Self`: SourceLangSwiftKeyword = "source.lang.swift.keyword.Self"
        /// source.lang.swift.keyword._
        public static let `_`: SourceLangSwiftKeyword = "source.lang.swift.keyword._"
        /// source.lang.swift.keyword.__COLUMN__
        public static let `__COLUMN__`: SourceLangSwiftKeyword = "source.lang.swift.keyword.__COLUMN__"
        /// source.lang.swift.keyword.__DSO_HANDLE__
        public static let `__DSO_HANDLE__`: SourceLangSwiftKeyword = "source.lang.swift.keyword.__DSO_HANDLE__"
        /// source.lang.swift.keyword.__FILE__
        public static let `__FILE__`: SourceLangSwiftKeyword = "source.lang.swift.keyword.__FILE__"
        /// source.lang.swift.keyword.__FUNCTION__
        public static let `__FUNCTION__`: SourceLangSwiftKeyword = "source.lang.swift.keyword.__FUNCTION__"
        /// source.lang.swift.keyword.__LINE__
        public static let `__LINE__`: SourceLangSwiftKeyword = "source.lang.swift.keyword.__LINE__"
        /// source.lang.swift.keyword.as
        public static let `as`: SourceLangSwiftKeyword = "source.lang.swift.keyword.as"
        /// source.lang.swift.keyword.associatedtype
        public static let `associatedtype`: SourceLangSwiftKeyword = "source.lang.swift.keyword.associatedtype"
        /// source.lang.swift.keyword.break
        public static let `break`: SourceLangSwiftKeyword = "source.lang.swift.keyword.break"
        /// source.lang.swift.keyword.case
        public static let `case`: SourceLangSwiftKeyword = "source.lang.swift.keyword.case"
        /// source.lang.swift.keyword.catch
        public static let `catch`: SourceLangSwiftKeyword = "source.lang.swift.keyword.catch"
        /// source.lang.swift.keyword.class
        public static let `class`: SourceLangSwiftKeyword = "source.lang.swift.keyword.class"
        /// source.lang.swift.keyword.continue
        public static let `continue`: SourceLangSwiftKeyword = "source.lang.swift.keyword.continue"
        /// source.lang.swift.keyword.default
        public static let `default`: SourceLangSwiftKeyword = "source.lang.swift.keyword.default"
        /// source.lang.swift.keyword.defer
        public static let `defer`: SourceLangSwiftKeyword = "source.lang.swift.keyword.defer"
        /// source.lang.swift.keyword.deinit
        public static let `deinit`: SourceLangSwiftKeyword = "source.lang.swift.keyword.deinit"
        /// source.lang.swift.keyword.do
        public static let `do`: SourceLangSwiftKeyword = "source.lang.swift.keyword.do"
        /// source.lang.swift.keyword.else
        public static let `else`: SourceLangSwiftKeyword = "source.lang.swift.keyword.else"
        /// source.lang.swift.keyword.enum
        public static let `enum`: SourceLangSwiftKeyword = "source.lang.swift.keyword.enum"
        /// source.lang.swift.keyword.extension
        public static let `extension`: SourceLangSwiftKeyword = "source.lang.swift.keyword.extension"
        /// source.lang.swift.keyword.fallthrough
        public static let `fallthrough`: SourceLangSwiftKeyword = "source.lang.swift.keyword.fallthrough"
        /// source.lang.swift.keyword.false
        public static let `false`: SourceLangSwiftKeyword = "source.lang.swift.keyword.false"
        /// source.lang.swift.keyword.fileprivate
        public static let `fileprivate`: SourceLangSwiftKeyword = "source.lang.swift.keyword.fileprivate"
        /// source.lang.swift.keyword.for
        public static let `for`: SourceLangSwiftKeyword = "source.lang.swift.keyword.for"
        /// source.lang.swift.keyword.func
        public static let `func`: SourceLangSwiftKeyword = "source.lang.swift.keyword.func"
        /// source.lang.swift.keyword.guard
        public static let `guard`: SourceLangSwiftKeyword = "source.lang.swift.keyword.guard"
        /// source.lang.swift.keyword.if
        public static let `if`: SourceLangSwiftKeyword = "source.lang.swift.keyword.if"
        /// source.lang.swift.keyword.import
        public static let `import`: SourceLangSwiftKeyword = "source.lang.swift.keyword.import"
        /// source.lang.swift.keyword.in
        public static let `in`: SourceLangSwiftKeyword = "source.lang.swift.keyword.in"
        /// source.lang.swift.keyword.init
        public static let `init`: SourceLangSwiftKeyword = "source.lang.swift.keyword.init"
        /// source.lang.swift.keyword.inout
        public static let `inout`: SourceLangSwiftKeyword = "source.lang.swift.keyword.inout"
        /// source.lang.swift.keyword.internal
        public static let `internal`: SourceLangSwiftKeyword = "source.lang.swift.keyword.internal"
        /// source.lang.swift.keyword.is
        public static let `is`: SourceLangSwiftKeyword = "source.lang.swift.keyword.is"
        /// source.lang.swift.keyword.let
        public static let `let`: SourceLangSwiftKeyword = "source.lang.swift.keyword.let"
        /// source.lang.swift.keyword.nil
        public static let `nil`: SourceLangSwiftKeyword = "source.lang.swift.keyword.nil"
        /// source.lang.swift.keyword.operator
        public static let `operator`: SourceLangSwiftKeyword = "source.lang.swift.keyword.operator"
        /// source.lang.swift.keyword.precedencegroup
        public static let `precedencegroup`: SourceLangSwiftKeyword = "source.lang.swift.keyword.precedencegroup"
        /// source.lang.swift.keyword.private
        public static let `private`: SourceLangSwiftKeyword = "source.lang.swift.keyword.private"
        /// source.lang.swift.keyword.protocol
        public static let `protocol`: SourceLangSwiftKeyword = "source.lang.swift.keyword.protocol"
        /// source.lang.swift.keyword.public
        public static let `public`: SourceLangSwiftKeyword = "source.lang.swift.keyword.public"
        /// source.lang.swift.keyword.repeat
        public static let `repeat`: SourceLangSwiftKeyword = "source.lang.swift.keyword.repeat"
        /// source.lang.swift.keyword.rethrows
        public static let `rethrows`: SourceLangSwiftKeyword = "source.lang.swift.keyword.rethrows"
        /// source.lang.swift.keyword.return
        public static let `return`: SourceLangSwiftKeyword = "source.lang.swift.keyword.return"
        /// source.lang.swift.keyword.self
        public static let `self`: SourceLangSwiftKeyword = "source.lang.swift.keyword.self"
        /// source.lang.swift.keyword.static
        public static let `static`: SourceLangSwiftKeyword = "source.lang.swift.keyword.static"
        /// source.lang.swift.keyword.struct
        public static let `struct`: SourceLangSwiftKeyword = "source.lang.swift.keyword.struct"
        /// source.lang.swift.keyword.subscript
        public static let `subscript`: SourceLangSwiftKeyword = "source.lang.swift.keyword.subscript"
        /// source.lang.swift.keyword.super
        public static let `super`: SourceLangSwiftKeyword = "source.lang.swift.keyword.super"
        /// source.lang.swift.keyword.switch
        public static let `switch`: SourceLangSwiftKeyword = "source.lang.swift.keyword.switch"
        /// source.lang.swift.keyword.throw
        public static let `throw`: SourceLangSwiftKeyword = "source.lang.swift.keyword.throw"
        /// source.lang.swift.keyword.throws
        public static let `throws`: SourceLangSwiftKeyword = "source.lang.swift.keyword.throws"
        /// source.lang.swift.keyword.true
        public static let `true`: SourceLangSwiftKeyword = "source.lang.swift.keyword.true"
        /// source.lang.swift.keyword.try
        public static let `try`: SourceLangSwiftKeyword = "source.lang.swift.keyword.try"
        /// source.lang.swift.keyword.typealias
        public static let `typealias`: SourceLangSwiftKeyword = "source.lang.swift.keyword.typealias"
        /// source.lang.swift.keyword.var
        public static let `var`: SourceLangSwiftKeyword = "source.lang.swift.keyword.var"
        /// source.lang.swift.keyword.where
        public static let `where`: SourceLangSwiftKeyword = "source.lang.swift.keyword.where"
        /// source.lang.swift.keyword.while
        public static let `while`: SourceLangSwiftKeyword = "source.lang.swift.keyword.while"
    }
    public struct SourceLangSwiftLiteral {
        public let uid: UID
        /// source.lang.swift.literal.array
        public static let array: SourceLangSwiftLiteral = "source.lang.swift.literal.array"
        /// source.lang.swift.literal.boolean
        public static let boolean: SourceLangSwiftLiteral = "source.lang.swift.literal.boolean"
        /// source.lang.swift.literal.color
        public static let color: SourceLangSwiftLiteral = "source.lang.swift.literal.color"
        /// source.lang.swift.literal.dictionary
        public static let dictionary: SourceLangSwiftLiteral = "source.lang.swift.literal.dictionary"
        /// source.lang.swift.literal.image
        public static let image: SourceLangSwiftLiteral = "source.lang.swift.literal.image"
        /// source.lang.swift.literal.integer
        public static let integer: SourceLangSwiftLiteral = "source.lang.swift.literal.integer"
        /// source.lang.swift.literal.nil
        public static let `nil`: SourceLangSwiftLiteral = "source.lang.swift.literal.nil"
        /// source.lang.swift.literal.string
        public static let string: SourceLangSwiftLiteral = "source.lang.swift.literal.string"
        /// source.lang.swift.literal.tuple
        public static let tuple: SourceLangSwiftLiteral = "source.lang.swift.literal.tuple"
    }
    public struct SourceLangSwiftRef {
        public let uid: UID
        /// source.lang.swift.ref.associatedtype
        public static let `associatedtype`: SourceLangSwiftRef = "source.lang.swift.ref.associatedtype"
        /// source.lang.swift.ref.class
        public static let `class`: SourceLangSwiftRef = "source.lang.swift.ref.class"
        /// source.lang.swift.ref.enum
        public static let `enum`: SourceLangSwiftRef = "source.lang.swift.ref.enum"
        /// source.lang.swift.ref.enumelement
        public static let enumelement: SourceLangSwiftRef = "source.lang.swift.ref.enumelement"
        /// source.lang.swift.ref.function.accessor.address
        public static let functionAccessorAddress: SourceLangSwiftRef = "source.lang.swift.ref.function.accessor.address"
        /// source.lang.swift.ref.function.accessor.didset
        public static let functionAccessorDidset: SourceLangSwiftRef = "source.lang.swift.ref.function.accessor.didset"
        /// source.lang.swift.ref.function.accessor.getter
        public static let functionAccessorGetter: SourceLangSwiftRef = "source.lang.swift.ref.function.accessor.getter"
        /// source.lang.swift.ref.function.accessor.mutableaddress
        public static let functionAccessorMutableaddress: SourceLangSwiftRef = "source.lang.swift.ref.function.accessor.mutableaddress"
        /// source.lang.swift.ref.function.accessor.setter
        public static let functionAccessorSetter: SourceLangSwiftRef = "source.lang.swift.ref.function.accessor.setter"
        /// source.lang.swift.ref.function.accessor.willset
        public static let functionAccessorWillset: SourceLangSwiftRef = "source.lang.swift.ref.function.accessor.willset"
        /// source.lang.swift.ref.function.constructor
        public static let functionConstructor: SourceLangSwiftRef = "source.lang.swift.ref.function.constructor"
        /// source.lang.swift.ref.function.destructor
        public static let functionDestructor: SourceLangSwiftRef = "source.lang.swift.ref.function.destructor"
        /// source.lang.swift.ref.function.free
        public static let functionFree: SourceLangSwiftRef = "source.lang.swift.ref.function.free"
        /// source.lang.swift.ref.function.method.class
        public static let functionMethodClass: SourceLangSwiftRef = "source.lang.swift.ref.function.method.class"
        /// source.lang.swift.ref.function.method.instance
        public static let functionMethodInstance: SourceLangSwiftRef = "source.lang.swift.ref.function.method.instance"
        /// source.lang.swift.ref.function.method.static
        public static let functionMethodStatic: SourceLangSwiftRef = "source.lang.swift.ref.function.method.static"
        /// source.lang.swift.ref.function.operator.infix
        public static let functionOperatorInfix: SourceLangSwiftRef = "source.lang.swift.ref.function.operator.infix"
        /// source.lang.swift.ref.function.operator.postfix
        public static let functionOperatorPostfix: SourceLangSwiftRef = "source.lang.swift.ref.function.operator.postfix"
        /// source.lang.swift.ref.function.operator.prefix
        public static let functionOperatorPrefix: SourceLangSwiftRef = "source.lang.swift.ref.function.operator.prefix"
        /// source.lang.swift.ref.function.subscript
        public static let functionSubscript: SourceLangSwiftRef = "source.lang.swift.ref.function.subscript"
        /// source.lang.swift.ref.generic_type_param
        public static let generic_type_param: SourceLangSwiftRef = "source.lang.swift.ref.generic_type_param"
        /// source.lang.swift.ref.module
        public static let module: SourceLangSwiftRef = "source.lang.swift.ref.module"
        /// source.lang.swift.ref.precedencegroup
        public static let `precedencegroup`: SourceLangSwiftRef = "source.lang.swift.ref.precedencegroup"
        /// source.lang.swift.ref.protocol
        public static let `protocol`: SourceLangSwiftRef = "source.lang.swift.ref.protocol"
        /// source.lang.swift.ref.struct
        public static let `struct`: SourceLangSwiftRef = "source.lang.swift.ref.struct"
        /// source.lang.swift.ref.typealias
        public static let `typealias`: SourceLangSwiftRef = "source.lang.swift.ref.typealias"
        /// source.lang.swift.ref.var.class
        public static let varClass: SourceLangSwiftRef = "source.lang.swift.ref.var.class"
        /// source.lang.swift.ref.var.global
        public static let varGlobal: SourceLangSwiftRef = "source.lang.swift.ref.var.global"
        /// source.lang.swift.ref.var.instance
        public static let varInstance: SourceLangSwiftRef = "source.lang.swift.ref.var.instance"
        /// source.lang.swift.ref.var.local
        public static let varLocal: SourceLangSwiftRef = "source.lang.swift.ref.var.local"
        /// source.lang.swift.ref.var.static
        public static let varStatic: SourceLangSwiftRef = "source.lang.swift.ref.var.static"
    }
    public struct SourceLangSwiftStmt {
        public let uid: UID
        /// source.lang.swift.stmt.brace
        public static let brace: SourceLangSwiftStmt = "source.lang.swift.stmt.brace"
        /// source.lang.swift.stmt.case
        public static let `case`: SourceLangSwiftStmt = "source.lang.swift.stmt.case"
        /// source.lang.swift.stmt.for
        public static let `for`: SourceLangSwiftStmt = "source.lang.swift.stmt.for"
        /// source.lang.swift.stmt.foreach
        public static let foreach: SourceLangSwiftStmt = "source.lang.swift.stmt.foreach"
        /// source.lang.swift.stmt.guard
        public static let `guard`: SourceLangSwiftStmt = "source.lang.swift.stmt.guard"
        /// source.lang.swift.stmt.if
        public static let `if`: SourceLangSwiftStmt = "source.lang.swift.stmt.if"
        /// source.lang.swift.stmt.repeatwhile
        public static let repeatwhile: SourceLangSwiftStmt = "source.lang.swift.stmt.repeatwhile"
        /// source.lang.swift.stmt.switch
        public static let `switch`: SourceLangSwiftStmt = "source.lang.swift.stmt.switch"
        /// source.lang.swift.stmt.while
        public static let `while`: SourceLangSwiftStmt = "source.lang.swift.stmt.while"
    }
    public struct SourceLangSwiftStructureElem {
        public let uid: UID
        /// source.lang.swift.structure.elem.condition_expr
        public static let condition_expr: SourceLangSwiftStructureElem = "source.lang.swift.structure.elem.condition_expr"
        /// source.lang.swift.structure.elem.expr
        public static let expr: SourceLangSwiftStructureElem = "source.lang.swift.structure.elem.expr"
        /// source.lang.swift.structure.elem.id
        public static let id: SourceLangSwiftStructureElem = "source.lang.swift.structure.elem.id"
        /// source.lang.swift.structure.elem.init_expr
        public static let init_expr: SourceLangSwiftStructureElem = "source.lang.swift.structure.elem.init_expr"
        /// source.lang.swift.structure.elem.pattern
        public static let pattern: SourceLangSwiftStructureElem = "source.lang.swift.structure.elem.pattern"
        /// source.lang.swift.structure.elem.typeref
        public static let typeref: SourceLangSwiftStructureElem = "source.lang.swift.structure.elem.typeref"
    }
    public struct SourceLangSwiftSyntaxtype {
        public let uid: UID
        /// source.lang.swift.syntaxtype.argument
        public static let argument: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.argument"
        /// source.lang.swift.syntaxtype.attribute.builtin
        public static let attributeBuiltin: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.attribute.builtin"
        /// source.lang.swift.syntaxtype.attribute.id
        public static let attributeId: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.attribute.id"
        /// source.lang.swift.syntaxtype.buildconfig.id
        public static let buildconfigId: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.buildconfig.id"
        /// source.lang.swift.syntaxtype.buildconfig.keyword
        public static let buildconfigKeyword: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.buildconfig.keyword"
        /// source.lang.swift.syntaxtype.comment
        public static let comment: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.comment"
        /// source.lang.swift.syntaxtype.comment.mark
        public static let commentMark: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.comment.mark"
        /// source.lang.swift.syntaxtype.comment.url
        public static let commentUrl: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.comment.url"
        /// source.lang.swift.syntaxtype.doccomment
        public static let doccomment: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.doccomment"
        /// source.lang.swift.syntaxtype.doccomment.field
        public static let doccommentField: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.doccomment.field"
        /// source.lang.swift.syntaxtype.identifier
        public static let identifier: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.identifier"
        /// source.lang.swift.syntaxtype.keyword
        public static let keyword: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.keyword"
        /// source.lang.swift.syntaxtype.number
        public static let number: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.number"
        /// source.lang.swift.syntaxtype.objectliteral
        public static let objectliteral: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.objectliteral"
        /// source.lang.swift.syntaxtype.parameter
        public static let parameter: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.parameter"
        /// source.lang.swift.syntaxtype.placeholder
        public static let placeholder: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.placeholder"
        /// source.lang.swift.syntaxtype.string
        public static let string: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.string"
        /// source.lang.swift.syntaxtype.string_interpolation_anchor
        public static let string_interpolation_anchor: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.string_interpolation_anchor"
        /// source.lang.swift.syntaxtype.typeidentifier
        public static let typeidentifier: SourceLangSwiftSyntaxtype = "source.lang.swift.syntaxtype.typeidentifier"
    }
    public struct SourceNotification {
        public let uid: UID
        /// source.notification.editor.documentupdate
        public static let editorDocumentupdate: SourceNotification = "source.notification.editor.documentupdate"
        /// source.notification.sema_disabled
        public static let sema_disabled: SourceNotification = "source.notification.sema_disabled"
    }
    public struct SourceRequest {
        public let uid: UID
        /// source.request.buildsettings.register
        public static let buildsettingsRegister: SourceRequest = "source.request.buildsettings.register"
        /// source.request.codecomplete
        public static let codecomplete: SourceRequest = "source.request.codecomplete"
        /// source.request.codecomplete.cache.ondisk
        public static let codecompleteCacheOndisk: SourceRequest = "source.request.codecomplete.cache.ondisk"
        /// source.request.codecomplete.close
        public static let codecompleteClose: SourceRequest = "source.request.codecomplete.close"
        /// source.request.codecomplete.open
        public static let codecompleteOpen: SourceRequest = "source.request.codecomplete.open"
        /// source.request.codecomplete.setcustom
        public static let codecompleteSetcustom: SourceRequest = "source.request.codecomplete.setcustom"
        /// source.request.codecomplete.setpopularapi
        public static let codecompleteSetpopularapi: SourceRequest = "source.request.codecomplete.setpopularapi"
        /// source.request.codecomplete.update
        public static let codecompleteUpdate: SourceRequest = "source.request.codecomplete.update"
        /// source.request.crash_exit
        public static let crash_exit: SourceRequest = "source.request.crash_exit"
        /// source.request.cursorinfo
        public static let cursorinfo: SourceRequest = "source.request.cursorinfo"
        /// source.request.demangle
        public static let demangle: SourceRequest = "source.request.demangle"
        /// source.request.docinfo
        public static let docinfo: SourceRequest = "source.request.docinfo"
        /// source.request.editor.close
        public static let editorClose: SourceRequest = "source.request.editor.close"
        /// source.request.editor.expand_placeholder
        public static let editorExpand_Placeholder: SourceRequest = "source.request.editor.expand_placeholder"
        /// source.request.editor.extract.comment
        public static let editorExtractComment: SourceRequest = "source.request.editor.extract.comment"
        /// source.request.editor.find_interface_doc
        public static let editorFind_Interface_Doc: SourceRequest = "source.request.editor.find_interface_doc"
        /// source.request.editor.find_usr
        public static let editorFind_Usr: SourceRequest = "source.request.editor.find_usr"
        /// source.request.editor.formattext
        public static let editorFormattext: SourceRequest = "source.request.editor.formattext"
        /// source.request.editor.open
        public static let editorOpen: SourceRequest = "source.request.editor.open"
        /// source.request.editor.open.interface
        public static let editorOpenInterface: SourceRequest = "source.request.editor.open.interface"
        /// source.request.editor.open.interface.header
        public static let editorOpenInterfaceHeader: SourceRequest = "source.request.editor.open.interface.header"
        /// source.request.editor.open.interface.swiftsource
        public static let editorOpenInterfaceSwiftsource: SourceRequest = "source.request.editor.open.interface.swiftsource"
        /// source.request.editor.open.interface.swifttype
        public static let editorOpenInterfaceSwifttype: SourceRequest = "source.request.editor.open.interface.swifttype"
        /// source.request.editor.replacetext
        public static let editorReplacetext: SourceRequest = "source.request.editor.replacetext"
        /// source.request.indexsource
        public static let indexsource: SourceRequest = "source.request.indexsource"
        /// source.request.mangle_simple_class
        public static let mangle_simple_class: SourceRequest = "source.request.mangle_simple_class"
        /// source.request.module.groups
        public static let moduleGroups: SourceRequest = "source.request.module.groups"
        /// source.request.protocol_version
        public static let protocol_version: SourceRequest = "source.request.protocol_version"
        /// source.request.relatedidents
        public static let relatedidents: SourceRequest = "source.request.relatedidents"
    }
}

extension UID.Key: UIDNamespace {
    public static let __uid_prefix = "key"
    public static func ==(lhs: UID.Key, rhs: UID.Key) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.Key, rhs: UID.Key) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.Key) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.Key) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.Key, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.Key, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.Key) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.Key) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.Key, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.Key, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceAvailabilityPlatform: UIDNamespace {
    public static let __uid_prefix = "source.availability.platform"
    public static func ==(lhs: UID.SourceAvailabilityPlatform, rhs: UID.SourceAvailabilityPlatform) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceAvailabilityPlatform, rhs: UID.SourceAvailabilityPlatform) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceAvailabilityPlatform) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceAvailabilityPlatform) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceAvailabilityPlatform, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceAvailabilityPlatform, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceAvailabilityPlatform) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceAvailabilityPlatform) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceAvailabilityPlatform, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceAvailabilityPlatform, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceCodecompletion: UIDNamespace {
    public static let __uid_prefix = "source.codecompletion"
    public static func ==(lhs: UID.SourceCodecompletion, rhs: UID.SourceCodecompletion) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceCodecompletion, rhs: UID.SourceCodecompletion) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceCodecompletion) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceCodecompletion) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceCodecompletion, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceCodecompletion, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceCodecompletion) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceCodecompletion) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceCodecompletion, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceCodecompletion, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceDeclAttribute: UIDNamespace {
    public static let __uid_prefix = "source.decl.attribute"
    public static func ==(lhs: UID.SourceDeclAttribute, rhs: UID.SourceDeclAttribute) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceDeclAttribute, rhs: UID.SourceDeclAttribute) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceDeclAttribute) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceDeclAttribute) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceDeclAttribute, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceDeclAttribute, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceDeclAttribute) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceDeclAttribute) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceDeclAttribute, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceDeclAttribute, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceDiagnosticSeverity: UIDNamespace {
    public static let __uid_prefix = "source.diagnostic.severity"
    public static func ==(lhs: UID.SourceDiagnosticSeverity, rhs: UID.SourceDiagnosticSeverity) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceDiagnosticSeverity, rhs: UID.SourceDiagnosticSeverity) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceDiagnosticSeverity) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceDiagnosticSeverity) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceDiagnosticSeverity, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceDiagnosticSeverity, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceDiagnosticSeverity) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceDiagnosticSeverity) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceDiagnosticSeverity, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceDiagnosticSeverity, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceDiagnosticStageSwift: UIDNamespace {
    public static let __uid_prefix = "source.diagnostic.stage.swift"
    public static func ==(lhs: UID.SourceDiagnosticStageSwift, rhs: UID.SourceDiagnosticStageSwift) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceDiagnosticStageSwift, rhs: UID.SourceDiagnosticStageSwift) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceDiagnosticStageSwift) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceDiagnosticStageSwift) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceDiagnosticStageSwift, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceDiagnosticStageSwift, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceDiagnosticStageSwift) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceDiagnosticStageSwift) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceDiagnosticStageSwift, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceDiagnosticStageSwift, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwift: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift"
    public static func ==(lhs: UID.SourceLangSwift, rhs: UID.SourceLangSwift) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwift, rhs: UID.SourceLangSwift) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwift) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwift) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwift, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwift, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwift) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwift) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwift, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwift, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftAccessibility: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.accessibility"
    public static func ==(lhs: UID.SourceLangSwiftAccessibility, rhs: UID.SourceLangSwiftAccessibility) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftAccessibility, rhs: UID.SourceLangSwiftAccessibility) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftAccessibility) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftAccessibility) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftAccessibility, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftAccessibility, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftAccessibility) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftAccessibility) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftAccessibility, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftAccessibility, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftAttribute: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.attribute"
    public static func ==(lhs: UID.SourceLangSwiftAttribute, rhs: UID.SourceLangSwiftAttribute) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftAttribute, rhs: UID.SourceLangSwiftAttribute) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftAttribute) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftAttribute) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftAttribute, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftAttribute, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftAttribute) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftAttribute) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftAttribute, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftAttribute, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftCodecomplete: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.codecomplete"
    public static func ==(lhs: UID.SourceLangSwiftCodecomplete, rhs: UID.SourceLangSwiftCodecomplete) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftCodecomplete, rhs: UID.SourceLangSwiftCodecomplete) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftCodecomplete) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftCodecomplete) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftCodecomplete, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftCodecomplete, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftCodecomplete) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftCodecomplete) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftCodecomplete, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftCodecomplete, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftDecl: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.decl"
    public static func ==(lhs: UID.SourceLangSwiftDecl, rhs: UID.SourceLangSwiftDecl) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftDecl, rhs: UID.SourceLangSwiftDecl) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftDecl) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftDecl) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftDecl, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftDecl, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftDecl) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftDecl) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftDecl, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftDecl, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftExpr: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.expr"
    public static func ==(lhs: UID.SourceLangSwiftExpr, rhs: UID.SourceLangSwiftExpr) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftExpr, rhs: UID.SourceLangSwiftExpr) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftExpr) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftExpr) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftExpr, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftExpr, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftExpr) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftExpr) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftExpr, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftExpr, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftImportModule: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.import.module"
    public static func ==(lhs: UID.SourceLangSwiftImportModule, rhs: UID.SourceLangSwiftImportModule) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftImportModule, rhs: UID.SourceLangSwiftImportModule) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftImportModule) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftImportModule) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftImportModule, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftImportModule, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftImportModule) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftImportModule) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftImportModule, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftImportModule, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftKeyword: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.keyword"
    public static func ==(lhs: UID.SourceLangSwiftKeyword, rhs: UID.SourceLangSwiftKeyword) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftKeyword, rhs: UID.SourceLangSwiftKeyword) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftKeyword) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftKeyword) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftKeyword, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftKeyword, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftKeyword) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftKeyword) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftKeyword, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftKeyword, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftLiteral: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.literal"
    public static func ==(lhs: UID.SourceLangSwiftLiteral, rhs: UID.SourceLangSwiftLiteral) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftLiteral, rhs: UID.SourceLangSwiftLiteral) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftLiteral) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftLiteral) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftLiteral, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftLiteral, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftLiteral) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftLiteral) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftLiteral, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftLiteral, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftRef: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.ref"
    public static func ==(lhs: UID.SourceLangSwiftRef, rhs: UID.SourceLangSwiftRef) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftRef, rhs: UID.SourceLangSwiftRef) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftRef) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftRef) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftRef, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftRef, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftRef) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftRef) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftRef, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftRef, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftStmt: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.stmt"
    public static func ==(lhs: UID.SourceLangSwiftStmt, rhs: UID.SourceLangSwiftStmt) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftStmt, rhs: UID.SourceLangSwiftStmt) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftStmt) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftStmt) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftStmt, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftStmt, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftStmt) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftStmt) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftStmt, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftStmt, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftStructureElem: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.structure.elem"
    public static func ==(lhs: UID.SourceLangSwiftStructureElem, rhs: UID.SourceLangSwiftStructureElem) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftStructureElem, rhs: UID.SourceLangSwiftStructureElem) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftStructureElem) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftStructureElem) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftStructureElem, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftStructureElem, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftStructureElem) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftStructureElem) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftStructureElem, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftStructureElem, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceLangSwiftSyntaxtype: UIDNamespace {
    public static let __uid_prefix = "source.lang.swift.syntaxtype"
    public static func ==(lhs: UID.SourceLangSwiftSyntaxtype, rhs: UID.SourceLangSwiftSyntaxtype) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceLangSwiftSyntaxtype, rhs: UID.SourceLangSwiftSyntaxtype) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceLangSwiftSyntaxtype) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceLangSwiftSyntaxtype) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceLangSwiftSyntaxtype, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceLangSwiftSyntaxtype, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceLangSwiftSyntaxtype) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceLangSwiftSyntaxtype) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceLangSwiftSyntaxtype, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceLangSwiftSyntaxtype, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceNotification: UIDNamespace {
    public static let __uid_prefix = "source.notification"
    public static func ==(lhs: UID.SourceNotification, rhs: UID.SourceNotification) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceNotification, rhs: UID.SourceNotification) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceNotification) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceNotification) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceNotification, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceNotification, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceNotification) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceNotification) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceNotification, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceNotification, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.SourceRequest: UIDNamespace {
    public static let __uid_prefix = "source.request"
    public static func ==(lhs: UID.SourceRequest, rhs: UID.SourceRequest) -> Bool { return lhs.uid == rhs.uid }
    public static func !=(lhs: UID.SourceRequest, rhs: UID.SourceRequest) -> Bool { return lhs.uid != rhs.uid }
    public static func ==(lhs: UID, rhs: UID.SourceRequest) -> Bool { return lhs == rhs.uid }
    public static func !=(lhs: UID, rhs: UID.SourceRequest) -> Bool { return lhs != rhs.uid }
    public static func ==(lhs: UID.SourceRequest, rhs: UID) -> Bool { return lhs.uid == rhs }
    public static func !=(lhs: UID.SourceRequest, rhs: UID) -> Bool { return lhs.uid != rhs }
    public static func ==(lhs: UID?, rhs: UID.SourceRequest) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func !=(lhs: UID?, rhs: UID.SourceRequest) -> Bool { return lhs.map { $0 != rhs.uid } ?? true }
    public static func ==(lhs: UID.SourceRequest, rhs: UID?) -> Bool { return rhs.map { lhs.uid == $0 } ?? false }
    public static func !=(lhs: UID.SourceRequest, rhs: UID?) -> Bool { return rhs.map { lhs.uid != $0 } ?? true }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
#if DEBUG
let knownUIDs = [
    UID("key.accessibility"),
    UID("key.annotated_decl"),
    UID("key.annotations"),
    UID("key.associated_usrs"),
    UID("key.attribute"),
    UID("key.attributes"),
    UID("key.bodylength"),
    UID("key.bodyoffset"),
    UID("key.codecomplete.addinitstotoplevel"),
    UID("key.codecomplete.addinneroperators"),
    UID("key.codecomplete.addinnerresults"),
    UID("key.codecomplete.filterrules"),
    UID("key.codecomplete.filtertext"),
    UID("key.codecomplete.fuzzymatching"),
    UID("key.codecomplete.group.overloads"),
    UID("key.codecomplete.group.stems"),
    UID("key.codecomplete.hidebyname"),
    UID("key.codecomplete.hidelowpriority"),
    UID("key.codecomplete.hideunderscores"),
    UID("key.codecomplete.includeexactmatch"),
    UID("key.codecomplete.options"),
    UID("key.codecomplete.requestlimit"),
    UID("key.codecomplete.requeststart"),
    UID("key.codecomplete.showtopnonliteralresults"),
    UID("key.codecomplete.sort.byname"),
    UID("key.codecomplete.sort.contextweight"),
    UID("key.codecomplete.sort.fuzzyweight"),
    UID("key.codecomplete.sort.popularitybonus"),
    UID("key.codecomplete.sort.useimportdepth"),
    UID("key.column"),
    UID("key.compilerargs"),
    UID("key.conforms"),
    UID("key.containertypeusr"),
    UID("key.context"),
    UID("key.default_implementation_of"),
    UID("key.dependencies"),
    UID("key.deprecated"),
    UID("key.description"),
    UID("key.diagnostic_stage"),
    UID("key.diagnostics"),
    UID("key.doc.brief"),
    UID("key.doc.full_as_xml"),
    UID("key.duration"),
    UID("key.editor.format.indentwidth"),
    UID("key.editor.format.options"),
    UID("key.editor.format.tabwidth"),
    UID("key.editor.format.usetabs"),
    UID("key.elements"),
    UID("key.enablediagnostics"),
    UID("key.enablesubstructure"),
    UID("key.enablesyntaxmap"),
    UID("key.entities"),
    UID("key.extends"),
    UID("key.filepath"),
    UID("key.fixits"),
    UID("key.fully_annotated_decl"),
    UID("key.generic_params"),
    UID("key.generic_requirements"),
    UID("key.groupname"),
    UID("key.hash"),
    UID("key.hide"),
    UID("key.inheritedtypes"),
    UID("key.inherits"),
    UID("key.interested_usr"),
    UID("key.introduced"),
    UID("key.is_deprecated"),
    UID("key.is_dynamic"),
    UID("key.is_local"),
    UID("key.is_optional"),
    UID("key.is_system"),
    UID("key.is_test_candidate"),
    UID("key.is_unavailable"),
    UID("key.keyword"),
    UID("key.kind"),
    UID("key.length"),
    UID("key.line"),
    UID("key.message"),
    UID("key.module_interface_name"),
    UID("key.modulegroups"),
    UID("key.moduleimportdepth"),
    UID("key.modulename"),
    UID("key.name"),
    UID("key.namelength"),
    UID("key.nameoffset"),
    UID("key.names"),
    UID("key.nextrequeststart"),
    UID("key.not_recommended"),
    UID("key.notification"),
    UID("key.num_bytes_to_erase"),
    UID("key.obsoleted"),
    UID("key.offset"),
    UID("key.original_usr"),
    UID("key.overrides"),
    UID("key.platform"),
    UID("key.popular"),
    UID("key.ranges"),
    UID("key.receiver_usr"),
    UID("key.related"),
    UID("key.related_decls"),
    UID("key.removecache"),
    UID("key.request"),
    UID("key.results"),
    UID("key.runtime_name"),
    UID("key.selector_name"),
    UID("key.setter_accessibility"),
    UID("key.severity"),
    UID("key.simplified"),
    UID("key.sourcefile"),
    UID("key.sourcetext"),
    UID("key.substructure"),
    UID("key.syntactic_only"),
    UID("key.syntaxmap"),
    UID("key.synthesizedextensions"),
    UID("key.throwlength"),
    UID("key.throwoffset"),
    UID("key.typeinterface"),
    UID("key.typename"),
    UID("key.typeusr"),
    UID("key.uids"),
    UID("key.unpopular"),
    UID("key.usr"),
    UID("key.version_major"),
    UID("key.version_minor"),
    UID("source.availability.platform.ios"),
    UID("source.availability.platform.ios_app_extension"),
    UID("source.availability.platform.osx"),
    UID("source.availability.platform.osx_app_extension"),
    UID("source.availability.platform.tvos"),
    UID("source.availability.platform.tvos_app_extension"),
    UID("source.availability.platform.watchos"),
    UID("source.availability.platform.watchos_app_extension"),
    UID("source.codecompletion.context.exprspecific"),
    UID("source.codecompletion.context.local"),
    UID("source.codecompletion.context.none"),
    UID("source.codecompletion.context.otherclass"),
    UID("source.codecompletion.context.othermodule"),
    UID("source.codecompletion.context.superclass"),
    UID("source.codecompletion.context.thisclass"),
    UID("source.codecompletion.context.thismodule"),
    UID("source.codecompletion.custom"),
    UID("source.codecompletion.everything"),
    UID("source.codecompletion.identifier"),
    UID("source.codecompletion.keyword"),
    UID("source.codecompletion.literal"),
    UID("source.codecompletion.module"),
    UID("source.decl.attribute.LLDBDebuggerFunction"),
    UID("source.decl.attribute.NSApplicationMain"),
    UID("source.decl.attribute.NSCopying"),
    UID("source.decl.attribute.NSManaged"),
    UID("source.decl.attribute.UIApplicationMain"),
    UID("source.decl.attribute.__objc_bridged"),
    UID("source.decl.attribute.__synthesized_protocol"),
    UID("source.decl.attribute._alignment"),
    UID("source.decl.attribute._cdecl"),
    UID("source.decl.attribute._exported"),
    UID("source.decl.attribute._fixed_layout"),
    UID("source.decl.attribute._semantics"),
    UID("source.decl.attribute._silgen_name"),
    UID("source.decl.attribute._specialize"),
    UID("source.decl.attribute._swift_native_objc_runtime_base"),
    UID("source.decl.attribute._transparent"),
    UID("source.decl.attribute._versioned"),
    UID("source.decl.attribute.autoclosure"),
    UID("source.decl.attribute.available"),
    UID("source.decl.attribute.convenience"),
    UID("source.decl.attribute.discardableResult"),
    UID("source.decl.attribute.dynamic"),
    UID("source.decl.attribute.effects"),
    UID("source.decl.attribute.escaping"),
    UID("source.decl.attribute.final"),
    UID("source.decl.attribute.gkinspectable"),
    UID("source.decl.attribute.ibaction"),
    UID("source.decl.attribute.ibdesignable"),
    UID("source.decl.attribute.ibinspectable"),
    UID("source.decl.attribute.iboutlet"),
    UID("source.decl.attribute.indirect"),
    UID("source.decl.attribute.infix"),
    UID("source.decl.attribute.inline"),
    UID("source.decl.attribute.lazy"),
    UID("source.decl.attribute.mutating"),
    UID("source.decl.attribute.noescape"),
    UID("source.decl.attribute.nonmutating"),
    UID("source.decl.attribute.nonobjc"),
    UID("source.decl.attribute.noreturn"),
    UID("source.decl.attribute.objc"),
    UID("source.decl.attribute.objc.name"),
    UID("source.decl.attribute.objc_non_lazy_realization"),
    UID("source.decl.attribute.optional"),
    UID("source.decl.attribute.override"),
    UID("source.decl.attribute.postfix"),
    UID("source.decl.attribute.prefix"),
    UID("source.decl.attribute.required"),
    UID("source.decl.attribute.requires_stored_property_inits"),
    UID("source.decl.attribute.rethrows"),
    UID("source.decl.attribute.sil_stored"),
    UID("source.decl.attribute.swift3_migration"),
    UID("source.decl.attribute.testable"),
    UID("source.decl.attribute.unsafe_no_objc_tagged_pointer"),
    UID("source.decl.attribute.warn_unqualified_access"),
    UID("source.decl.attribute.weak"),
    UID("source.diagnostic.severity.error"),
    UID("source.diagnostic.severity.note"),
    UID("source.diagnostic.severity.warning"),
    UID("source.diagnostic.stage.swift.parse"),
    UID("source.diagnostic.stage.swift.sema"),
    UID("source.lang.swift.accessibility.fileprivate"),
    UID("source.lang.swift.accessibility.internal"),
    UID("source.lang.swift.accessibility.open"),
    UID("source.lang.swift.accessibility.private"),
    UID("source.lang.swift.accessibility.public"),
    UID("source.lang.swift.attribute.availability"),
    UID("source.lang.swift.codecomplete.group"),
    UID("source.lang.swift.decl.associatedtype"),
    UID("source.lang.swift.decl.class"),
    UID("source.lang.swift.decl.enum"),
    UID("source.lang.swift.decl.enumcase"),
    UID("source.lang.swift.decl.enumelement"),
    UID("source.lang.swift.decl.extension"),
    UID("source.lang.swift.decl.extension.class"),
    UID("source.lang.swift.decl.extension.enum"),
    UID("source.lang.swift.decl.extension.protocol"),
    UID("source.lang.swift.decl.extension.struct"),
    UID("source.lang.swift.decl.function.accessor.address"),
    UID("source.lang.swift.decl.function.accessor.didset"),
    UID("source.lang.swift.decl.function.accessor.getter"),
    UID("source.lang.swift.decl.function.accessor.mutableaddress"),
    UID("source.lang.swift.decl.function.accessor.setter"),
    UID("source.lang.swift.decl.function.accessor.willset"),
    UID("source.lang.swift.decl.function.constructor"),
    UID("source.lang.swift.decl.function.destructor"),
    UID("source.lang.swift.decl.function.free"),
    UID("source.lang.swift.decl.function.method.class"),
    UID("source.lang.swift.decl.function.method.instance"),
    UID("source.lang.swift.decl.function.method.static"),
    UID("source.lang.swift.decl.function.operator.infix"),
    UID("source.lang.swift.decl.function.operator.postfix"),
    UID("source.lang.swift.decl.function.operator.prefix"),
    UID("source.lang.swift.decl.function.subscript"),
    UID("source.lang.swift.decl.generic_type_param"),
    UID("source.lang.swift.decl.module"),
    UID("source.lang.swift.decl.precedencegroup"),
    UID("source.lang.swift.decl.protocol"),
    UID("source.lang.swift.decl.struct"),
    UID("source.lang.swift.decl.typealias"),
    UID("source.lang.swift.decl.var.class"),
    UID("source.lang.swift.decl.var.global"),
    UID("source.lang.swift.decl.var.instance"),
    UID("source.lang.swift.decl.var.local"),
    UID("source.lang.swift.decl.var.parameter"),
    UID("source.lang.swift.decl.var.static"),
    UID("source.lang.swift.expr"),
    UID("source.lang.swift.expr.argument"),
    UID("source.lang.swift.expr.array"),
    UID("source.lang.swift.expr.call"),
    UID("source.lang.swift.expr.dictionary"),
    UID("source.lang.swift.expr.object_literal"),
    UID("source.lang.swift.import.module.clang"),
    UID("source.lang.swift.import.module.swift"),
    UID("source.lang.swift.keyword"),
    UID("source.lang.swift.keyword.Any"),
    UID("source.lang.swift.keyword.Self"),
    UID("source.lang.swift.keyword._"),
    UID("source.lang.swift.keyword.__COLUMN__"),
    UID("source.lang.swift.keyword.__DSO_HANDLE__"),
    UID("source.lang.swift.keyword.__FILE__"),
    UID("source.lang.swift.keyword.__FUNCTION__"),
    UID("source.lang.swift.keyword.__LINE__"),
    UID("source.lang.swift.keyword.as"),
    UID("source.lang.swift.keyword.associatedtype"),
    UID("source.lang.swift.keyword.break"),
    UID("source.lang.swift.keyword.case"),
    UID("source.lang.swift.keyword.catch"),
    UID("source.lang.swift.keyword.class"),
    UID("source.lang.swift.keyword.continue"),
    UID("source.lang.swift.keyword.default"),
    UID("source.lang.swift.keyword.defer"),
    UID("source.lang.swift.keyword.deinit"),
    UID("source.lang.swift.keyword.do"),
    UID("source.lang.swift.keyword.else"),
    UID("source.lang.swift.keyword.enum"),
    UID("source.lang.swift.keyword.extension"),
    UID("source.lang.swift.keyword.fallthrough"),
    UID("source.lang.swift.keyword.false"),
    UID("source.lang.swift.keyword.fileprivate"),
    UID("source.lang.swift.keyword.for"),
    UID("source.lang.swift.keyword.func"),
    UID("source.lang.swift.keyword.guard"),
    UID("source.lang.swift.keyword.if"),
    UID("source.lang.swift.keyword.import"),
    UID("source.lang.swift.keyword.in"),
    UID("source.lang.swift.keyword.init"),
    UID("source.lang.swift.keyword.inout"),
    UID("source.lang.swift.keyword.internal"),
    UID("source.lang.swift.keyword.is"),
    UID("source.lang.swift.keyword.let"),
    UID("source.lang.swift.keyword.nil"),
    UID("source.lang.swift.keyword.operator"),
    UID("source.lang.swift.keyword.precedencegroup"),
    UID("source.lang.swift.keyword.private"),
    UID("source.lang.swift.keyword.protocol"),
    UID("source.lang.swift.keyword.public"),
    UID("source.lang.swift.keyword.repeat"),
    UID("source.lang.swift.keyword.rethrows"),
    UID("source.lang.swift.keyword.return"),
    UID("source.lang.swift.keyword.self"),
    UID("source.lang.swift.keyword.static"),
    UID("source.lang.swift.keyword.struct"),
    UID("source.lang.swift.keyword.subscript"),
    UID("source.lang.swift.keyword.super"),
    UID("source.lang.swift.keyword.switch"),
    UID("source.lang.swift.keyword.throw"),
    UID("source.lang.swift.keyword.throws"),
    UID("source.lang.swift.keyword.true"),
    UID("source.lang.swift.keyword.try"),
    UID("source.lang.swift.keyword.typealias"),
    UID("source.lang.swift.keyword.var"),
    UID("source.lang.swift.keyword.where"),
    UID("source.lang.swift.keyword.while"),
    UID("source.lang.swift.literal.array"),
    UID("source.lang.swift.literal.boolean"),
    UID("source.lang.swift.literal.color"),
    UID("source.lang.swift.literal.dictionary"),
    UID("source.lang.swift.literal.image"),
    UID("source.lang.swift.literal.integer"),
    UID("source.lang.swift.literal.nil"),
    UID("source.lang.swift.literal.string"),
    UID("source.lang.swift.literal.tuple"),
    UID("source.lang.swift.pattern"),
    UID("source.lang.swift.ref.associatedtype"),
    UID("source.lang.swift.ref.class"),
    UID("source.lang.swift.ref.enum"),
    UID("source.lang.swift.ref.enumelement"),
    UID("source.lang.swift.ref.function.accessor.address"),
    UID("source.lang.swift.ref.function.accessor.didset"),
    UID("source.lang.swift.ref.function.accessor.getter"),
    UID("source.lang.swift.ref.function.accessor.mutableaddress"),
    UID("source.lang.swift.ref.function.accessor.setter"),
    UID("source.lang.swift.ref.function.accessor.willset"),
    UID("source.lang.swift.ref.function.constructor"),
    UID("source.lang.swift.ref.function.destructor"),
    UID("source.lang.swift.ref.function.free"),
    UID("source.lang.swift.ref.function.method.class"),
    UID("source.lang.swift.ref.function.method.instance"),
    UID("source.lang.swift.ref.function.method.static"),
    UID("source.lang.swift.ref.function.operator.infix"),
    UID("source.lang.swift.ref.function.operator.postfix"),
    UID("source.lang.swift.ref.function.operator.prefix"),
    UID("source.lang.swift.ref.function.subscript"),
    UID("source.lang.swift.ref.generic_type_param"),
    UID("source.lang.swift.ref.module"),
    UID("source.lang.swift.ref.precedencegroup"),
    UID("source.lang.swift.ref.protocol"),
    UID("source.lang.swift.ref.struct"),
    UID("source.lang.swift.ref.typealias"),
    UID("source.lang.swift.ref.var.class"),
    UID("source.lang.swift.ref.var.global"),
    UID("source.lang.swift.ref.var.instance"),
    UID("source.lang.swift.ref.var.local"),
    UID("source.lang.swift.ref.var.static"),
    UID("source.lang.swift.stmt"),
    UID("source.lang.swift.stmt.brace"),
    UID("source.lang.swift.stmt.case"),
    UID("source.lang.swift.stmt.for"),
    UID("source.lang.swift.stmt.foreach"),
    UID("source.lang.swift.stmt.guard"),
    UID("source.lang.swift.stmt.if"),
    UID("source.lang.swift.stmt.repeatwhile"),
    UID("source.lang.swift.stmt.switch"),
    UID("source.lang.swift.stmt.while"),
    UID("source.lang.swift.structure.elem.condition_expr"),
    UID("source.lang.swift.structure.elem.expr"),
    UID("source.lang.swift.structure.elem.id"),
    UID("source.lang.swift.structure.elem.init_expr"),
    UID("source.lang.swift.structure.elem.pattern"),
    UID("source.lang.swift.structure.elem.typeref"),
    UID("source.lang.swift.syntaxtype.argument"),
    UID("source.lang.swift.syntaxtype.attribute.builtin"),
    UID("source.lang.swift.syntaxtype.attribute.id"),
    UID("source.lang.swift.syntaxtype.buildconfig.id"),
    UID("source.lang.swift.syntaxtype.buildconfig.keyword"),
    UID("source.lang.swift.syntaxtype.comment"),
    UID("source.lang.swift.syntaxtype.comment.mark"),
    UID("source.lang.swift.syntaxtype.comment.url"),
    UID("source.lang.swift.syntaxtype.doccomment"),
    UID("source.lang.swift.syntaxtype.doccomment.field"),
    UID("source.lang.swift.syntaxtype.identifier"),
    UID("source.lang.swift.syntaxtype.keyword"),
    UID("source.lang.swift.syntaxtype.number"),
    UID("source.lang.swift.syntaxtype.objectliteral"),
    UID("source.lang.swift.syntaxtype.parameter"),
    UID("source.lang.swift.syntaxtype.placeholder"),
    UID("source.lang.swift.syntaxtype.string"),
    UID("source.lang.swift.syntaxtype.string_interpolation_anchor"),
    UID("source.lang.swift.syntaxtype.typeidentifier"),
    UID("source.lang.swift.type"),
    UID("source.notification.editor.documentupdate"),
    UID("source.notification.sema_disabled"),
    UID("source.request.buildsettings.register"),
    UID("source.request.codecomplete"),
    UID("source.request.codecomplete.cache.ondisk"),
    UID("source.request.codecomplete.close"),
    UID("source.request.codecomplete.open"),
    UID("source.request.codecomplete.setcustom"),
    UID("source.request.codecomplete.setpopularapi"),
    UID("source.request.codecomplete.update"),
    UID("source.request.crash_exit"),
    UID("source.request.cursorinfo"),
    UID("source.request.demangle"),
    UID("source.request.docinfo"),
    UID("source.request.editor.close"),
    UID("source.request.editor.expand_placeholder"),
    UID("source.request.editor.extract.comment"),
    UID("source.request.editor.find_interface_doc"),
    UID("source.request.editor.find_usr"),
    UID("source.request.editor.formattext"),
    UID("source.request.editor.open"),
    UID("source.request.editor.open.interface"),
    UID("source.request.editor.open.interface.header"),
    UID("source.request.editor.open.interface.swiftsource"),
    UID("source.request.editor.open.interface.swifttype"),
    UID("source.request.editor.replacetext"),
    UID("source.request.indexsource"),
    UID("source.request.mangle_simple_class"),
    UID("source.request.module.groups"),
    UID("source.request.protocol_version"),
    UID("source.request.relatedidents"),
]
#endif
