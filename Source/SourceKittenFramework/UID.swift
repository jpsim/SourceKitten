// Generated using Sourcery 0.9.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Swift

public struct UID {

    public enum Key: CustomStringConvertible {
        /// key.version_major
        case versionMajor
        /// key.version_minor
        case versionMinor
        /// key.results
        case results
        /// key.request
        case request
        /// key.notification
        case notification
        /// key.kind
        case kind
        /// key.accessibility
        case accessLevel
        /// key.setter_accessibility
        case setterAccessLevel
        /// key.keyword
        case keyword
        /// key.name
        case name
        /// key.usr
        case usr
        /// key.original_usr
        case originalUSR
        /// key.default_implementation_of
        case defaultImplementationOf
        /// key.interested_usr
        case interestedUSR
        /// key.generic_params
        case genericParams
        /// key.generic_requirements
        case genericRequirements
        /// key.doc.full_as_xml
        case docFullAsXML
        /// key.line
        case line
        /// key.column
        case column
        /// key.receiver_usr
        case receiverUSR
        /// key.is_dynamic
        case isDynamic
        /// key.filepath
        case filePath
        /// key.module_interface_name
        case moduleInterfaceName
        /// key.hash
        case hash
        /// key.compilerargs
        case compilerArgs
        /// key.severity
        case severity
        /// key.offset
        case offset
        /// key.length
        case length
        /// key.sourcefile
        case sourceFile
        /// key.sourcetext
        case sourceText
        /// key.enablesyntaxmap
        case enableSyntaxMap
        /// key.enablesubstructure
        case enableStructure
        /// key.description
        case description
        /// key.typename
        case typeName
        /// key.runtime_name
        case runtimeName
        /// key.selector_name
        case selectorName
        /// key.annotated_decl
        case annotatedDecl
        /// key.fully_annotated_decl
        case fullyAnnotatedDecl
        /// key.doc.brief
        case docBrief
        /// key.context
        case context
        /// key.moduleimportdepth
        case moduleImportDepth
        /// key.num_bytes_to_erase
        case numBytesToErase
        /// key.not_recommended
        case notRecommended
        /// key.annotations
        case annotations
        /// key.diagnostic_stage
        case diagnosticStage
        /// key.syntaxmap
        case syntaxMap
        /// key.is_system
        case isSystem
        /// key.related
        case related
        /// key.inherits
        case inherits
        /// key.conforms
        case conforms
        /// key.extends
        case extends
        /// key.dependencies
        case dependencies
        /// key.entities
        case entities
        /// key.nameoffset
        case nameOffset
        /// key.namelength
        case nameLength
        /// key.bodyoffset
        case bodyOffset
        /// key.bodylength
        case bodyLength
        /// key.throwoffset
        case throwOffset
        /// key.throwlength
        case throwLength
        /// key.docoffset
        case docOffset
        /// key.doclength
        case docLength
        /// key.is_local
        case isLocal
        /// key.inheritedtypes
        case inheritedTypes
        /// key.attributes
        case attributes
        /// key.attribute
        case attribute
        /// key.elements
        case elements
        /// key.substructure
        case subStructure
        /// key.ranges
        case ranges
        /// key.fixits
        case fixits
        /// key.diagnostics
        case diagnostics
        /// key.editor.format.options
        case formatOptions
        /// key.codecomplete.options
        case codeCompleteOptions
        /// key.codecomplete.filterrules
        case filterRules
        /// key.nextrequeststart
        case nextRequestStart
        /// key.popular
        case popular
        /// key.unpopular
        case unpopular
        /// key.hide
        case hide
        /// key.platform
        case platform
        /// key.is_deprecated
        case isDeprecated
        /// key.is_unavailable
        case isUnavailable
        /// key.is_optional
        case isOptional
        /// key.message
        case message
        /// key.introduced
        case introduced
        /// key.deprecated
        case deprecated
        /// key.obsoleted
        case obsoleted
        /// key.removecache
        case removeCache
        /// key.typeinterface
        case typeInterface
        /// key.typeusr
        case typeUsr
        /// key.containertypeusr
        case containerTypeUsr
        /// key.modulegroups
        case moduleGroups
        /// key.basename
        case baseName
        /// key.argnames
        case argNames
        /// key.selectorpieces
        case selectorPieces
        /// key.namekind
        case nameKind
        /// key.localization_key
        case localizationKey
        /// key.is_zero_arg_selector
        case isZeroArgSelector
        /// key.swift_version
        case swiftVersion
        /// key.enablediagnostics
        case enableDiagnostics
        /// key.groupname
        case groupName
        /// key.actionname
        case actionName
        /// key.synthesizedextensions
        case synthesizedExtension
        /// key.usingswiftargs
        case usingSwiftArgs
        /// key.names
        case names
        /// key.uids
        case uids
        /// key.syntactic_only
        case syntacticOnly
        /// key.actionable
        case actionable
        /// key.parent_loc
        case parentLoc
        /// key.is_test_candidate
        case isTestCandidate
        /// key.overrides
        case overrides
        /// key.associated_usrs
        case associatedUSRs
        /// key.modulename
        case moduleName
        /// key.related_decls
        case relatedDecls
        /// key.simplified
        case simplified
        /// key.rangecontent
        case rangeContent
        /// key.cancel_on_subsequent_request
        case cancelOnSubsequentRequest
        /// key.renamelocations
        case renameLocations
        /// key.locations
        case locations
        /// key.nametype
        case nameType
        /// key.newname
        case newName
        /// key.categorizededits
        case categorizedEdits
        /// key.categorizedranges
        case categorizedRanges
        /// key.rangesworthnote
        case rangesWorthNote
        /// key.edits
        case edits
        /// key.endline
        case endLine
        /// key.endcolumn
        case endColumn
        /// key.argindex
        case argIndex
        /// key.text
        case text
        /// key.category
        case category
        /// key.is_function_like
        case isFunctionLike
        /// key.is_non_protocol_type
        case isNonProtocolType
        /// key.refactor_actions
        case refactorActions
        /// key.retrieve_refactor_actions
        case retrieveRefactorActions
        /// key.actionuid
        case actionUID
        /// key.actionunavailablereason
        case actionUnavailableReason
        case unrecognized(String)

