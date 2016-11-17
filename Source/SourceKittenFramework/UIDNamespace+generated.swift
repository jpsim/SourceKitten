extension UID {
    public struct key: UIDNamespace {
        public let uid: UID
        /// "key.accessibility"
        public static let accessibility: UID.key = "key.accessibility"
        /// "key.annotated_decl"
        public static let annotated_decl: UID.key = "key.annotated_decl"
        /// "key.annotations"
        public static let annotations: UID.key = "key.annotations"
        /// "key.associated_usrs"
        public static let associated_usrs: UID.key = "key.associated_usrs"
        /// "key.attribute"
        public static let attribute: UID.key = "key.attribute"
        /// "key.attributes"
        public static let attributes: UID.key = "key.attributes"
        /// "key.bodylength"
        public static let bodylength: UID.key = "key.bodylength"
        /// "key.bodyoffset"
        public static let bodyoffset: UID.key = "key.bodyoffset"
        public struct codecomplete {
            /// "key.codecomplete.addinitstotoplevel"
            public static let addinitstotoplevel: UID.key = "key.codecomplete.addinitstotoplevel"
            /// "key.codecomplete.addinneroperators"
            public static let addinneroperators: UID.key = "key.codecomplete.addinneroperators"
            /// "key.codecomplete.addinnerresults"
            public static let addinnerresults: UID.key = "key.codecomplete.addinnerresults"
            /// "key.codecomplete.filterrules"
            public static let filterrules: UID.key = "key.codecomplete.filterrules"
            /// "key.codecomplete.filtertext"
            public static let filtertext: UID.key = "key.codecomplete.filtertext"
            /// "key.codecomplete.fuzzymatching"
            public static let fuzzymatching: UID.key = "key.codecomplete.fuzzymatching"
            public struct group {
                /// "key.codecomplete.group.overloads"
                public static let overloads: UID.key = "key.codecomplete.group.overloads"
                /// "key.codecomplete.group.stems"
                public static let stems: UID.key = "key.codecomplete.group.stems"
            }
            /// "key.codecomplete.hidebyname"
            public static let hidebyname: UID.key = "key.codecomplete.hidebyname"
            /// "key.codecomplete.hidelowpriority"
            public static let hidelowpriority: UID.key = "key.codecomplete.hidelowpriority"
            /// "key.codecomplete.hideunderscores"
            public static let hideunderscores: UID.key = "key.codecomplete.hideunderscores"
            /// "key.codecomplete.includeexactmatch"
            public static let includeexactmatch: UID.key = "key.codecomplete.includeexactmatch"
            /// "key.codecomplete.options"
            public static let options: UID.key = "key.codecomplete.options"
            /// "key.codecomplete.requestlimit"
            public static let requestlimit: UID.key = "key.codecomplete.requestlimit"
            /// "key.codecomplete.requeststart"
            public static let requeststart: UID.key = "key.codecomplete.requeststart"
            /// "key.codecomplete.showtopnonliteralresults"
            public static let showtopnonliteralresults: UID.key = "key.codecomplete.showtopnonliteralresults"
            public struct sort {
                /// "key.codecomplete.sort.byname"
                public static let byname: UID.key = "key.codecomplete.sort.byname"
                /// "key.codecomplete.sort.contextweight"
                public static let contextweight: UID.key = "key.codecomplete.sort.contextweight"
                /// "key.codecomplete.sort.fuzzyweight"
                public static let fuzzyweight: UID.key = "key.codecomplete.sort.fuzzyweight"
                /// "key.codecomplete.sort.popularitybonus"
                public static let popularitybonus: UID.key = "key.codecomplete.sort.popularitybonus"
                /// "key.codecomplete.sort.useimportdepth"
                public static let useimportdepth: UID.key = "key.codecomplete.sort.useimportdepth"
            }
        }
        /// "key.column"
        public static let column: UID.key = "key.column"
        /// "key.compilerargs"
        public static let compilerargs: UID.key = "key.compilerargs"
        /// "key.conforms"
        public static let conforms: UID.key = "key.conforms"
        /// "key.containertypeusr"
        public static let containertypeusr: UID.key = "key.containertypeusr"
        /// "key.context"
        public static let context: UID.key = "key.context"
        /// "key.default_implementation_of"
        public static let default_implementation_of: UID.key = "key.default_implementation_of"
        /// "key.dependencies"
        public static let dependencies: UID.key = "key.dependencies"
        /// "key.deprecated"
        public static let deprecated: UID.key = "key.deprecated"
        /// "key.description"
        public static let description: UID.key = "key.description"
        /// "key.diagnostic_stage"
        public static let diagnostic_stage: UID.key = "key.diagnostic_stage"
        /// "key.diagnostics"
        public static let diagnostics: UID.key = "key.diagnostics"
        public struct doc {
            /// "key.doc.brief"
            public static let brief: UID.key = "key.doc.brief"
            /// "key.doc.full_as_xml"
            public static let full_as_xml: UID.key = "key.doc.full_as_xml"
        }
        /// "key.duration"
        public static let duration: UID.key = "key.duration"
        public struct editor {
            public struct format {
                /// "key.editor.format.indentwidth"
                public static let indentwidth: UID.key = "key.editor.format.indentwidth"
                /// "key.editor.format.options"
                public static let options: UID.key = "key.editor.format.options"
                /// "key.editor.format.tabwidth"
                public static let tabwidth: UID.key = "key.editor.format.tabwidth"
                /// "key.editor.format.usetabs"
                public static let usetabs: UID.key = "key.editor.format.usetabs"
            }
        }
        /// "key.elements"
        public static let elements: UID.key = "key.elements"
        /// "key.enablediagnostics"
        public static let enablediagnostics: UID.key = "key.enablediagnostics"
        /// "key.enablesubstructure"
        public static let enablesubstructure: UID.key = "key.enablesubstructure"
        /// "key.enablesyntaxmap"
        public static let enablesyntaxmap: UID.key = "key.enablesyntaxmap"
        /// "key.entities"
        public static let entities: UID.key = "key.entities"
        /// "key.extends"
        public static let extends: UID.key = "key.extends"
        /// "key.filepath"
        public static let filepath: UID.key = "key.filepath"
        /// "key.fixits"
        public static let fixits: UID.key = "key.fixits"
        /// "key.fully_annotated_decl"
        public static let fully_annotated_decl: UID.key = "key.fully_annotated_decl"
        /// "key.generic_params"
        public static let generic_params: UID.key = "key.generic_params"
        /// "key.generic_requirements"
        public static let generic_requirements: UID.key = "key.generic_requirements"
        /// "key.groupname"
        public static let groupname: UID.key = "key.groupname"
        /// "key.hash"
        public static let hash: UID.key = "key.hash"
        /// "key.hide"
        public static let hide: UID.key = "key.hide"
        /// "key.inheritedtypes"
        public static let inheritedtypes: UID.key = "key.inheritedtypes"
        /// "key.inherits"
        public static let inherits: UID.key = "key.inherits"
        /// "key.interested_usr"
        public static let interested_usr: UID.key = "key.interested_usr"
        /// "key.introduced"
        public static let introduced: UID.key = "key.introduced"
        /// "key.is_deprecated"
        public static let is_deprecated: UID.key = "key.is_deprecated"
        /// "key.is_dynamic"
        public static let is_dynamic: UID.key = "key.is_dynamic"
        /// "key.is_local"
        public static let is_local: UID.key = "key.is_local"
        /// "key.is_optional"
        public static let is_optional: UID.key = "key.is_optional"
        /// "key.is_system"
        public static let is_system: UID.key = "key.is_system"
        /// "key.is_test_candidate"
        public static let is_test_candidate: UID.key = "key.is_test_candidate"
        /// "key.is_unavailable"
        public static let is_unavailable: UID.key = "key.is_unavailable"
        /// "key.keyword"
        public static let keyword: UID.key = "key.keyword"
        /// "key.kind"
        public static let kind: UID.key = "key.kind"
        /// "key.length"
        public static let length: UID.key = "key.length"
        /// "key.line"
        public static let line: UID.key = "key.line"
        /// "key.message"
        public static let message: UID.key = "key.message"
        /// "key.module_interface_name"
        public static let module_interface_name: UID.key = "key.module_interface_name"
        /// "key.modulegroups"
        public static let modulegroups: UID.key = "key.modulegroups"
        /// "key.moduleimportdepth"
        public static let moduleimportdepth: UID.key = "key.moduleimportdepth"
        /// "key.modulename"
        public static let modulename: UID.key = "key.modulename"
        /// "key.name"
        public static let name: UID.key = "key.name"
        /// "key.namelength"
        public static let namelength: UID.key = "key.namelength"
        /// "key.nameoffset"
        public static let nameoffset: UID.key = "key.nameoffset"
        /// "key.names"
        public static let names: UID.key = "key.names"
        /// "key.nextrequeststart"
        public static let nextrequeststart: UID.key = "key.nextrequeststart"
        /// "key.not_recommended"
        public static let not_recommended: UID.key = "key.not_recommended"
        /// "key.notification"
        public static let notification: UID.key = "key.notification"
        /// "key.num_bytes_to_erase"
        public static let num_bytes_to_erase: UID.key = "key.num_bytes_to_erase"
        /// "key.obsoleted"
        public static let obsoleted: UID.key = "key.obsoleted"
        /// "key.offset"
        public static let offset: UID.key = "key.offset"
        /// "key.original_usr"
        public static let original_usr: UID.key = "key.original_usr"
        /// "key.overrides"
        public static let overrides: UID.key = "key.overrides"
        /// "key.platform"
        public static let platform: UID.key = "key.platform"
        /// "key.popular"
        public static let popular: UID.key = "key.popular"
        /// "key.ranges"
        public static let ranges: UID.key = "key.ranges"
        /// "key.receiver_usr"
        public static let receiver_usr: UID.key = "key.receiver_usr"
        /// "key.related"
        public static let related: UID.key = "key.related"
        /// "key.related_decls"
        public static let related_decls: UID.key = "key.related_decls"
        /// "key.removecache"
        public static let removecache: UID.key = "key.removecache"
        /// "key.request"
        public static let request: UID.key = "key.request"
        /// "key.results"
        public static let results: UID.key = "key.results"
        /// "key.runtime_name"
        public static let runtime_name: UID.key = "key.runtime_name"
        /// "key.selector_name"
        public static let selector_name: UID.key = "key.selector_name"
        /// "key.setter_accessibility"
        public static let setter_accessibility: UID.key = "key.setter_accessibility"
        /// "key.severity"
        public static let severity: UID.key = "key.severity"
        /// "key.simplified"
        public static let simplified: UID.key = "key.simplified"
        /// "key.sourcefile"
        public static let sourcefile: UID.key = "key.sourcefile"
        /// "key.sourcetext"
        public static let sourcetext: UID.key = "key.sourcetext"
        /// "key.substructure"
        public static let substructure: UID.key = "key.substructure"
        /// "key.syntactic_only"
        public static let syntactic_only: UID.key = "key.syntactic_only"
        /// "key.syntaxmap"
        public static let syntaxmap: UID.key = "key.syntaxmap"
        /// "key.synthesizedextensions"
        public static let synthesizedextensions: UID.key = "key.synthesizedextensions"
        /// "key.throwlength"
        public static let throwlength: UID.key = "key.throwlength"
        /// "key.throwoffset"
        public static let throwoffset: UID.key = "key.throwoffset"
        /// "key.typeinterface"
        public static let typeinterface: UID.key = "key.typeinterface"
        /// "key.typename"
        public static let typename: UID.key = "key.typename"
        /// "key.typeusr"
        public static let typeusr: UID.key = "key.typeusr"
        /// "key.uids"
        public static let uids: UID.key = "key.uids"
        /// "key.unpopular"
        public static let unpopular: UID.key = "key.unpopular"
        /// "key.usr"
        public static let usr: UID.key = "key.usr"
        /// "key.version_major"
        public static let version_major: UID.key = "key.version_major"
        /// "key.version_minor"
        public static let version_minor: UID.key = "key.version_minor"
    }
    public struct source {
        public struct availability {
            public struct platform: UIDNamespace {
                public let uid: UID
                /// "source.availability.platform.ios"
                public static let ios: UID.source.availability.platform = "source.availability.platform.ios"
                /// "source.availability.platform.ios_app_extension"
                public static let ios_app_extension: UID.source.availability.platform = "source.availability.platform.ios_app_extension"
                /// "source.availability.platform.osx"
                public static let osx: UID.source.availability.platform = "source.availability.platform.osx"
                /// "source.availability.platform.osx_app_extension"
                public static let osx_app_extension: UID.source.availability.platform = "source.availability.platform.osx_app_extension"
                /// "source.availability.platform.tvos"
                public static let tvos: UID.source.availability.platform = "source.availability.platform.tvos"
                /// "source.availability.platform.tvos_app_extension"
                public static let tvos_app_extension: UID.source.availability.platform = "source.availability.platform.tvos_app_extension"
                /// "source.availability.platform.watchos"
                public static let watchos: UID.source.availability.platform = "source.availability.platform.watchos"
                /// "source.availability.platform.watchos_app_extension"
                public static let watchos_app_extension: UID.source.availability.platform = "source.availability.platform.watchos_app_extension"
            }
        }
        public struct codecompletion: UIDNamespace {
            public let uid: UID
            public struct context {
                /// "source.codecompletion.context.exprspecific"
                public static let exprspecific: UID.source.codecompletion = "source.codecompletion.context.exprspecific"
                /// "source.codecompletion.context.local"
                public static let local: UID.source.codecompletion = "source.codecompletion.context.local"
                /// "source.codecompletion.context.none"
                public static let none: UID.source.codecompletion = "source.codecompletion.context.none"
                /// "source.codecompletion.context.otherclass"
                public static let otherclass: UID.source.codecompletion = "source.codecompletion.context.otherclass"
                /// "source.codecompletion.context.othermodule"
                public static let othermodule: UID.source.codecompletion = "source.codecompletion.context.othermodule"
                /// "source.codecompletion.context.superclass"
                public static let superclass: UID.source.codecompletion = "source.codecompletion.context.superclass"
                /// "source.codecompletion.context.thisclass"
                public static let thisclass: UID.source.codecompletion = "source.codecompletion.context.thisclass"
                /// "source.codecompletion.context.thismodule"
                public static let thismodule: UID.source.codecompletion = "source.codecompletion.context.thismodule"
            }
            /// "source.codecompletion.custom"
            public static let custom: UID.source.codecompletion = "source.codecompletion.custom"
            /// "source.codecompletion.everything"
            public static let everything: UID.source.codecompletion = "source.codecompletion.everything"
            /// "source.codecompletion.identifier"
            public static let identifier: UID.source.codecompletion = "source.codecompletion.identifier"
            /// "source.codecompletion.keyword"
            public static let keyword: UID.source.codecompletion = "source.codecompletion.keyword"
            /// "source.codecompletion.literal"
            public static let literal: UID.source.codecompletion = "source.codecompletion.literal"
            /// "source.codecompletion.module"
            public static let module: UID.source.codecompletion = "source.codecompletion.module"
        }
        public struct decl {
            public struct attribute: UIDNamespace {
                public let uid: UID
                /// "source.decl.attribute.LLDBDebuggerFunction"
                public static let LLDBDebuggerFunction: UID.source.decl.attribute = "source.decl.attribute.LLDBDebuggerFunction"
                /// "source.decl.attribute.NSApplicationMain"
                public static let NSApplicationMain: UID.source.decl.attribute = "source.decl.attribute.NSApplicationMain"
                /// "source.decl.attribute.NSCopying"
                public static let NSCopying: UID.source.decl.attribute = "source.decl.attribute.NSCopying"
                /// "source.decl.attribute.NSManaged"
                public static let NSManaged: UID.source.decl.attribute = "source.decl.attribute.NSManaged"
                /// "source.decl.attribute.UIApplicationMain"
                public static let UIApplicationMain: UID.source.decl.attribute = "source.decl.attribute.UIApplicationMain"
                /// "source.decl.attribute.__objc_bridged"
                public static let __objc_bridged: UID.source.decl.attribute = "source.decl.attribute.__objc_bridged"
                /// "source.decl.attribute.__synthesized_protocol"
                public static let __synthesized_protocol: UID.source.decl.attribute = "source.decl.attribute.__synthesized_protocol"
                /// "source.decl.attribute._alignment"
                public static let _alignment: UID.source.decl.attribute = "source.decl.attribute._alignment"
                /// "source.decl.attribute._cdecl"
                public static let _cdecl: UID.source.decl.attribute = "source.decl.attribute._cdecl"
                /// "source.decl.attribute._exported"
                public static let _exported: UID.source.decl.attribute = "source.decl.attribute._exported"
                /// "source.decl.attribute._fixed_layout"
                public static let _fixed_layout: UID.source.decl.attribute = "source.decl.attribute._fixed_layout"
                /// "source.decl.attribute._semantics"
                public static let _semantics: UID.source.decl.attribute = "source.decl.attribute._semantics"
                /// "source.decl.attribute._silgen_name"
                public static let _silgen_name: UID.source.decl.attribute = "source.decl.attribute._silgen_name"
                /// "source.decl.attribute._specialize"
                public static let _specialize: UID.source.decl.attribute = "source.decl.attribute._specialize"
                /// "source.decl.attribute._swift_native_objc_runtime_base"
                public static let _swift_native_objc_runtime_base: UID.source.decl.attribute = "source.decl.attribute._swift_native_objc_runtime_base"
                /// "source.decl.attribute._transparent"
                public static let _transparent: UID.source.decl.attribute = "source.decl.attribute._transparent"
                /// "source.decl.attribute._versioned"
                public static let _versioned: UID.source.decl.attribute = "source.decl.attribute._versioned"
                /// "source.decl.attribute.autoclosure"
                public static let autoclosure: UID.source.decl.attribute = "source.decl.attribute.autoclosure"
                /// "source.decl.attribute.available"
                public static let available: UID.source.decl.attribute = "source.decl.attribute.available"
                /// "source.decl.attribute.convenience"
                public static let convenience: UID.source.decl.attribute = "source.decl.attribute.convenience"
                /// "source.decl.attribute.discardableResult"
                public static let discardableResult: UID.source.decl.attribute = "source.decl.attribute.discardableResult"
                /// "source.decl.attribute.dynamic"
                public static let dynamic: UID.source.decl.attribute = "source.decl.attribute.dynamic"
                /// "source.decl.attribute.effects"
                public static let effects: UID.source.decl.attribute = "source.decl.attribute.effects"
                /// "source.decl.attribute.escaping"
                public static let escaping: UID.source.decl.attribute = "source.decl.attribute.escaping"
                /// "source.decl.attribute.final"
                public static let final: UID.source.decl.attribute = "source.decl.attribute.final"
                /// "source.decl.attribute.gkinspectable"
                public static let gkinspectable: UID.source.decl.attribute = "source.decl.attribute.gkinspectable"
                /// "source.decl.attribute.ibaction"
                public static let ibaction: UID.source.decl.attribute = "source.decl.attribute.ibaction"
                /// "source.decl.attribute.ibdesignable"
                public static let ibdesignable: UID.source.decl.attribute = "source.decl.attribute.ibdesignable"
                /// "source.decl.attribute.ibinspectable"
                public static let ibinspectable: UID.source.decl.attribute = "source.decl.attribute.ibinspectable"
                /// "source.decl.attribute.iboutlet"
                public static let iboutlet: UID.source.decl.attribute = "source.decl.attribute.iboutlet"
                /// "source.decl.attribute.indirect"
                public static let indirect: UID.source.decl.attribute = "source.decl.attribute.indirect"
                /// "source.decl.attribute.infix"
                public static let infix: UID.source.decl.attribute = "source.decl.attribute.infix"
                /// "source.decl.attribute.inline"
                public static let inline: UID.source.decl.attribute = "source.decl.attribute.inline"
                /// "source.decl.attribute.lazy"
                public static let lazy: UID.source.decl.attribute = "source.decl.attribute.lazy"
                /// "source.decl.attribute.mutating"
                public static let mutating: UID.source.decl.attribute = "source.decl.attribute.mutating"
                /// "source.decl.attribute.noescape"
                public static let noescape: UID.source.decl.attribute = "source.decl.attribute.noescape"
                /// "source.decl.attribute.nonmutating"
                public static let nonmutating: UID.source.decl.attribute = "source.decl.attribute.nonmutating"
                /// "source.decl.attribute.nonobjc"
                public static let nonobjc: UID.source.decl.attribute = "source.decl.attribute.nonobjc"
                /// "source.decl.attribute.noreturn"
                public static let noreturn: UID.source.decl.attribute = "source.decl.attribute.noreturn"
                public struct objc {
                    /// "source.decl.attribute.objc.name"
                    public static let name: UID.source.decl.attribute = "source.decl.attribute.objc.name"
                }
                /// "source.decl.attribute.objc_non_lazy_realization"
                public static let objc_non_lazy_realization: UID.source.decl.attribute = "source.decl.attribute.objc_non_lazy_realization"
                /// "source.decl.attribute.optional"
                public static let optional: UID.source.decl.attribute = "source.decl.attribute.optional"
                /// "source.decl.attribute.override"
                public static let override: UID.source.decl.attribute = "source.decl.attribute.override"
                /// "source.decl.attribute.postfix"
                public static let postfix: UID.source.decl.attribute = "source.decl.attribute.postfix"
                /// "source.decl.attribute.prefix"
                public static let prefix: UID.source.decl.attribute = "source.decl.attribute.prefix"
                /// "source.decl.attribute.required"
                public static let required: UID.source.decl.attribute = "source.decl.attribute.required"
                /// "source.decl.attribute.requires_stored_property_inits"
                public static let requires_stored_property_inits: UID.source.decl.attribute = "source.decl.attribute.requires_stored_property_inits"
                /// "source.decl.attribute.rethrows"
                public static let `rethrows`: UID.source.decl.attribute = "source.decl.attribute.rethrows"
                /// "source.decl.attribute.sil_stored"
                public static let sil_stored: UID.source.decl.attribute = "source.decl.attribute.sil_stored"
                /// "source.decl.attribute.swift3_migration"
                public static let swift3_migration: UID.source.decl.attribute = "source.decl.attribute.swift3_migration"
                /// "source.decl.attribute.testable"
                public static let testable: UID.source.decl.attribute = "source.decl.attribute.testable"
                /// "source.decl.attribute.unsafe_no_objc_tagged_pointer"
                public static let unsafe_no_objc_tagged_pointer: UID.source.decl.attribute = "source.decl.attribute.unsafe_no_objc_tagged_pointer"
                /// "source.decl.attribute.warn_unqualified_access"
                public static let warn_unqualified_access: UID.source.decl.attribute = "source.decl.attribute.warn_unqualified_access"
                /// "source.decl.attribute.weak"
                public static let weak: UID.source.decl.attribute = "source.decl.attribute.weak"
            }
        }
        public struct diagnostic {
            public struct severity: UIDNamespace {
                public let uid: UID
                /// "source.diagnostic.severity.error"
                public static let error: UID.source.diagnostic.severity = "source.diagnostic.severity.error"
                /// "source.diagnostic.severity.note"
                public static let note: UID.source.diagnostic.severity = "source.diagnostic.severity.note"
                /// "source.diagnostic.severity.warning"
                public static let warning: UID.source.diagnostic.severity = "source.diagnostic.severity.warning"
            }
            public struct stage {
                public struct swift: UIDNamespace {
                    public let uid: UID
                    /// "source.diagnostic.stage.swift.parse"
                    public static let parse: UID.source.diagnostic.stage.swift = "source.diagnostic.stage.swift.parse"
                    /// "source.diagnostic.stage.swift.sema"
                    public static let sema: UID.source.diagnostic.stage.swift = "source.diagnostic.stage.swift.sema"
                }
            }
        }
        public struct lang {
            public struct swift: UIDNamespace {
                public let uid: UID
                /// "source.lang.swift.pattern"
                public static let pattern: UID.source.lang.swift = "source.lang.swift.pattern"
                /// "source.lang.swift.type"
                public static let type: UID.source.lang.swift = "source.lang.swift.type"
                public struct accessibility: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.accessibility.fileprivate"
                    public static let `fileprivate`: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.fileprivate"
                    /// "source.lang.swift.accessibility.internal"
                    public static let `internal`: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.internal"
                    /// "source.lang.swift.accessibility.open"
                    public static let open: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.open"
                    /// "source.lang.swift.accessibility.private"
                    public static let `private`: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.private"
                    /// "source.lang.swift.accessibility.public"
                    public static let `public`: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.public"
                }
                public struct attribute: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.attribute.availability"
                    public static let availability: UID.source.lang.swift.attribute = "source.lang.swift.attribute.availability"
                }
                public struct codecomplete: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.codecomplete.group"
                    public static let group: UID.source.lang.swift.codecomplete = "source.lang.swift.codecomplete.group"
                }
                public struct decl: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.decl.associatedtype"
                    public static let `associatedtype`: UID.source.lang.swift.decl = "source.lang.swift.decl.associatedtype"
                    /// "source.lang.swift.decl.class"
                    public static let `class`: UID.source.lang.swift.decl = "source.lang.swift.decl.class"
                    /// "source.lang.swift.decl.enum"
                    public static let `enum`: UID.source.lang.swift.decl = "source.lang.swift.decl.enum"
                    /// "source.lang.swift.decl.enumcase"
                    public static let enumcase: UID.source.lang.swift.decl = "source.lang.swift.decl.enumcase"
                    /// "source.lang.swift.decl.enumelement"
                    public static let enumelement: UID.source.lang.swift.decl = "source.lang.swift.decl.enumelement"
                    public struct `extension` {
                        /// "source.lang.swift.decl.extension.class"
                        public static let `class`: UID.source.lang.swift.decl = "source.lang.swift.decl.extension.class"
                        /// "source.lang.swift.decl.extension.enum"
                        public static let `enum`: UID.source.lang.swift.decl = "source.lang.swift.decl.extension.enum"
                        /// "source.lang.swift.decl.extension.protocol"
                        public static let `protocol`: UID.source.lang.swift.decl = "source.lang.swift.decl.extension.protocol"
                        /// "source.lang.swift.decl.extension.struct"
                        public static let `struct`: UID.source.lang.swift.decl = "source.lang.swift.decl.extension.struct"
                    }
                    public struct function {
                        public struct accessor {
                            /// "source.lang.swift.decl.function.accessor.address"
                            public static let address: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.address"
                            /// "source.lang.swift.decl.function.accessor.didset"
                            public static let didset: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.didset"
                            /// "source.lang.swift.decl.function.accessor.getter"
                            public static let getter: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.getter"
                            /// "source.lang.swift.decl.function.accessor.mutableaddress"
                            public static let mutableaddress: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.mutableaddress"
                            /// "source.lang.swift.decl.function.accessor.setter"
                            public static let setter: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.setter"
                            /// "source.lang.swift.decl.function.accessor.willset"
                            public static let willset: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.willset"
                        }
                        /// "source.lang.swift.decl.function.constructor"
                        public static let constructor: UID.source.lang.swift.decl = "source.lang.swift.decl.function.constructor"
                        /// "source.lang.swift.decl.function.destructor"
                        public static let destructor: UID.source.lang.swift.decl = "source.lang.swift.decl.function.destructor"
                        /// "source.lang.swift.decl.function.free"
                        public static let free: UID.source.lang.swift.decl = "source.lang.swift.decl.function.free"
                        public struct method {
                            /// "source.lang.swift.decl.function.method.class"
                            public static let `class`: UID.source.lang.swift.decl = "source.lang.swift.decl.function.method.class"
                            /// "source.lang.swift.decl.function.method.instance"
                            public static let instance: UID.source.lang.swift.decl = "source.lang.swift.decl.function.method.instance"
                            /// "source.lang.swift.decl.function.method.static"
                            public static let `static`: UID.source.lang.swift.decl = "source.lang.swift.decl.function.method.static"
                        }
                        public struct `operator` {
                            /// "source.lang.swift.decl.function.operator.infix"
                            public static let infix: UID.source.lang.swift.decl = "source.lang.swift.decl.function.operator.infix"
                            /// "source.lang.swift.decl.function.operator.postfix"
                            public static let postfix: UID.source.lang.swift.decl = "source.lang.swift.decl.function.operator.postfix"
                            /// "source.lang.swift.decl.function.operator.prefix"
                            public static let prefix: UID.source.lang.swift.decl = "source.lang.swift.decl.function.operator.prefix"
                        }
                        /// "source.lang.swift.decl.function.subscript"
                        public static let `subscript`: UID.source.lang.swift.decl = "source.lang.swift.decl.function.subscript"
                    }
                    /// "source.lang.swift.decl.generic_type_param"
                    public static let generic_type_param: UID.source.lang.swift.decl = "source.lang.swift.decl.generic_type_param"
                    /// "source.lang.swift.decl.module"
                    public static let module: UID.source.lang.swift.decl = "source.lang.swift.decl.module"
                    /// "source.lang.swift.decl.precedencegroup"
                    public static let `precedencegroup`: UID.source.lang.swift.decl = "source.lang.swift.decl.precedencegroup"
                    /// "source.lang.swift.decl.protocol"
                    public static let `protocol`: UID.source.lang.swift.decl = "source.lang.swift.decl.protocol"
                    /// "source.lang.swift.decl.struct"
                    public static let `struct`: UID.source.lang.swift.decl = "source.lang.swift.decl.struct"
                    /// "source.lang.swift.decl.typealias"
                    public static let `typealias`: UID.source.lang.swift.decl = "source.lang.swift.decl.typealias"
                    public struct `var` {
                        /// "source.lang.swift.decl.var.class"
                        public static let `class`: UID.source.lang.swift.decl = "source.lang.swift.decl.var.class"
                        /// "source.lang.swift.decl.var.global"
                        public static let global: UID.source.lang.swift.decl = "source.lang.swift.decl.var.global"
                        /// "source.lang.swift.decl.var.instance"
                        public static let instance: UID.source.lang.swift.decl = "source.lang.swift.decl.var.instance"
                        /// "source.lang.swift.decl.var.local"
                        public static let local: UID.source.lang.swift.decl = "source.lang.swift.decl.var.local"
                        /// "source.lang.swift.decl.var.parameter"
                        public static let parameter: UID.source.lang.swift.decl = "source.lang.swift.decl.var.parameter"
                        /// "source.lang.swift.decl.var.static"
                        public static let `static`: UID.source.lang.swift.decl = "source.lang.swift.decl.var.static"
                    }
                }
                public struct expr: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.expr.argument"
                    public static let argument: UID.source.lang.swift.expr = "source.lang.swift.expr.argument"
                    /// "source.lang.swift.expr.array"
                    public static let array: UID.source.lang.swift.expr = "source.lang.swift.expr.array"
                    /// "source.lang.swift.expr.call"
                    public static let call: UID.source.lang.swift.expr = "source.lang.swift.expr.call"
                    /// "source.lang.swift.expr.dictionary"
                    public static let dictionary: UID.source.lang.swift.expr = "source.lang.swift.expr.dictionary"
                    /// "source.lang.swift.expr.object_literal"
                    public static let object_literal: UID.source.lang.swift.expr = "source.lang.swift.expr.object_literal"
                }
                public struct `import` {
                    public struct module: UIDNamespace {
                        public let uid: UID
                        /// "source.lang.swift.import.module.clang"
                        public static let clang: UID.source.lang.swift.`import`.module = "source.lang.swift.import.module.clang"
                        /// "source.lang.swift.import.module.swift"
                        public static let swift: UID.source.lang.swift.`import`.module = "source.lang.swift.import.module.swift"
                    }
                }
                public struct keyword: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.keyword.Any"
                    public static let `Any`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.Any"
                    /// "source.lang.swift.keyword.Self"
                    public static let `Self`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.Self"
                    /// "source.lang.swift.keyword._"
                    public static let `_`: UID.source.lang.swift.keyword = "source.lang.swift.keyword._"
                    /// "source.lang.swift.keyword.__COLUMN__"
                    public static let `__COLUMN__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__COLUMN__"
                    /// "source.lang.swift.keyword.__DSO_HANDLE__"
                    public static let `__DSO_HANDLE__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__DSO_HANDLE__"
                    /// "source.lang.swift.keyword.__FILE__"
                    public static let `__FILE__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__FILE__"
                    /// "source.lang.swift.keyword.__FUNCTION__"
                    public static let `__FUNCTION__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__FUNCTION__"
                    /// "source.lang.swift.keyword.__LINE__"
                    public static let `__LINE__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__LINE__"
                    /// "source.lang.swift.keyword.as"
                    public static let `as`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.as"
                    /// "source.lang.swift.keyword.associatedtype"
                    public static let `associatedtype`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.associatedtype"
                    /// "source.lang.swift.keyword.break"
                    public static let `break`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.break"
                    /// "source.lang.swift.keyword.case"
                    public static let `case`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.case"
                    /// "source.lang.swift.keyword.catch"
                    public static let `catch`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.catch"
                    /// "source.lang.swift.keyword.class"
                    public static let `class`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.class"
                    /// "source.lang.swift.keyword.continue"
                    public static let `continue`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.continue"
                    /// "source.lang.swift.keyword.default"
                    public static let `default`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.default"
                    /// "source.lang.swift.keyword.defer"
                    public static let `defer`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.defer"
                    /// "source.lang.swift.keyword.deinit"
                    public static let `deinit`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.deinit"
                    /// "source.lang.swift.keyword.do"
                    public static let `do`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.do"
                    /// "source.lang.swift.keyword.else"
                    public static let `else`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.else"
                    /// "source.lang.swift.keyword.enum"
                    public static let `enum`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.enum"
                    /// "source.lang.swift.keyword.extension"
                    public static let `extension`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.extension"
                    /// "source.lang.swift.keyword.fallthrough"
                    public static let `fallthrough`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.fallthrough"
                    /// "source.lang.swift.keyword.false"
                    public static let `false`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.false"
                    /// "source.lang.swift.keyword.fileprivate"
                    public static let `fileprivate`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.fileprivate"
                    /// "source.lang.swift.keyword.for"
                    public static let `for`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.for"
                    /// "source.lang.swift.keyword.func"
                    public static let `func`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.func"
                    /// "source.lang.swift.keyword.guard"
                    public static let `guard`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.guard"
                    /// "source.lang.swift.keyword.if"
                    public static let `if`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.if"
                    /// "source.lang.swift.keyword.import"
                    public static let `import`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.import"
                    /// "source.lang.swift.keyword.in"
                    public static let `in`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.in"
                    /// "source.lang.swift.keyword.init"
                    public static let `init`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.init"
                    /// "source.lang.swift.keyword.inout"
                    public static let `inout`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.inout"
                    /// "source.lang.swift.keyword.internal"
                    public static let `internal`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.internal"
                    /// "source.lang.swift.keyword.is"
                    public static let `is`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.is"
                    /// "source.lang.swift.keyword.let"
                    public static let `let`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.let"
                    /// "source.lang.swift.keyword.nil"
                    public static let `nil`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.nil"
                    /// "source.lang.swift.keyword.operator"
                    public static let `operator`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.operator"
                    /// "source.lang.swift.keyword.precedencegroup"
                    public static let `precedencegroup`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.precedencegroup"
                    /// "source.lang.swift.keyword.private"
                    public static let `private`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.private"
                    /// "source.lang.swift.keyword.protocol"
                    public static let `protocol`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.protocol"
                    /// "source.lang.swift.keyword.public"
                    public static let `public`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.public"
                    /// "source.lang.swift.keyword.repeat"
                    public static let `repeat`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.repeat"
                    /// "source.lang.swift.keyword.rethrows"
                    public static let `rethrows`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.rethrows"
                    /// "source.lang.swift.keyword.return"
                    public static let `return`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.return"
                    /// "source.lang.swift.keyword.self"
                    public static let `self`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.self"
                    /// "source.lang.swift.keyword.static"
                    public static let `static`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.static"
                    /// "source.lang.swift.keyword.struct"
                    public static let `struct`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.struct"
                    /// "source.lang.swift.keyword.subscript"
                    public static let `subscript`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.subscript"
                    /// "source.lang.swift.keyword.super"
                    public static let `super`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.super"
                    /// "source.lang.swift.keyword.switch"
                    public static let `switch`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.switch"
                    /// "source.lang.swift.keyword.throw"
                    public static let `throw`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.throw"
                    /// "source.lang.swift.keyword.throws"
                    public static let `throws`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.throws"
                    /// "source.lang.swift.keyword.true"
                    public static let `true`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.true"
                    /// "source.lang.swift.keyword.try"
                    public static let `try`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.try"
                    /// "source.lang.swift.keyword.typealias"
                    public static let `typealias`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.typealias"
                    /// "source.lang.swift.keyword.var"
                    public static let `var`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.var"
                    /// "source.lang.swift.keyword.where"
                    public static let `where`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.where"
                    /// "source.lang.swift.keyword.while"
                    public static let `while`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.while"
                }
                public struct literal: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.literal.array"
                    public static let array: UID.source.lang.swift.literal = "source.lang.swift.literal.array"
                    /// "source.lang.swift.literal.boolean"
                    public static let boolean: UID.source.lang.swift.literal = "source.lang.swift.literal.boolean"
                    /// "source.lang.swift.literal.color"
                    public static let color: UID.source.lang.swift.literal = "source.lang.swift.literal.color"
                    /// "source.lang.swift.literal.dictionary"
                    public static let dictionary: UID.source.lang.swift.literal = "source.lang.swift.literal.dictionary"
                    /// "source.lang.swift.literal.image"
                    public static let image: UID.source.lang.swift.literal = "source.lang.swift.literal.image"
                    /// "source.lang.swift.literal.integer"
                    public static let integer: UID.source.lang.swift.literal = "source.lang.swift.literal.integer"
                    /// "source.lang.swift.literal.nil"
                    public static let `nil`: UID.source.lang.swift.literal = "source.lang.swift.literal.nil"
                    /// "source.lang.swift.literal.string"
                    public static let string: UID.source.lang.swift.literal = "source.lang.swift.literal.string"
                    /// "source.lang.swift.literal.tuple"
                    public static let tuple: UID.source.lang.swift.literal = "source.lang.swift.literal.tuple"
                }
                public struct ref: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.ref.associatedtype"
                    public static let `associatedtype`: UID.source.lang.swift.ref = "source.lang.swift.ref.associatedtype"
                    /// "source.lang.swift.ref.class"
                    public static let `class`: UID.source.lang.swift.ref = "source.lang.swift.ref.class"
                    /// "source.lang.swift.ref.enum"
                    public static let `enum`: UID.source.lang.swift.ref = "source.lang.swift.ref.enum"
                    /// "source.lang.swift.ref.enumelement"
                    public static let enumelement: UID.source.lang.swift.ref = "source.lang.swift.ref.enumelement"
                    public struct function {
                        public struct accessor {
                            /// "source.lang.swift.ref.function.accessor.address"
                            public static let address: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.address"
                            /// "source.lang.swift.ref.function.accessor.didset"
                            public static let didset: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.didset"
                            /// "source.lang.swift.ref.function.accessor.getter"
                            public static let getter: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.getter"
                            /// "source.lang.swift.ref.function.accessor.mutableaddress"
                            public static let mutableaddress: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.mutableaddress"
                            /// "source.lang.swift.ref.function.accessor.setter"
                            public static let setter: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.setter"
                            /// "source.lang.swift.ref.function.accessor.willset"
                            public static let willset: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.willset"
                        }
                        /// "source.lang.swift.ref.function.constructor"
                        public static let constructor: UID.source.lang.swift.ref = "source.lang.swift.ref.function.constructor"
                        /// "source.lang.swift.ref.function.destructor"
                        public static let destructor: UID.source.lang.swift.ref = "source.lang.swift.ref.function.destructor"
                        /// "source.lang.swift.ref.function.free"
                        public static let free: UID.source.lang.swift.ref = "source.lang.swift.ref.function.free"
                        public struct method {
                            /// "source.lang.swift.ref.function.method.class"
                            public static let `class`: UID.source.lang.swift.ref = "source.lang.swift.ref.function.method.class"
                            /// "source.lang.swift.ref.function.method.instance"
                            public static let instance: UID.source.lang.swift.ref = "source.lang.swift.ref.function.method.instance"
                            /// "source.lang.swift.ref.function.method.static"
                            public static let `static`: UID.source.lang.swift.ref = "source.lang.swift.ref.function.method.static"
                        }
                        public struct `operator` {
                            /// "source.lang.swift.ref.function.operator.infix"
                            public static let infix: UID.source.lang.swift.ref = "source.lang.swift.ref.function.operator.infix"
                            /// "source.lang.swift.ref.function.operator.postfix"
                            public static let postfix: UID.source.lang.swift.ref = "source.lang.swift.ref.function.operator.postfix"
                            /// "source.lang.swift.ref.function.operator.prefix"
                            public static let prefix: UID.source.lang.swift.ref = "source.lang.swift.ref.function.operator.prefix"
                        }
                        /// "source.lang.swift.ref.function.subscript"
                        public static let `subscript`: UID.source.lang.swift.ref = "source.lang.swift.ref.function.subscript"
                    }
                    /// "source.lang.swift.ref.generic_type_param"
                    public static let generic_type_param: UID.source.lang.swift.ref = "source.lang.swift.ref.generic_type_param"
                    /// "source.lang.swift.ref.module"
                    public static let module: UID.source.lang.swift.ref = "source.lang.swift.ref.module"
                    /// "source.lang.swift.ref.precedencegroup"
                    public static let `precedencegroup`: UID.source.lang.swift.ref = "source.lang.swift.ref.precedencegroup"
                    /// "source.lang.swift.ref.protocol"
                    public static let `protocol`: UID.source.lang.swift.ref = "source.lang.swift.ref.protocol"
                    /// "source.lang.swift.ref.struct"
                    public static let `struct`: UID.source.lang.swift.ref = "source.lang.swift.ref.struct"
                    /// "source.lang.swift.ref.typealias"
                    public static let `typealias`: UID.source.lang.swift.ref = "source.lang.swift.ref.typealias"
                    public struct `var` {
                        /// "source.lang.swift.ref.var.class"
                        public static let `class`: UID.source.lang.swift.ref = "source.lang.swift.ref.var.class"
                        /// "source.lang.swift.ref.var.global"
                        public static let global: UID.source.lang.swift.ref = "source.lang.swift.ref.var.global"
                        /// "source.lang.swift.ref.var.instance"
                        public static let instance: UID.source.lang.swift.ref = "source.lang.swift.ref.var.instance"
                        /// "source.lang.swift.ref.var.local"
                        public static let local: UID.source.lang.swift.ref = "source.lang.swift.ref.var.local"
                        /// "source.lang.swift.ref.var.static"
                        public static let `static`: UID.source.lang.swift.ref = "source.lang.swift.ref.var.static"
                    }
                }
                public struct stmt: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.stmt.brace"
                    public static let brace: UID.source.lang.swift.stmt = "source.lang.swift.stmt.brace"
                    /// "source.lang.swift.stmt.case"
                    public static let `case`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.case"
                    /// "source.lang.swift.stmt.for"
                    public static let `for`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.for"
                    /// "source.lang.swift.stmt.foreach"
                    public static let foreach: UID.source.lang.swift.stmt = "source.lang.swift.stmt.foreach"
                    /// "source.lang.swift.stmt.guard"
                    public static let `guard`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.guard"
                    /// "source.lang.swift.stmt.if"
                    public static let `if`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.if"
                    /// "source.lang.swift.stmt.repeatwhile"
                    public static let repeatwhile: UID.source.lang.swift.stmt = "source.lang.swift.stmt.repeatwhile"
                    /// "source.lang.swift.stmt.switch"
                    public static let `switch`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.switch"
                    /// "source.lang.swift.stmt.while"
                    public static let `while`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.while"
                }
                public struct structure {
                    public struct elem: UIDNamespace {
                        public let uid: UID
                        /// "source.lang.swift.structure.elem.condition_expr"
                        public static let condition_expr: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.condition_expr"
                        /// "source.lang.swift.structure.elem.expr"
                        public static let expr: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.expr"
                        /// "source.lang.swift.structure.elem.id"
                        public static let id: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.id"
                        /// "source.lang.swift.structure.elem.init_expr"
                        public static let init_expr: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.init_expr"
                        /// "source.lang.swift.structure.elem.pattern"
                        public static let pattern: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.pattern"
                        /// "source.lang.swift.structure.elem.typeref"
                        public static let typeref: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.typeref"
                    }
                }
                public struct syntaxtype: UIDNamespace {
                    public let uid: UID
                    /// "source.lang.swift.syntaxtype.argument"
                    public static let argument: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.argument"
                    public struct attribute {
                        /// "source.lang.swift.syntaxtype.attribute.builtin"
                        public static let builtin: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.attribute.builtin"
                        /// "source.lang.swift.syntaxtype.attribute.id"
                        public static let id: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.attribute.id"
                    }
                    public struct buildconfig {
                        /// "source.lang.swift.syntaxtype.buildconfig.id"
                        public static let id: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.buildconfig.id"
                        /// "source.lang.swift.syntaxtype.buildconfig.keyword"
                        public static let keyword: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.buildconfig.keyword"
                    }
                    public struct comment {
                        /// "source.lang.swift.syntaxtype.comment.mark"
                        public static let mark: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.comment.mark"
                        /// "source.lang.swift.syntaxtype.comment.url"
                        public static let url: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.comment.url"
                    }
                    public struct doccomment {
                        /// "source.lang.swift.syntaxtype.doccomment.field"
                        public static let field: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.doccomment.field"
                    }
                    /// "source.lang.swift.syntaxtype.identifier"
                    public static let identifier: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.identifier"
                    /// "source.lang.swift.syntaxtype.keyword"
                    public static let keyword: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.keyword"
                    /// "source.lang.swift.syntaxtype.number"
                    public static let number: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.number"
                    /// "source.lang.swift.syntaxtype.objectliteral"
                    public static let objectliteral: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.objectliteral"
                    /// "source.lang.swift.syntaxtype.parameter"
                    public static let parameter: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.parameter"
                    /// "source.lang.swift.syntaxtype.placeholder"
                    public static let placeholder: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.placeholder"
                    /// "source.lang.swift.syntaxtype.string"
                    public static let string: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.string"
                    /// "source.lang.swift.syntaxtype.string_interpolation_anchor"
                    public static let string_interpolation_anchor: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.string_interpolation_anchor"
                    /// "source.lang.swift.syntaxtype.typeidentifier"
                    public static let typeidentifier: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.typeidentifier"
                }
            }
        }
        public struct notification: UIDNamespace {
            public let uid: UID
            public struct editor {
                /// "source.notification.editor.documentupdate"
                public static let documentupdate: UID.source.notification = "source.notification.editor.documentupdate"
            }
            /// "source.notification.sema_disabled"
            public static let sema_disabled: UID.source.notification = "source.notification.sema_disabled"
        }
        public struct request: UIDNamespace {
            public let uid: UID
            public struct buildsettings {
                /// "source.request.buildsettings.register"
                public static let register: UID.source.request = "source.request.buildsettings.register"
            }
            public struct codecomplete {
                public struct cache {
                    /// "source.request.codecomplete.cache.ondisk"
                    public static let ondisk: UID.source.request = "source.request.codecomplete.cache.ondisk"
                }
                /// "source.request.codecomplete.close"
                public static let close: UID.source.request = "source.request.codecomplete.close"
                /// "source.request.codecomplete.open"
                public static let open: UID.source.request = "source.request.codecomplete.open"
                /// "source.request.codecomplete.setcustom"
                public static let setcustom: UID.source.request = "source.request.codecomplete.setcustom"
                /// "source.request.codecomplete.setpopularapi"
                public static let setpopularapi: UID.source.request = "source.request.codecomplete.setpopularapi"
                /// "source.request.codecomplete.update"
                public static let update: UID.source.request = "source.request.codecomplete.update"
            }
            /// "source.request.crash_exit"
            public static let crash_exit: UID.source.request = "source.request.crash_exit"
            /// "source.request.cursorinfo"
            public static let cursorinfo: UID.source.request = "source.request.cursorinfo"
            /// "source.request.demangle"
            public static let demangle: UID.source.request = "source.request.demangle"
            /// "source.request.docinfo"
            public static let docinfo: UID.source.request = "source.request.docinfo"
            public struct editor {
                /// "source.request.editor.close"
                public static let close: UID.source.request = "source.request.editor.close"
                /// "source.request.editor.expand_placeholder"
                public static let expand_placeholder: UID.source.request = "source.request.editor.expand_placeholder"
                public struct extract {
                    /// "source.request.editor.extract.comment"
                    public static let comment: UID.source.request = "source.request.editor.extract.comment"
                }
                /// "source.request.editor.find_interface_doc"
                public static let find_interface_doc: UID.source.request = "source.request.editor.find_interface_doc"
                /// "source.request.editor.find_usr"
                public static let find_usr: UID.source.request = "source.request.editor.find_usr"
                /// "source.request.editor.formattext"
                public static let formattext: UID.source.request = "source.request.editor.formattext"
                public struct open {
                    public struct interface {
                        /// "source.request.editor.open.interface.header"
                        public static let header: UID.source.request = "source.request.editor.open.interface.header"
                        /// "source.request.editor.open.interface.swiftsource"
                        public static let swiftsource: UID.source.request = "source.request.editor.open.interface.swiftsource"
                        /// "source.request.editor.open.interface.swifttype"
                        public static let swifttype: UID.source.request = "source.request.editor.open.interface.swifttype"
                    }
                }
                /// "source.request.editor.replacetext"
                public static let replacetext: UID.source.request = "source.request.editor.replacetext"
            }
            /// "source.request.indexsource"
            public static let indexsource: UID.source.request = "source.request.indexsource"
            /// "source.request.mangle_simple_class"
            public static let mangle_simple_class: UID.source.request = "source.request.mangle_simple_class"
            public struct module {
                /// "source.request.module.groups"
                public static let groups: UID.source.request = "source.request.module.groups"
            }
            /// "source.request.protocol_version"
            public static let protocol_version: UID.source.request = "source.request.protocol_version"
            /// "source.request.relatedidents"
            public static let relatedidents: UID.source.request = "source.request.relatedidents"
        }
    }
}

extension UID.key {
    public static func ==(lhs: UID, rhs: UID.key) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.key, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.key) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.key, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.availability.platform {
    public static func ==(lhs: UID, rhs: UID.source.availability.platform) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.availability.platform, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.availability.platform) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.availability.platform, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.codecompletion {
    public static func ==(lhs: UID, rhs: UID.source.codecompletion) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.codecompletion, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.codecompletion) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.codecompletion, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.decl.attribute {
    public static func ==(lhs: UID, rhs: UID.source.decl.attribute) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.decl.attribute, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.decl.attribute) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.decl.attribute, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.diagnostic.severity {
    public static func ==(lhs: UID, rhs: UID.source.diagnostic.severity) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.diagnostic.severity, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.diagnostic.severity) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.diagnostic.severity, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.diagnostic.stage.swift {
    public static func ==(lhs: UID, rhs: UID.source.diagnostic.stage.swift) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.diagnostic.stage.swift, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.diagnostic.stage.swift) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.diagnostic.stage.swift, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.accessibility {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.accessibility) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.accessibility, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.accessibility) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.accessibility, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.attribute {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.attribute) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.attribute, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.attribute) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.attribute, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.codecomplete {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.codecomplete) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.codecomplete, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.codecomplete) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.codecomplete, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.decl {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.decl) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.decl, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.decl) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.decl, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.expr {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.expr) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.expr, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.expr) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.expr, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.`import`.module {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.`import`.module) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.`import`.module, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.`import`.module) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.`import`.module, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.keyword {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.keyword) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.keyword, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.keyword) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.keyword, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.literal {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.literal) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.literal, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.literal) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.literal, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.ref {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.ref) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.ref, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.ref) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.ref, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.stmt {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.stmt) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.stmt, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.stmt) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.stmt, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.structure.elem {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.structure.elem) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.structure.elem, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.structure.elem) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.structure.elem, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.lang.swift.syntaxtype {
    public static func ==(lhs: UID, rhs: UID.source.lang.swift.syntaxtype) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.lang.swift.syntaxtype, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.lang.swift.syntaxtype) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.lang.swift.syntaxtype, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.notification {
    public static func ==(lhs: UID, rhs: UID.source.notification) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.notification, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.notification) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.notification, rhs: UID?) -> Bool { return rhs == lhs }
    public init(stringLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(unicodeScalarLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: type(of: self)._inferUID(from: value)) }
}
extension UID.source.request {
    public static func ==(lhs: UID, rhs: UID.source.request) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: UID.source.request, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: UID.source.request) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: UID.source.request, rhs: UID?) -> Bool { return rhs == lhs }
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