        public init(string: String) {
            switch string {
            case "key.version_major":
                self = .versionMajor
            case "key.version_minor":
                self = .versionMinor
            case "key.results":
                self = .results
            case "key.request":
                self = .request
            case "key.notification":
                self = .notification
            case "key.kind":
                self = .kind
            case "key.accessibility":
                self = .accessLevel
            case "key.setter_accessibility":
                self = .setterAccessLevel
            case "key.keyword":
                self = .keyword
            case "key.name":
                self = .name
            case "key.usr":
                self = .usr
            case "key.original_usr":
                self = .originalUSR
            case "key.default_implementation_of":
                self = .defaultImplementationOf
            case "key.interested_usr":
                self = .interestedUSR
            case "key.generic_params":
                self = .genericParams
            case "key.generic_requirements":
                self = .genericRequirements
            case "key.doc.full_as_xml":
                self = .docFullAsXML
            case "key.line":
                self = .line
            case "key.column":
                self = .column
            case "key.receiver_usr":
                self = .receiverUSR
            case "key.is_dynamic":
                self = .isDynamic
            case "key.filepath":
                self = .filePath
            case "key.module_interface_name":
                self = .moduleInterfaceName
            case "key.hash":
                self = .hash
            case "key.compilerargs":
                self = .compilerArgs
            case "key.severity":
                self = .severity
            case "key.offset":
                self = .offset
            case "key.length":
                self = .length
            case "key.sourcefile":
                self = .sourceFile
            case "key.sourcetext":
                self = .sourceText
            case "key.enablesyntaxmap":
                self = .enableSyntaxMap
            case "key.enablesubstructure":
                self = .enableStructure
            case "key.description":
                self = .description
            case "key.typename":
                self = .typeName
            case "key.runtime_name":
                self = .runtimeName
            case "key.selector_name":
                self = .selectorName
            case "key.annotated_decl":
                self = .annotatedDecl
            case "key.fully_annotated_decl":
                self = .fullyAnnotatedDecl
            case "key.doc.brief":
                self = .docBrief
            case "key.context":
                self = .context
            case "key.moduleimportdepth":
                self = .moduleImportDepth
            case "key.num_bytes_to_erase":
                self = .numBytesToErase
            case "key.not_recommended":
                self = .notRecommended
            case "key.annotations":
                self = .annotations
            case "key.diagnostic_stage":
                self = .diagnosticStage
            case "key.syntaxmap":
                self = .syntaxMap
            case "key.is_system":
                self = .isSystem
            case "key.related":
                self = .related
            case "key.inherits":
                self = .inherits
            case "key.conforms":
                self = .conforms
            case "key.extends":
                self = .extends
            case "key.dependencies":
                self = .dependencies
            case "key.entities":
                self = .entities
            case "key.nameoffset":
                self = .nameOffset
            case "key.namelength":
                self = .nameLength
            case "key.bodyoffset":
                self = .bodyOffset
            case "key.bodylength":
                self = .bodyLength
            case "key.throwoffset":
                self = .throwOffset
            case "key.throwlength":
                self = .throwLength
            case "key.docoffset":
                self = .docOffset
            case "key.doclength":
                self = .docLength
            case "key.is_local":
                self = .isLocal
            case "key.inheritedtypes":
                self = .inheritedTypes
            case "key.attributes":
                self = .attributes
            case "key.attribute":
                self = .attribute
            case "key.elements":
                self = .elements
            case "key.substructure":
                self = .subStructure
            case "key.ranges":
                self = .ranges
            case "key.fixits":
                self = .fixits
            case "key.diagnostics":
                self = .diagnostics
            case "key.editor.format.options":
                self = .formatOptions
            case "key.codecomplete.options":
                self = .codeCompleteOptions
            case "key.codecomplete.filterrules":
                self = .filterRules
            case "key.nextrequeststart":
                self = .nextRequestStart
            case "key.popular":
                self = .popular
            case "key.unpopular":
                self = .unpopular
            case "key.hide":
                self = .hide
            case "key.platform":
                self = .platform
            case "key.is_deprecated":
                self = .isDeprecated
            case "key.is_unavailable":
                self = .isUnavailable
            case "key.is_optional":
                self = .isOptional
            case "key.message":
                self = .message
            case "key.introduced":
                self = .introduced
            case "key.deprecated":
                self = .deprecated
            case "key.obsoleted":
                self = .obsoleted
            case "key.removecache":
                self = .removeCache
            case "key.typeinterface":
                self = .typeInterface
            case "key.typeusr":
                self = .typeUsr
            case "key.containertypeusr":
                self = .containerTypeUsr
            case "key.modulegroups":
                self = .moduleGroups
            case "key.basename":
                self = .baseName
            case "key.argnames":
                self = .argNames
            case "key.selectorpieces":
                self = .selectorPieces
            case "key.namekind":
                self = .nameKind
            case "key.localization_key":
                self = .localizationKey
            case "key.is_zero_arg_selector":
                self = .isZeroArgSelector
            case "key.swift_version":
                self = .swiftVersion
            case "key.enablediagnostics":
                self = .enableDiagnostics
            case "key.groupname":
                self = .groupName
            case "key.actionname":
                self = .actionName
            case "key.synthesizedextensions":
                self = .synthesizedExtension
            case "key.usingswiftargs":
                self = .usingSwiftArgs
            case "key.names":
                self = .names
            case "key.uids":
                self = .uids
            case "key.syntactic_only":
                self = .syntacticOnly
            case "key.actionable":
                self = .actionable
            case "key.parent_loc":
                self = .parentLoc
            case "key.is_test_candidate":
                self = .isTestCandidate
            case "key.overrides":
                self = .overrides
            case "key.associated_usrs":
                self = .associatedUSRs
            case "key.modulename":
                self = .moduleName
            case "key.related_decls":
                self = .relatedDecls
            case "key.simplified":
                self = .simplified
            case "key.rangecontent":
                self = .rangeContent
            case "key.cancel_on_subsequent_request":
                self = .cancelOnSubsequentRequest
            case "key.renamelocations":
                self = .renameLocations
            case "key.locations":
                self = .locations
            case "key.nametype":
                self = .nameType
            case "key.newname":
                self = .newName
            case "key.categorizededits":
                self = .categorizedEdits
            case "key.categorizedranges":
                self = .categorizedRanges
            case "key.rangesworthnote":
                self = .rangesWorthNote
            case "key.edits":
                self = .edits
            case "key.endline":
                self = .endLine
            case "key.endcolumn":
                self = .endColumn
            case "key.argindex":
                self = .argIndex
            case "key.text":
                self = .text
            case "key.category":
                self = .category
            case "key.is_function_like":
                self = .isFunctionLike
            case "key.is_non_protocol_type":
                self = .isNonProtocolType
            case "key.refactor_actions":
                self = .refactorActions
            case "key.retrieve_refactor_actions":
                self = .retrieveRefactorActions
            case "key.actionuid":
                self = .actionUID
            case "key.actionunavailablereason":
                self = .actionUnavailableReason
            default:
                self = .unrecognized(string)
            }
        }

        public var description: String {
            switch self {
            case .versionMajor:
                return "key.version_major"
            case .versionMinor:
                return "key.version_minor"
            case .results:
                return "key.results"
            case .request:
                return "key.request"
            case .notification:
                return "key.notification"
            case .kind:
                return "key.kind"
            case .accessLevel:
                return "key.accessibility"
            case .setterAccessLevel:
                return "key.setter_accessibility"
            case .keyword:
                return "key.keyword"
            case .name:
                return "key.name"
            case .usr:
                return "key.usr"
            case .originalUSR:
                return "key.original_usr"
            case .defaultImplementationOf:
                return "key.default_implementation_of"
            case .interestedUSR:
                return "key.interested_usr"
            case .genericParams:
                return "key.generic_params"
            case .genericRequirements:
                return "key.generic_requirements"
            case .docFullAsXML:
                return "key.doc.full_as_xml"
            case .line:
                return "key.line"
            case .column:
                return "key.column"
            case .receiverUSR:
                return "key.receiver_usr"
            case .isDynamic:
                return "key.is_dynamic"
            case .filePath:
                return "key.filepath"
            case .moduleInterfaceName:
                return "key.module_interface_name"
            case .hash:
                return "key.hash"
            case .compilerArgs:
                return "key.compilerargs"
            case .severity:
                return "key.severity"
            case .offset:
                return "key.offset"
            case .length:
                return "key.length"
            case .sourceFile:
                return "key.sourcefile"
            case .sourceText:
                return "key.sourcetext"
            case .enableSyntaxMap:
                return "key.enablesyntaxmap"
            case .enableStructure:
                return "key.enablesubstructure"
            case .description:
                return "key.description"
            case .typeName:
                return "key.typename"
            case .runtimeName:
                return "key.runtime_name"
            case .selectorName:
                return "key.selector_name"
            case .annotatedDecl:
                return "key.annotated_decl"
            case .fullyAnnotatedDecl:
                return "key.fully_annotated_decl"
            case .docBrief:
                return "key.doc.brief"
            case .context:
                return "key.context"
            case .moduleImportDepth:
                return "key.moduleimportdepth"
            case .numBytesToErase:
                return "key.num_bytes_to_erase"
            case .notRecommended:
                return "key.not_recommended"
            case .annotations:
                return "key.annotations"
            case .diagnosticStage:
                return "key.diagnostic_stage"
            case .syntaxMap:
                return "key.syntaxmap"
            case .isSystem:
                return "key.is_system"
            case .related:
                return "key.related"
            case .inherits:
                return "key.inherits"
            case .conforms:
                return "key.conforms"
            case .extends:
                return "key.extends"
            case .dependencies:
                return "key.dependencies"
            case .entities:
                return "key.entities"
            case .nameOffset:
                return "key.nameoffset"
            case .nameLength:
                return "key.namelength"
            case .bodyOffset:
                return "key.bodyoffset"
            case .bodyLength:
                return "key.bodylength"
            case .throwOffset:
                return "key.throwoffset"
            case .throwLength:
                return "key.throwlength"
            case .docOffset:
                return "key.docoffset"
            case .docLength:
                return "key.doclength"
            case .isLocal:
                return "key.is_local"
            case .inheritedTypes:
                return "key.inheritedtypes"
            case .attributes:
                return "key.attributes"
            case .attribute:
                return "key.attribute"
            case .elements:
                return "key.elements"
            case .subStructure:
                return "key.substructure"
            case .ranges:
                return "key.ranges"
            case .fixits:
                return "key.fixits"
            case .diagnostics:
                return "key.diagnostics"
            case .formatOptions:
                return "key.editor.format.options"
            case .codeCompleteOptions:
                return "key.codecomplete.options"
            case .filterRules:
                return "key.codecomplete.filterrules"
            case .nextRequestStart:
                return "key.nextrequeststart"
            case .popular:
                return "key.popular"
            case .unpopular:
                return "key.unpopular"
            case .hide:
                return "key.hide"
            case .platform:
                return "key.platform"
            case .isDeprecated:
                return "key.is_deprecated"
            case .isUnavailable:
                return "key.is_unavailable"
            case .isOptional:
                return "key.is_optional"
            case .message:
                return "key.message"
            case .introduced:
                return "key.introduced"
            case .deprecated:
                return "key.deprecated"
            case .obsoleted:
                return "key.obsoleted"
            case .removeCache:
                return "key.removecache"
            case .typeInterface:
                return "key.typeinterface"
            case .typeUsr:
                return "key.typeusr"
            case .containerTypeUsr:
                return "key.containertypeusr"
            case .moduleGroups:
                return "key.modulegroups"
            case .baseName:
                return "key.basename"
            case .argNames:
                return "key.argnames"
            case .selectorPieces:
                return "key.selectorpieces"
            case .nameKind:
                return "key.namekind"
            case .localizationKey:
                return "key.localization_key"
            case .isZeroArgSelector:
                return "key.is_zero_arg_selector"
            case .swiftVersion:
                return "key.swift_version"
            case .enableDiagnostics:
                return "key.enablediagnostics"
            case .groupName:
                return "key.groupname"
            case .actionName:
                return "key.actionname"
            case .synthesizedExtension:
                return "key.synthesizedextensions"
            case .usingSwiftArgs:
                return "key.usingswiftargs"
            case .names:
                return "key.names"
            case .uids:
                return "key.uids"
            case .syntacticOnly:
                return "key.syntactic_only"
            case .actionable:
                return "key.actionable"
            case .parentLoc:
                return "key.parent_loc"
            case .isTestCandidate:
                return "key.is_test_candidate"
            case .overrides:
                return "key.overrides"
            case .associatedUSRs:
                return "key.associated_usrs"
            case .moduleName:
                return "key.modulename"
            case .relatedDecls:
                return "key.related_decls"
            case .simplified:
                return "key.simplified"
            case .rangeContent:
                return "key.rangecontent"
            case .cancelOnSubsequentRequest:
                return "key.cancel_on_subsequent_request"
            case .renameLocations:
                return "key.renamelocations"
            case .locations:
                return "key.locations"
            case .nameType:
                return "key.nametype"
            case .newName:
                return "key.newname"
            case .categorizedEdits:
                return "key.categorizededits"
            case .categorizedRanges:
                return "key.categorizedranges"
            case .rangesWorthNote:
                return "key.rangesworthnote"
            case .edits:
                return "key.edits"
            case .endLine:
                return "key.endline"
            case .endColumn:
                return "key.endcolumn"
            case .argIndex:
                return "key.argindex"
            case .text:
                return "key.text"
            case .category:
                return "key.category"
            case .isFunctionLike:
                return "key.is_function_like"
            case .isNonProtocolType:
                return "key.is_non_protocol_type"
            case .refactorActions:
                return "key.refactor_actions"
            case .retrieveRefactorActions:
                return "key.retrieve_refactor_actions"
            case .actionUID:
                return "key.actionuid"
            case .actionUnavailableReason:
                return "key.actionunavailablereason"
            case let .unrecognized(string):
                return string
            }
        }
    }

    public enum Kind: CustomStringConvertible {
        /// source.lang.swift.decl.function.free
        case declFunctionFree
        /// source.lang.swift.ref.function.free
        case refFunctionFree
        /// source.lang.swift.decl.function.method.instance
        case declMethodInstance
        /// source.lang.swift.ref.function.method.instance
        case refMethodInstance
        /// source.lang.swift.decl.function.method.static
        case declMethodStatic
        /// source.lang.swift.ref.function.method.static
        case refMethodStatic
        /// source.lang.swift.decl.function.method.class
        case declMethodClass
        /// source.lang.swift.ref.function.method.class
        case refMethodClass
        /// source.lang.swift.decl.function.accessor.getter
        case declAccessorGetter
        /// source.lang.swift.ref.function.accessor.getter
        case refAccessorGetter
        /// source.lang.swift.decl.function.accessor.setter
        case declAccessorSetter
        /// source.lang.swift.ref.function.accessor.setter
        case refAccessorSetter
        /// source.lang.swift.decl.function.accessor.willset
        case declAccessorWillSet
        /// source.lang.swift.ref.function.accessor.willset
        case refAccessorWillSet
        /// source.lang.swift.decl.function.accessor.didset
        case declAccessorDidSet
        /// source.lang.swift.ref.function.accessor.didset
        case refAccessorDidSet
        /// source.lang.swift.decl.function.accessor.address
        case declAccessorAddress
        /// source.lang.swift.ref.function.accessor.address
        case refAccessorAddress
        /// source.lang.swift.decl.function.accessor.mutableaddress
        case declAccessorMutableAddress
        /// source.lang.swift.ref.function.accessor.mutableaddress
        case refAccessorMutableAddress
        /// source.lang.swift.decl.function.constructor
        case declConstructor
        /// source.lang.swift.ref.function.constructor
        case refConstructor
        /// source.lang.swift.decl.function.destructor
        case declDestructor
        /// source.lang.swift.ref.function.destructor
        case refDestructor
        /// source.lang.swift.decl.function.operator.prefix
        case declFunctionPrefixOperator
        /// source.lang.swift.decl.function.operator.postfix
        case declFunctionPostfixOperator
        /// source.lang.swift.decl.function.operator.infix
        case declFunctionInfixOperator
        /// source.lang.swift.ref.function.operator.prefix
        case refFunctionPrefixOperator
        /// source.lang.swift.ref.function.operator.postfix
        case refFunctionPostfixOperator
        /// source.lang.swift.ref.function.operator.infix
        case refFunctionInfixOperator
        /// source.lang.swift.decl.precedencegroup
        case declPrecedenceGroup
        /// source.lang.swift.ref.precedencegroup
        case refPrecedenceGroup
        /// source.lang.swift.decl.function.subscript
        case declSubscript
        /// source.lang.swift.ref.function.subscript
        case refSubscript
        /// source.lang.swift.decl.var.global
        case declVarGlobal
        /// source.lang.swift.ref.var.global
        case refVarGlobal
        /// source.lang.swift.decl.var.instance
        case declVarInstance
        /// source.lang.swift.ref.var.instance
        case refVarInstance
        /// source.lang.swift.decl.var.static
        case declVarStatic
        /// source.lang.swift.ref.var.static
        case refVarStatic
        /// source.lang.swift.decl.var.class
        case declVarClass
        /// source.lang.swift.ref.var.class
        case refVarClass
        /// source.lang.swift.decl.var.local
        case declVarLocal
        /// source.lang.swift.ref.var.local
        case refVarLocal
        /// source.lang.swift.decl.var.parameter
        case declVarParam
        /// source.lang.swift.decl.module
        case declModule
        /// source.lang.swift.decl.class
        case declClass
        /// source.lang.swift.ref.class
        case refClass
        /// source.lang.swift.decl.struct
        case declStruct
        /// source.lang.swift.ref.struct
        case refStruct
        /// source.lang.swift.decl.enum
        case declEnum
        /// source.lang.swift.ref.enum
        case refEnum
        /// source.lang.swift.decl.enumcase
        case declEnumCase
        /// source.lang.swift.decl.enumelement
        case declEnumElement
        /// source.lang.swift.ref.enumelement
        case refEnumElement
        /// source.lang.swift.decl.protocol
        case declProtocol
        /// source.lang.swift.ref.protocol
        case refProtocol
        /// source.lang.swift.decl.extension
        case declExtension
        /// source.lang.swift.decl.extension.struct
        case declExtensionStruct
        /// source.lang.swift.decl.extension.class
        case declExtensionClass
        /// source.lang.swift.decl.extension.enum
        case declExtensionEnum
        /// source.lang.swift.decl.extension.protocol
        case declExtensionProtocol
        /// source.lang.swift.decl.associatedtype
        case declAssociatedType
        /// source.lang.swift.ref.associatedtype
        case refAssociatedType
        /// source.lang.swift.decl.typealias
        case declTypeAlias
        /// source.lang.swift.ref.typealias
        case refTypeAlias
        /// source.lang.swift.decl.generic_type_param
        case declGenericTypeParam
        /// source.lang.swift.ref.generic_type_param
        case refGenericTypeParam
        /// source.lang.swift.ref.module
        case refModule
        /// source.lang.swift.stmt.foreach
        case stmtForEach
        /// source.lang.swift.stmt.for
        case stmtFor
        /// source.lang.swift.stmt.while
        case stmtWhile
        /// source.lang.swift.stmt.repeatwhile
        case stmtRepeatWhile
        /// source.lang.swift.stmt.if
        case stmtIf
        /// source.lang.swift.stmt.guard
        case stmtGuard
        /// source.lang.swift.stmt.switch
        case stmtSwitch
        /// source.lang.swift.stmt.case
        case stmtCase
        /// source.lang.swift.stmt.brace
        case stmtBrace
        /// source.lang.swift.expr.call
        case exprCall
        /// source.lang.swift.expr.argument
        case exprArg
        /// source.lang.swift.expr.array
        case exprArray
        /// source.lang.swift.expr.dictionary
        case exprDictionary
        /// source.lang.swift.expr.object_literal
        case exprObjectLiteral
        /// source.lang.swift.structure.elem.id
        case structureElemId
        /// source.lang.swift.structure.elem.expr
        case structureElemExpr
        /// source.lang.swift.structure.elem.init_expr
        case structureElemInitExpr
        /// source.lang.swift.structure.elem.condition_expr
        case structureElemCondExpr
        /// source.lang.swift.structure.elem.pattern
        case structureElemPattern
        /// source.lang.swift.structure.elem.typeref
        case structureElemTypeRef
        /// source.lang.swift.range.singlestatement
        case rangeSingleStatement
        /// source.lang.swift.range.singleexpression
        case rangeSingleExpression
        /// source.lang.swift.range.singledeclaration
        case rangeSingleDeclaration
        /// source.lang.swift.range.multistatement
        case rangeMultiStatement
        /// source.lang.swift.range.invalid
        case rangeInvalid
        /// source.lang.name.kind.objc
        case nameObjc
        /// source.lang.name.kind.swift
        case nameSwift
        /// source.lang.swift.syntaxtype.keyword
        case keyword
        /// source.lang.swift.syntaxtype.identifier
        case identifier
        /// source.lang.swift.syntaxtype.typeidentifier
        case typeIdentifier
        /// source.lang.swift.syntaxtype.buildconfig.keyword
        case buildConfigKeyword
        /// source.lang.swift.syntaxtype.buildconfig.id
        case buildConfigId
        /// source.lang.swift.syntaxtype.attribute.id
        case attributeId
        /// source.lang.swift.syntaxtype.attribute.builtin
        case attributeBuiltin
        /// source.lang.swift.syntaxtype.number
        case number
        /// source.lang.swift.syntaxtype.string
        case string
        /// source.lang.swift.syntaxtype.string_interpolation_anchor
        case stringInterpolation
        /// source.lang.swift.syntaxtype.comment
        case comment
        /// source.lang.swift.syntaxtype.doccomment
        case docComment
        /// source.lang.swift.syntaxtype.doccomment.field
        case docCommentField
        /// source.lang.swift.syntaxtype.comment.mark
        case commentMarker
        /// source.lang.swift.syntaxtype.comment.url
        case commentURL
        /// source.lang.swift.syntaxtype.placeholder
        case placeholder
        /// source.lang.swift.syntaxtype.objectliteral
        case objectLiteral
        /// source.lang.swift.expr
        case expr
        /// source.lang.swift.stmt
        case stmt
        /// source.lang.swift.type
        case type
        /// source.lang.swift.foreach.sequence
        case forEachSequence
        /// source.diagnostic.severity.note
        case diagNote
        /// source.diagnostic.severity.warning
        case diagWarning
        /// source.diagnostic.severity.error
        case diagError
        /// source.codecompletion.everything
        case codeCompletionEverything
        /// source.codecompletion.module
        case codeCompletionModule
        /// source.codecompletion.keyword
        case codeCompletionKeyword
        /// source.codecompletion.literal
        case codeCompletionLiteral
        /// source.codecompletion.custom
        case codeCompletionCustom
        /// source.codecompletion.identifier
        case codeCompletionIdentifier
        /// source.codecompletion.description
        case codeCompletionDescription
        /// source.edit.kind.active
        case editActive
        /// source.edit.kind.inactive
        case editInactive
        /// source.edit.kind.selector
        case editSelector
        /// source.edit.kind.string
        case editString
        /// source.edit.kind.comment
        case editComment
        /// source.edit.kind.mismatch
        case editMismatch
        /// source.edit.kind.unknown
        case editUnknown
        /// source.refactoring.range.kind.basename
        case renameRangeBase
        /// source.refactoring.range.kind.keyword-basename
        case renameRangeKeywordBase
        /// source.refactoring.range.kind.parameter-and-whitespace
        case renameRangeParam
        /// source.refactoring.range.kind.decl-argument-label
        case renameRangeDeclArgLabel
        /// source.refactoring.range.kind.call-argument-label
        case renameRangeCallArgLabel
        /// source.refactoring.range.kind.call-argument-colon
        case renameRangeCallArgColon
        /// source.refactoring.range.kind.call-argument-combined
        case renameRangeCallArgCombined
        /// source.refactoring.range.kind.selector-argument-label
        case renameRangeSelectorArgLabel
        /// source.syntacticrename.definition
        case definition
        /// source.syntacticrename.reference
        case reference
        /// source.syntacticrename.call
        case call
        /// source.syntacticrename.unknown
        case unknown
        case unrecognized(String)

        public init(string: String) {
            switch string {
            case "source.lang.swift.decl.function.free":
                self = .declFunctionFree
            case "source.lang.swift.ref.function.free":
                self = .refFunctionFree
            case "source.lang.swift.decl.function.method.instance":
                self = .declMethodInstance
            case "source.lang.swift.ref.function.method.instance":
                self = .refMethodInstance
            case "source.lang.swift.decl.function.method.static":
                self = .declMethodStatic
            case "source.lang.swift.ref.function.method.static":
                self = .refMethodStatic
            case "source.lang.swift.decl.function.method.class":
                self = .declMethodClass
            case "source.lang.swift.ref.function.method.class":
                self = .refMethodClass
            case "source.lang.swift.decl.function.accessor.getter":
                self = .declAccessorGetter
            case "source.lang.swift.ref.function.accessor.getter":
                self = .refAccessorGetter
            case "source.lang.swift.decl.function.accessor.setter":
                self = .declAccessorSetter
            case "source.lang.swift.ref.function.accessor.setter":
                self = .refAccessorSetter
            case "source.lang.swift.decl.function.accessor.willset":
                self = .declAccessorWillSet
            case "source.lang.swift.ref.function.accessor.willset":
                self = .refAccessorWillSet
            case "source.lang.swift.decl.function.accessor.didset":
                self = .declAccessorDidSet
            case "source.lang.swift.ref.function.accessor.didset":
                self = .refAccessorDidSet
            case "source.lang.swift.decl.function.accessor.address":
                self = .declAccessorAddress
            case "source.lang.swift.ref.function.accessor.address":
                self = .refAccessorAddress
            case "source.lang.swift.decl.function.accessor.mutableaddress":
                self = .declAccessorMutableAddress
            case "source.lang.swift.ref.function.accessor.mutableaddress":
                self = .refAccessorMutableAddress
            case "source.lang.swift.decl.function.constructor":
                self = .declConstructor
            case "source.lang.swift.ref.function.constructor":
                self = .refConstructor
            case "source.lang.swift.decl.function.destructor":
                self = .declDestructor
            case "source.lang.swift.ref.function.destructor":
                self = .refDestructor
            case "source.lang.swift.decl.function.operator.prefix":
                self = .declFunctionPrefixOperator
            case "source.lang.swift.decl.function.operator.postfix":
                self = .declFunctionPostfixOperator
            case "source.lang.swift.decl.function.operator.infix":
                self = .declFunctionInfixOperator
            case "source.lang.swift.ref.function.operator.prefix":
                self = .refFunctionPrefixOperator
            case "source.lang.swift.ref.function.operator.postfix":
                self = .refFunctionPostfixOperator
            case "source.lang.swift.ref.function.operator.infix":
                self = .refFunctionInfixOperator
            case "source.lang.swift.decl.precedencegroup":
                self = .declPrecedenceGroup
            case "source.lang.swift.ref.precedencegroup":
                self = .refPrecedenceGroup
            case "source.lang.swift.decl.function.subscript":
                self = .declSubscript
            case "source.lang.swift.ref.function.subscript":
                self = .refSubscript
            case "source.lang.swift.decl.var.global":
                self = .declVarGlobal
            case "source.lang.swift.ref.var.global":
                self = .refVarGlobal
            case "source.lang.swift.decl.var.instance":
                self = .declVarInstance
            case "source.lang.swift.ref.var.instance":
                self = .refVarInstance
            case "source.lang.swift.decl.var.static":
                self = .declVarStatic
            case "source.lang.swift.ref.var.static":
                self = .refVarStatic
            case "source.lang.swift.decl.var.class":
                self = .declVarClass
            case "source.lang.swift.ref.var.class":
                self = .refVarClass
            case "source.lang.swift.decl.var.local":
                self = .declVarLocal
            case "source.lang.swift.ref.var.local":
                self = .refVarLocal
            case "source.lang.swift.decl.var.parameter":
                self = .declVarParam
            case "source.lang.swift.decl.module":
                self = .declModule
            case "source.lang.swift.decl.class":
                self = .declClass
            case "source.lang.swift.ref.class":
                self = .refClass
            case "source.lang.swift.decl.struct":
                self = .declStruct
            case "source.lang.swift.ref.struct":
                self = .refStruct
            case "source.lang.swift.decl.enum":
                self = .declEnum
            case "source.lang.swift.ref.enum":
                self = .refEnum
            case "source.lang.swift.decl.enumcase":
                self = .declEnumCase
            case "source.lang.swift.decl.enumelement":
                self = .declEnumElement
            case "source.lang.swift.ref.enumelement":
                self = .refEnumElement
            case "source.lang.swift.decl.protocol":
                self = .declProtocol
            case "source.lang.swift.ref.protocol":
                self = .refProtocol
            case "source.lang.swift.decl.extension":
                self = .declExtension
            case "source.lang.swift.decl.extension.struct":
                self = .declExtensionStruct
            case "source.lang.swift.decl.extension.class":
                self = .declExtensionClass
            case "source.lang.swift.decl.extension.enum":
                self = .declExtensionEnum
            case "source.lang.swift.decl.extension.protocol":
                self = .declExtensionProtocol
            case "source.lang.swift.decl.associatedtype":
                self = .declAssociatedType
            case "source.lang.swift.ref.associatedtype":
                self = .refAssociatedType
            case "source.lang.swift.decl.typealias":
                self = .declTypeAlias
            case "source.lang.swift.ref.typealias":
                self = .refTypeAlias
            case "source.lang.swift.decl.generic_type_param":
                self = .declGenericTypeParam
            case "source.lang.swift.ref.generic_type_param":
                self = .refGenericTypeParam
            case "source.lang.swift.ref.module":
                self = .refModule
            case "source.lang.swift.stmt.foreach":
                self = .stmtForEach
            case "source.lang.swift.stmt.for":
                self = .stmtFor
            case "source.lang.swift.stmt.while":
                self = .stmtWhile
            case "source.lang.swift.stmt.repeatwhile":
                self = .stmtRepeatWhile
            case "source.lang.swift.stmt.if":
                self = .stmtIf
            case "source.lang.swift.stmt.guard":
                self = .stmtGuard
            case "source.lang.swift.stmt.switch":
                self = .stmtSwitch
            case "source.lang.swift.stmt.case":
                self = .stmtCase
            case "source.lang.swift.stmt.brace":
                self = .stmtBrace
            case "source.lang.swift.expr.call":
                self = .exprCall
            case "source.lang.swift.expr.argument":
                self = .exprArg
            case "source.lang.swift.expr.array":
                self = .exprArray
            case "source.lang.swift.expr.dictionary":
                self = .exprDictionary
            case "source.lang.swift.expr.object_literal":
                self = .exprObjectLiteral
            case "source.lang.swift.structure.elem.id":
                self = .structureElemId
            case "source.lang.swift.structure.elem.expr":
                self = .structureElemExpr
            case "source.lang.swift.structure.elem.init_expr":
                self = .structureElemInitExpr
            case "source.lang.swift.structure.elem.condition_expr":
                self = .structureElemCondExpr
            case "source.lang.swift.structure.elem.pattern":
                self = .structureElemPattern
            case "source.lang.swift.structure.elem.typeref":
                self = .structureElemTypeRef
            case "source.lang.swift.range.singlestatement":
                self = .rangeSingleStatement
            case "source.lang.swift.range.singleexpression":
                self = .rangeSingleExpression
            case "source.lang.swift.range.singledeclaration":
                self = .rangeSingleDeclaration
            case "source.lang.swift.range.multistatement":
                self = .rangeMultiStatement
            case "source.lang.swift.range.invalid":
                self = .rangeInvalid
            case "source.lang.name.kind.objc":
                self = .nameObjc
            case "source.lang.name.kind.swift":
                self = .nameSwift
            case "source.lang.swift.syntaxtype.keyword":
                self = .keyword
            case "source.lang.swift.syntaxtype.identifier":
                self = .identifier
            case "source.lang.swift.syntaxtype.typeidentifier":
                self = .typeIdentifier
            case "source.lang.swift.syntaxtype.buildconfig.keyword":
                self = .buildConfigKeyword
            case "source.lang.swift.syntaxtype.buildconfig.id":
                self = .buildConfigId
            case "source.lang.swift.syntaxtype.attribute.id":
                self = .attributeId
            case "source.lang.swift.syntaxtype.attribute.builtin":
                self = .attributeBuiltin
            case "source.lang.swift.syntaxtype.number":
                self = .number
            case "source.lang.swift.syntaxtype.string":
                self = .string
            case "source.lang.swift.syntaxtype.string_interpolation_anchor":
                self = .stringInterpolation
            case "source.lang.swift.syntaxtype.comment":
                self = .comment
            case "source.lang.swift.syntaxtype.doccomment":
                self = .docComment
            case "source.lang.swift.syntaxtype.doccomment.field":
                self = .docCommentField
            case "source.lang.swift.syntaxtype.comment.mark":
                self = .commentMarker
            case "source.lang.swift.syntaxtype.comment.url":
                self = .commentURL
            case "source.lang.swift.syntaxtype.placeholder":
                self = .placeholder
            case "source.lang.swift.syntaxtype.objectliteral":
                self = .objectLiteral
            case "source.lang.swift.expr":
                self = .expr
            case "source.lang.swift.stmt":
                self = .stmt
            case "source.lang.swift.type":
                self = .type
            case "source.lang.swift.foreach.sequence":
                self = .forEachSequence
            case "source.diagnostic.severity.note":
                self = .diagNote
            case "source.diagnostic.severity.warning":
                self = .diagWarning
            case "source.diagnostic.severity.error":
                self = .diagError
            case "source.codecompletion.everything":
                self = .codeCompletionEverything
            case "source.codecompletion.module":
                self = .codeCompletionModule
            case "source.codecompletion.keyword":
                self = .codeCompletionKeyword
            case "source.codecompletion.literal":
                self = .codeCompletionLiteral
            case "source.codecompletion.custom":
                self = .codeCompletionCustom
            case "source.codecompletion.identifier":
                self = .codeCompletionIdentifier
            case "source.codecompletion.description":
                self = .codeCompletionDescription
            case "source.edit.kind.active":
                self = .editActive
            case "source.edit.kind.inactive":
                self = .editInactive
            case "source.edit.kind.selector":
                self = .editSelector
            case "source.edit.kind.string":
                self = .editString
            case "source.edit.kind.comment":
                self = .editComment
            case "source.edit.kind.mismatch":
                self = .editMismatch
            case "source.edit.kind.unknown":
                self = .editUnknown
            case "source.refactoring.range.kind.basename":
                self = .renameRangeBase
            case "source.refactoring.range.kind.keyword-basename":
                self = .renameRangeKeywordBase
            case "source.refactoring.range.kind.parameter-and-whitespace":
                self = .renameRangeParam
            case "source.refactoring.range.kind.decl-argument-label":
                self = .renameRangeDeclArgLabel
            case "source.refactoring.range.kind.call-argument-label":
                self = .renameRangeCallArgLabel
            case "source.refactoring.range.kind.call-argument-colon":
                self = .renameRangeCallArgColon
            case "source.refactoring.range.kind.call-argument-combined":
                self = .renameRangeCallArgCombined
            case "source.refactoring.range.kind.selector-argument-label":
                self = .renameRangeSelectorArgLabel
            case "source.syntacticrename.definition":
                self = .definition
            case "source.syntacticrename.reference":
                self = .reference
            case "source.syntacticrename.call":
                self = .call
            case "source.syntacticrename.unknown":
                self = .unknown
            default:
                self = .unrecognized(string)
            }
        }

        public var description: String {
            switch self {
            case .declFunctionFree:
                return "source.lang.swift.decl.function.free"
            case .refFunctionFree:
                return "source.lang.swift.ref.function.free"
            case .declMethodInstance:
                return "source.lang.swift.decl.function.method.instance"
            case .refMethodInstance:
                return "source.lang.swift.ref.function.method.instance"
            case .declMethodStatic:
                return "source.lang.swift.decl.function.method.static"
            case .refMethodStatic:
                return "source.lang.swift.ref.function.method.static"
            case .declMethodClass:
                return "source.lang.swift.decl.function.method.class"
            case .refMethodClass:
                return "source.lang.swift.ref.function.method.class"
            case .declAccessorGetter:
                return "source.lang.swift.decl.function.accessor.getter"
            case .refAccessorGetter:
                return "source.lang.swift.ref.function.accessor.getter"
            case .declAccessorSetter:
                return "source.lang.swift.decl.function.accessor.setter"
            case .refAccessorSetter:
                return "source.lang.swift.ref.function.accessor.setter"
            case .declAccessorWillSet:
                return "source.lang.swift.decl.function.accessor.willset"
            case .refAccessorWillSet:
                return "source.lang.swift.ref.function.accessor.willset"
            case .declAccessorDidSet:
                return "source.lang.swift.decl.function.accessor.didset"
            case .refAccessorDidSet:
                return "source.lang.swift.ref.function.accessor.didset"
            case .declAccessorAddress:
                return "source.lang.swift.decl.function.accessor.address"
            case .refAccessorAddress:
                return "source.lang.swift.ref.function.accessor.address"
            case .declAccessorMutableAddress:
                return "source.lang.swift.decl.function.accessor.mutableaddress"
            case .refAccessorMutableAddress:
                return "source.lang.swift.ref.function.accessor.mutableaddress"
            case .declConstructor:
                return "source.lang.swift.decl.function.constructor"
            case .refConstructor:
                return "source.lang.swift.ref.function.constructor"
            case .declDestructor:
                return "source.lang.swift.decl.function.destructor"
            case .refDestructor:
                return "source.lang.swift.ref.function.destructor"
            case .declFunctionPrefixOperator:
                return "source.lang.swift.decl.function.operator.prefix"
            case .declFunctionPostfixOperator:
                return "source.lang.swift.decl.function.operator.postfix"
            case .declFunctionInfixOperator:
                return "source.lang.swift.decl.function.operator.infix"
            case .refFunctionPrefixOperator:
                return "source.lang.swift.ref.function.operator.prefix"
            case .refFunctionPostfixOperator:
                return "source.lang.swift.ref.function.operator.postfix"
            case .refFunctionInfixOperator:
                return "source.lang.swift.ref.function.operator.infix"
            case .declPrecedenceGroup:
                return "source.lang.swift.decl.precedencegroup"
            case .refPrecedenceGroup:
                return "source.lang.swift.ref.precedencegroup"
            case .declSubscript:
                return "source.lang.swift.decl.function.subscript"
            case .refSubscript:
                return "source.lang.swift.ref.function.subscript"
            case .declVarGlobal:
                return "source.lang.swift.decl.var.global"
            case .refVarGlobal:
                return "source.lang.swift.ref.var.global"
            case .declVarInstance:
                return "source.lang.swift.decl.var.instance"
            case .refVarInstance:
                return "source.lang.swift.ref.var.instance"
            case .declVarStatic:
                return "source.lang.swift.decl.var.static"
            case .refVarStatic:
                return "source.lang.swift.ref.var.static"
            case .declVarClass:
                return "source.lang.swift.decl.var.class"
            case .refVarClass:
                return "source.lang.swift.ref.var.class"
            case .declVarLocal:
                return "source.lang.swift.decl.var.local"
            case .refVarLocal:
                return "source.lang.swift.ref.var.local"
            case .declVarParam:
                return "source.lang.swift.decl.var.parameter"
            case .declModule:
                return "source.lang.swift.decl.module"
            case .declClass:
                return "source.lang.swift.decl.class"
            case .refClass:
                return "source.lang.swift.ref.class"
            case .declStruct:
                return "source.lang.swift.decl.struct"
            case .refStruct:
                return "source.lang.swift.ref.struct"
            case .declEnum:
                return "source.lang.swift.decl.enum"
            case .refEnum:
                return "source.lang.swift.ref.enum"
            case .declEnumCase:
                return "source.lang.swift.decl.enumcase"
            case .declEnumElement:
                return "source.lang.swift.decl.enumelement"
            case .refEnumElement:
                return "source.lang.swift.ref.enumelement"
            case .declProtocol:
                return "source.lang.swift.decl.protocol"
            case .refProtocol:
                return "source.lang.swift.ref.protocol"
            case .declExtension:
                return "source.lang.swift.decl.extension"
            case .declExtensionStruct:
                return "source.lang.swift.decl.extension.struct"
            case .declExtensionClass:
                return "source.lang.swift.decl.extension.class"
            case .declExtensionEnum:
                return "source.lang.swift.decl.extension.enum"
            case .declExtensionProtocol:
                return "source.lang.swift.decl.extension.protocol"
            case .declAssociatedType:
                return "source.lang.swift.decl.associatedtype"
            case .refAssociatedType:
                return "source.lang.swift.ref.associatedtype"
            case .declTypeAlias:
                return "source.lang.swift.decl.typealias"
            case .refTypeAlias:
                return "source.lang.swift.ref.typealias"
            case .declGenericTypeParam:
                return "source.lang.swift.decl.generic_type_param"
            case .refGenericTypeParam:
                return "source.lang.swift.ref.generic_type_param"
            case .refModule:
                return "source.lang.swift.ref.module"
            case .stmtForEach:
                return "source.lang.swift.stmt.foreach"
            case .stmtFor:
                return "source.lang.swift.stmt.for"
            case .stmtWhile:
                return "source.lang.swift.stmt.while"
            case .stmtRepeatWhile:
                return "source.lang.swift.stmt.repeatwhile"
            case .stmtIf:
                return "source.lang.swift.stmt.if"
            case .stmtGuard:
                return "source.lang.swift.stmt.guard"
            case .stmtSwitch:
                return "source.lang.swift.stmt.switch"
            case .stmtCase:
                return "source.lang.swift.stmt.case"
            case .stmtBrace:
                return "source.lang.swift.stmt.brace"
            case .exprCall:
                return "source.lang.swift.expr.call"
            case .exprArg:
                return "source.lang.swift.expr.argument"
            case .exprArray:
                return "source.lang.swift.expr.array"
            case .exprDictionary:
                return "source.lang.swift.expr.dictionary"
            case .exprObjectLiteral:
                return "source.lang.swift.expr.object_literal"
            case .structureElemId:
                return "source.lang.swift.structure.elem.id"
            case .structureElemExpr:
                return "source.lang.swift.structure.elem.expr"
            case .structureElemInitExpr:
                return "source.lang.swift.structure.elem.init_expr"
            case .structureElemCondExpr:
                return "source.lang.swift.structure.elem.condition_expr"
            case .structureElemPattern:
                return "source.lang.swift.structure.elem.pattern"
            case .structureElemTypeRef:
                return "source.lang.swift.structure.elem.typeref"
            case .rangeSingleStatement:
                return "source.lang.swift.range.singlestatement"
            case .rangeSingleExpression:
                return "source.lang.swift.range.singleexpression"
            case .rangeSingleDeclaration:
                return "source.lang.swift.range.singledeclaration"
            case .rangeMultiStatement:
                return "source.lang.swift.range.multistatement"
            case .rangeInvalid:
                return "source.lang.swift.range.invalid"
            case .nameObjc:
                return "source.lang.name.kind.objc"
            case .nameSwift:
                return "source.lang.name.kind.swift"
            case .keyword:
                return "source.lang.swift.syntaxtype.keyword"
            case .identifier:
                return "source.lang.swift.syntaxtype.identifier"
            case .typeIdentifier:
                return "source.lang.swift.syntaxtype.typeidentifier"
            case .buildConfigKeyword:
                return "source.lang.swift.syntaxtype.buildconfig.keyword"
            case .buildConfigId:
                return "source.lang.swift.syntaxtype.buildconfig.id"
            case .attributeId:
                return "source.lang.swift.syntaxtype.attribute.id"
            case .attributeBuiltin:
                return "source.lang.swift.syntaxtype.attribute.builtin"
            case .number:
                return "source.lang.swift.syntaxtype.number"
            case .string:
                return "source.lang.swift.syntaxtype.string"
            case .stringInterpolation:
                return "source.lang.swift.syntaxtype.string_interpolation_anchor"
            case .comment:
                return "source.lang.swift.syntaxtype.comment"
            case .docComment:
                return "source.lang.swift.syntaxtype.doccomment"
            case .docCommentField:
                return "source.lang.swift.syntaxtype.doccomment.field"
            case .commentMarker:
                return "source.lang.swift.syntaxtype.comment.mark"
            case .commentURL:
                return "source.lang.swift.syntaxtype.comment.url"
            case .placeholder:
                return "source.lang.swift.syntaxtype.placeholder"
            case .objectLiteral:
                return "source.lang.swift.syntaxtype.objectliteral"
            case .expr:
                return "source.lang.swift.expr"
            case .stmt:
                return "source.lang.swift.stmt"
            case .type:
                return "source.lang.swift.type"
            case .forEachSequence:
                return "source.lang.swift.foreach.sequence"
            case .diagNote:
                return "source.diagnostic.severity.note"
            case .diagWarning:
                return "source.diagnostic.severity.warning"
            case .diagError:
                return "source.diagnostic.severity.error"
            case .codeCompletionEverything:
                return "source.codecompletion.everything"
            case .codeCompletionModule:
                return "source.codecompletion.module"
            case .codeCompletionKeyword:
                return "source.codecompletion.keyword"
            case .codeCompletionLiteral:
                return "source.codecompletion.literal"
            case .codeCompletionCustom:
                return "source.codecompletion.custom"
            case .codeCompletionIdentifier:
                return "source.codecompletion.identifier"
            case .codeCompletionDescription:
                return "source.codecompletion.description"
            case .editActive:
                return "source.edit.kind.active"
            case .editInactive:
                return "source.edit.kind.inactive"
            case .editSelector:
                return "source.edit.kind.selector"
            case .editString:
                return "source.edit.kind.string"
            case .editComment:
                return "source.edit.kind.comment"
            case .editMismatch:
                return "source.edit.kind.mismatch"
            case .editUnknown:
                return "source.edit.kind.unknown"
            case .renameRangeBase:
                return "source.refactoring.range.kind.basename"
            case .renameRangeKeywordBase:
                return "source.refactoring.range.kind.keyword-basename"
            case .renameRangeParam:
                return "source.refactoring.range.kind.parameter-and-whitespace"
            case .renameRangeDeclArgLabel:
                return "source.refactoring.range.kind.decl-argument-label"
            case .renameRangeCallArgLabel:
                return "source.refactoring.range.kind.call-argument-label"
            case .renameRangeCallArgColon:
                return "source.refactoring.range.kind.call-argument-colon"
            case .renameRangeCallArgCombined:
                return "source.refactoring.range.kind.call-argument-combined"
            case .renameRangeSelectorArgLabel:
                return "source.refactoring.range.kind.selector-argument-label"
            case .definition:
                return "source.syntacticrename.definition"
            case .reference:
                return "source.syntacticrename.reference"
            case .call:
                return "source.syntacticrename.call"
            case .unknown:
                return "source.syntacticrename.unknown"
            case let .unrecognized(string):
                return string
            }
        }
    }

    public enum Request: CustomStringConvertible {
        /// source.request.protocol_version
        case protocolVersion
        /// source.request.crash_exit
        case crashWithExit
        /// source.request.demangle
        case demangle
        /// source.request.mangle_simple_class
        case mangleSimpleClass
        /// source.request.indexsource
        case index
        /// source.request.docinfo
        case docInfo
        /// source.request.codecomplete
        case codeComplete
        /// source.request.codecomplete.open
        case codeCompleteOpen
        /// source.request.codecomplete.close
        case codeCompleteClose
        /// source.request.codecomplete.update
        case codeCompleteUpdate
        /// source.request.codecomplete.cache.ondisk
        case codeCompleteCacheOnDisk
        /// source.request.codecomplete.setpopularapi
        case codeCompleteSetPopularAPI
        /// source.request.codecomplete.setcustom
        case codeCompleteSetCustom
        /// source.request.cursorinfo
        case cursorInfo
        /// source.request.rangeinfo
        case rangeInfo
        /// source.request.relatedidents
        case relatedIdents
        /// source.request.editor.open
        case editorOpen
        /// source.request.editor.open.interface
        case editorOpenInterface
        /// source.request.editor.open.interface.header
        case editorOpenHeaderInterface
        /// source.request.editor.open.interface.swiftsource
        case editorOpenSwiftSourceInterface
        /// source.request.editor.open.interface.swifttype
        case editorOpenSwiftTypeInterface
        /// source.request.editor.extract.comment
        case editorExtractTextFromComment
        /// source.request.editor.close
        case editorClose
        /// source.request.editor.replacetext
        case editorReplaceText
        /// source.request.editor.formattext
        case editorFormatText
        /// source.request.editor.expand_placeholder
        case editorExpandPlaceholder
        /// source.request.editor.find_usr
        case editorFindUSR
        /// source.request.editor.find_interface_doc
        case editorFindInterfaceDoc
        /// source.request.buildsettings.register
        case buildSettingsRegister
        /// source.request.module.groups
        case moduleGroups
        /// source.request.name.translation
        case nameTranslation
        /// source.request.convert.markup.xml
        case markupToXML
        /// source.request.syntacticrename
        case syntacticRename
        /// source.request.find-syntactic-rename-ranges
        case findRenameRanges
        /// source.request.find-local-rename-ranges
        case findLocalRenameRanges
        /// source.request.semantic.refactoring
        case semanticRefactoring
        case unrecognized(String)

        public init(string: String) {
            switch string {
            case "source.request.protocol_version":
                self = .protocolVersion
            case "source.request.crash_exit":
                self = .crashWithExit
            case "source.request.demangle":
                self = .demangle
            case "source.request.mangle_simple_class":
                self = .mangleSimpleClass
            case "source.request.indexsource":
                self = .index
            case "source.request.docinfo":
                self = .docInfo
            case "source.request.codecomplete":
                self = .codeComplete
            case "source.request.codecomplete.open":
                self = .codeCompleteOpen
            case "source.request.codecomplete.close":
                self = .codeCompleteClose
            case "source.request.codecomplete.update":
                self = .codeCompleteUpdate
            case "source.request.codecomplete.cache.ondisk":
                self = .codeCompleteCacheOnDisk
            case "source.request.codecomplete.setpopularapi":
                self = .codeCompleteSetPopularAPI
            case "source.request.codecomplete.setcustom":
                self = .codeCompleteSetCustom
            case "source.request.cursorinfo":
                self = .cursorInfo
            case "source.request.rangeinfo":
                self = .rangeInfo
            case "source.request.relatedidents":
                self = .relatedIdents
            case "source.request.editor.open":
                self = .editorOpen
            case "source.request.editor.open.interface":
                self = .editorOpenInterface
            case "source.request.editor.open.interface.header":
                self = .editorOpenHeaderInterface
            case "source.request.editor.open.interface.swiftsource":
                self = .editorOpenSwiftSourceInterface
            case "source.request.editor.open.interface.swifttype":
                self = .editorOpenSwiftTypeInterface
            case "source.request.editor.extract.comment":
                self = .editorExtractTextFromComment
            case "source.request.editor.close":
                self = .editorClose
            case "source.request.editor.replacetext":
                self = .editorReplaceText
            case "source.request.editor.formattext":
                self = .editorFormatText
            case "source.request.editor.expand_placeholder":
                self = .editorExpandPlaceholder
            case "source.request.editor.find_usr":
                self = .editorFindUSR
            case "source.request.editor.find_interface_doc":
                self = .editorFindInterfaceDoc
            case "source.request.buildsettings.register":
                self = .buildSettingsRegister
            case "source.request.module.groups":
                self = .moduleGroups
            case "source.request.name.translation":
                self = .nameTranslation
            case "source.request.convert.markup.xml":
                self = .markupToXML
            case "source.request.syntacticrename":
                self = .syntacticRename
            case "source.request.find-syntactic-rename-ranges":
                self = .findRenameRanges
            case "source.request.find-local-rename-ranges":
                self = .findLocalRenameRanges
            case "source.request.semantic.refactoring":
                self = .semanticRefactoring
            default:
                self = .unrecognized(string)
            }
        }

        public var description: String {
            switch self {
            case .protocolVersion:
                return "source.request.protocol_version"
            case .crashWithExit:
                return "source.request.crash_exit"
            case .demangle:
                return "source.request.demangle"
            case .mangleSimpleClass:
                return "source.request.mangle_simple_class"
            case .index:
                return "source.request.indexsource"
            case .docInfo:
                return "source.request.docinfo"
            case .codeComplete:
                return "source.request.codecomplete"
            case .codeCompleteOpen:
                return "source.request.codecomplete.open"
            case .codeCompleteClose:
                return "source.request.codecomplete.close"
            case .codeCompleteUpdate:
                return "source.request.codecomplete.update"
            case .codeCompleteCacheOnDisk:
                return "source.request.codecomplete.cache.ondisk"
            case .codeCompleteSetPopularAPI:
                return "source.request.codecomplete.setpopularapi"
            case .codeCompleteSetCustom:
                return "source.request.codecomplete.setcustom"
            case .cursorInfo:
                return "source.request.cursorinfo"
            case .rangeInfo:
                return "source.request.rangeinfo"
            case .relatedIdents:
                return "source.request.relatedidents"
            case .editorOpen:
                return "source.request.editor.open"
            case .editorOpenInterface:
                return "source.request.editor.open.interface"
            case .editorOpenHeaderInterface:
                return "source.request.editor.open.interface.header"
            case .editorOpenSwiftSourceInterface:
                return "source.request.editor.open.interface.swiftsource"
            case .editorOpenSwiftTypeInterface:
                return "source.request.editor.open.interface.swifttype"
            case .editorExtractTextFromComment:
                return "source.request.editor.extract.comment"
            case .editorClose:
                return "source.request.editor.close"
            case .editorReplaceText:
                return "source.request.editor.replacetext"
            case .editorFormatText:
                return "source.request.editor.formattext"
            case .editorExpandPlaceholder:
                return "source.request.editor.expand_placeholder"
            case .editorFindUSR:
                return "source.request.editor.find_usr"
            case .editorFindInterfaceDoc:
                return "source.request.editor.find_interface_doc"
            case .buildSettingsRegister:
                return "source.request.buildsettings.register"
            case .moduleGroups:
                return "source.request.module.groups"
            case .nameTranslation:
                return "source.request.name.translation"
            case .markupToXML:
                return "source.request.convert.markup.xml"
            case .syntacticRename:
                return "source.request.syntacticrename"
            case .findRenameRanges:
                return "source.request.find-syntactic-rename-ranges"
            case .findLocalRenameRanges:
                return "source.request.find-local-rename-ranges"
            case .semanticRefactoring:
                return "source.request.semantic.refactoring"
            case let .unrecognized(string):
                return string
            }
        }
    }
}

// MARK: - Hashable

extension UID.Key: Hashable {
    public var hashValue: Int {
        return description.hashValue
    }

    public static func == (lhs: UID.Key, rhs: UID.Key) -> Bool {
        return lhs.description == rhs.description
    }
}

extension UID.Kind: Hashable {
    public var hashValue: Int {
        return description.hashValue
    }

    public static func == (lhs: UID.Kind, rhs: UID.Kind) -> Bool {
        return lhs.description == rhs.description
    }
}

extension UID.Request: Hashable {
    public var hashValue: Int {
        return description.hashValue
    }

    public static func == (lhs: UID.Request, rhs: UID.Request) -> Bool {
        return lhs.description == rhs.description
    }
}

// MARK: -

public extension UID.Key {
    public static let count: Int = 134
}

public extension UID.Kind {
    public static let count: Int = 146
}

public extension UID.Request {
    public static let count: Int = 36
}
