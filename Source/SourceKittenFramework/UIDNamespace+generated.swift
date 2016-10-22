public struct key: UIDNamespace {
    public let uid: UID
    public init(uid: UID) { self.uid = uid }
    public static func ==(lhs: UID, rhs: key) -> Bool { return lhs == rhs.uid }
    public static func ==(lhs: key, rhs: UID) -> Bool { return rhs == lhs }
    public static func ==(lhs: UID?, rhs: key) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
    public static func ==(lhs: key, rhs: UID?) -> Bool { return rhs == lhs }
    public static let accessibility = leaf("key.accessibility")
    public static let annotated_decl = leaf("key.annotated_decl")
    public static let annotations = leaf("key.annotations")
    public static let associated_usrs = leaf("key.associated_usrs")
    public static let attribute = leaf("key.attribute")
    public static let attributes = leaf("key.attributes")
    public static let bodylength = leaf("key.bodylength")
    public static let bodyoffset = leaf("key.bodyoffset")
    public struct codecomplete: UIDNamespace {
        public let uid: UID
        public init(uid: UID) { self.uid = uid }
        public static func ==(lhs: UID, rhs: codecomplete) -> Bool { return lhs == rhs.uid }
        public static func ==(lhs: codecomplete, rhs: UID) -> Bool { return rhs == lhs }
        public static func ==(lhs: UID?, rhs: codecomplete) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
        public static func ==(lhs: codecomplete, rhs: UID?) -> Bool { return rhs == lhs }
        public static let addinitstotoplevel = leaf("key.codecomplete.addinitstotoplevel")
        public static let addinneroperators = leaf("key.codecomplete.addinneroperators")
        public static let addinnerresults = leaf("key.codecomplete.addinnerresults")
        public static let filterrules = leaf("key.codecomplete.filterrules")
        public static let filtertext = leaf("key.codecomplete.filtertext")
        public static let fuzzymatching = leaf("key.codecomplete.fuzzymatching")
        public struct group: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: group) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: group, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: group) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: group, rhs: UID?) -> Bool { return rhs == lhs }
            public static let overloads = leaf("key.codecomplete.group.overloads")
            public static let stems = leaf("key.codecomplete.group.stems")
        }
        public static let hidebyname = leaf("key.codecomplete.hidebyname")
        public static let hidelowpriority = leaf("key.codecomplete.hidelowpriority")
        public static let hideunderscores = leaf("key.codecomplete.hideunderscores")
        public static let includeexactmatch = leaf("key.codecomplete.includeexactmatch")
        public static let options = leaf("key.codecomplete.options")
        public static let requestlimit = leaf("key.codecomplete.requestlimit")
        public static let requeststart = leaf("key.codecomplete.requeststart")
        public static let showtopnonliteralresults = leaf("key.codecomplete.showtopnonliteralresults")
        public struct sort: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: sort) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: sort, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: sort) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: sort, rhs: UID?) -> Bool { return rhs == lhs }
            public static let byname = leaf("key.codecomplete.sort.byname")
            public static let contextweight = leaf("key.codecomplete.sort.contextweight")
            public static let fuzzyweight = leaf("key.codecomplete.sort.fuzzyweight")
            public static let popularitybonus = leaf("key.codecomplete.sort.popularitybonus")
            public static let useimportdepth = leaf("key.codecomplete.sort.useimportdepth")
        }
    }
    public static let column = leaf("key.column")
    public static let compilerargs = leaf("key.compilerargs")
    public static let conforms = leaf("key.conforms")
    public static let containertypeusr = leaf("key.containertypeusr")
    public static let context = leaf("key.context")
    public static let default_implementation_of = leaf("key.default_implementation_of")
    public static let dependencies = leaf("key.dependencies")
    public static let deprecated = leaf("key.deprecated")
    public static let description = leaf("key.description")
    public static let diagnostic_stage = leaf("key.diagnostic_stage")
    public static let diagnostics = leaf("key.diagnostics")
    public struct doc: UIDNamespace {
        public let uid: UID
        public init(uid: UID) { self.uid = uid }
        public static func ==(lhs: UID, rhs: doc) -> Bool { return lhs == rhs.uid }
        public static func ==(lhs: doc, rhs: UID) -> Bool { return rhs == lhs }
        public static func ==(lhs: UID?, rhs: doc) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
        public static func ==(lhs: doc, rhs: UID?) -> Bool { return rhs == lhs }
        public static let brief = leaf("key.doc.brief")
        public static let full_as_xml = leaf("key.doc.full_as_xml")
    }
    public static let duration = leaf("key.duration")
    public struct editor {
        public struct format: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: format) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: format, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: format) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: format, rhs: UID?) -> Bool { return rhs == lhs }
            public static let indentwidth = leaf("key.editor.format.indentwidth")
            public static let options = leaf("key.editor.format.options")
            public static let tabwidth = leaf("key.editor.format.tabwidth")
            public static let usetabs = leaf("key.editor.format.usetabs")
        }
    }
    public static let elements = leaf("key.elements")
    public static let enablediagnostics = leaf("key.enablediagnostics")
    public static let enablesubstructure = leaf("key.enablesubstructure")
    public static let enablesyntaxmap = leaf("key.enablesyntaxmap")
    public static let entities = leaf("key.entities")
    public static let extends = leaf("key.extends")
    public static let filepath = leaf("key.filepath")
    public static let fixits = leaf("key.fixits")
    public static let fully_annotated_decl = leaf("key.fully_annotated_decl")
    public static let generic_params = leaf("key.generic_params")
    public static let generic_requirements = leaf("key.generic_requirements")
    public static let groupname = leaf("key.groupname")
    public static let hash = leaf("key.hash")
    public static let hide = leaf("key.hide")
    public static let inheritedtypes = leaf("key.inheritedtypes")
    public static let inherits = leaf("key.inherits")
    public static let interested_usr = leaf("key.interested_usr")
    public static let introduced = leaf("key.introduced")
    public static let is_deprecated = leaf("key.is_deprecated")
    public static let is_dynamic = leaf("key.is_dynamic")
    public static let is_local = leaf("key.is_local")
    public static let is_optional = leaf("key.is_optional")
    public static let is_system = leaf("key.is_system")
    public static let is_test_candidate = leaf("key.is_test_candidate")
    public static let is_unavailable = leaf("key.is_unavailable")
    public static let keyword = leaf("key.keyword")
    public static let kind = leaf("key.kind")
    public static let length = leaf("key.length")
    public static let line = leaf("key.line")
    public static let message = leaf("key.message")
    public static let module_interface_name = leaf("key.module_interface_name")
    public static let modulegroups = leaf("key.modulegroups")
    public static let moduleimportdepth = leaf("key.moduleimportdepth")
    public static let modulename = leaf("key.modulename")
    public static let name = leaf("key.name")
    public static let namelength = leaf("key.namelength")
    public static let nameoffset = leaf("key.nameoffset")
    public static let names = leaf("key.names")
    public static let nextrequeststart = leaf("key.nextrequeststart")
    public static let not_recommended = leaf("key.not_recommended")
    public static let notification = leaf("key.notification")
    public static let num_bytes_to_erase = leaf("key.num_bytes_to_erase")
    public static let obsoleted = leaf("key.obsoleted")
    public static let offset = leaf("key.offset")
    public static let original_usr = leaf("key.original_usr")
    public static let overrides = leaf("key.overrides")
    public static let platform = leaf("key.platform")
    public static let popular = leaf("key.popular")
    public static let ranges = leaf("key.ranges")
    public static let receiver_usr = leaf("key.receiver_usr")
    public static let related = leaf("key.related")
    public static let related_decls = leaf("key.related_decls")
    public static let removecache = leaf("key.removecache")
    public static let request = leaf("key.request")
    public static let results = leaf("key.results")
    public static let runtime_name = leaf("key.runtime_name")
    public static let selector_name = leaf("key.selector_name")
    public static let setter_accessibility = leaf("key.setter_accessibility")
    public static let severity = leaf("key.severity")
    public static let simplified = leaf("key.simplified")
    public static let sourcefile = leaf("key.sourcefile")
    public static let sourcetext = leaf("key.sourcetext")
    public static let substructure = leaf("key.substructure")
    public static let syntactic_only = leaf("key.syntactic_only")
    public static let syntaxmap = leaf("key.syntaxmap")
    public static let synthesizedextensions = leaf("key.synthesizedextensions")
    public static let throwlength = leaf("key.throwlength")
    public static let throwoffset = leaf("key.throwoffset")
    public static let typeinterface = leaf("key.typeinterface")
    public static let typename = leaf("key.typename")
    public static let typeusr = leaf("key.typeusr")
    public static let uids = leaf("key.uids")
    public static let unpopular = leaf("key.unpopular")
    public static let usr = leaf("key.usr")
    public static let version_major = leaf("key.version_major")
    public static let version_minor = leaf("key.version_minor")
}
public struct source {
    public struct availability {
        public struct platform: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: platform) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: platform, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: platform) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: platform, rhs: UID?) -> Bool { return rhs == lhs }
            public static let ios = leaf("source.availability.platform.ios")
            public static let ios_app_extension = leaf("source.availability.platform.ios_app_extension")
            public static let osx = leaf("source.availability.platform.osx")
            public static let osx_app_extension = leaf("source.availability.platform.osx_app_extension")
            public static let tvos = leaf("source.availability.platform.tvos")
            public static let tvos_app_extension = leaf("source.availability.platform.tvos_app_extension")
            public static let watchos = leaf("source.availability.platform.watchos")
            public static let watchos_app_extension = leaf("source.availability.platform.watchos_app_extension")
        }
    }
    public struct codecompletion: UIDNamespace {
        public let uid: UID
        public init(uid: UID) { self.uid = uid }
        public static func ==(lhs: UID, rhs: codecompletion) -> Bool { return lhs == rhs.uid }
        public static func ==(lhs: codecompletion, rhs: UID) -> Bool { return rhs == lhs }
        public static func ==(lhs: UID?, rhs: codecompletion) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
        public static func ==(lhs: codecompletion, rhs: UID?) -> Bool { return rhs == lhs }
        public struct context: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: context) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: context, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: context) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: context, rhs: UID?) -> Bool { return rhs == lhs }
            public static let exprspecific = leaf("source.codecompletion.context.exprspecific")
            public static let local = leaf("source.codecompletion.context.local")
            public static let none = leaf("source.codecompletion.context.none")
            public static let otherclass = leaf("source.codecompletion.context.otherclass")
            public static let othermodule = leaf("source.codecompletion.context.othermodule")
            public static let superclass = leaf("source.codecompletion.context.superclass")
            public static let thisclass = leaf("source.codecompletion.context.thisclass")
            public static let thismodule = leaf("source.codecompletion.context.thismodule")
        }
        public static let custom = leaf("source.codecompletion.custom")
        public static let everything = leaf("source.codecompletion.everything")
        public static let identifier = leaf("source.codecompletion.identifier")
        public static let keyword = leaf("source.codecompletion.keyword")
        public static let literal = leaf("source.codecompletion.literal")
        public static let module = leaf("source.codecompletion.module")
    }
    public struct decl {
        public struct attribute: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: attribute) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: attribute, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: attribute) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: attribute, rhs: UID?) -> Bool { return rhs == lhs }
            public static let LLDBDebuggerFunction = leaf("source.decl.attribute.LLDBDebuggerFunction")
            public static let NSApplicationMain = leaf("source.decl.attribute.NSApplicationMain")
            public static let NSCopying = leaf("source.decl.attribute.NSCopying")
            public static let NSManaged = leaf("source.decl.attribute.NSManaged")
            public static let UIApplicationMain = leaf("source.decl.attribute.UIApplicationMain")
            public static let __objc_bridged = leaf("source.decl.attribute.__objc_bridged")
            public static let __synthesized_protocol = leaf("source.decl.attribute.__synthesized_protocol")
            public static let _alignment = leaf("source.decl.attribute._alignment")
            public static let _cdecl = leaf("source.decl.attribute._cdecl")
            public static let _exported = leaf("source.decl.attribute._exported")
            public static let _fixed_layout = leaf("source.decl.attribute._fixed_layout")
            public static let _semantics = leaf("source.decl.attribute._semantics")
            public static let _silgen_name = leaf("source.decl.attribute._silgen_name")
            public static let _specialize = leaf("source.decl.attribute._specialize")
            public static let _swift_native_objc_runtime_base = leaf("source.decl.attribute._swift_native_objc_runtime_base")
            public static let _transparent = leaf("source.decl.attribute._transparent")
            public static let _versioned = leaf("source.decl.attribute._versioned")
            public static let autoclosure = leaf("source.decl.attribute.autoclosure")
            public static let available = leaf("source.decl.attribute.available")
            public static let convenience = leaf("source.decl.attribute.convenience")
            public static let discardableResult = leaf("source.decl.attribute.discardableResult")
            public static let dynamic = leaf("source.decl.attribute.dynamic")
            public static let effects = leaf("source.decl.attribute.effects")
            public static let escaping = leaf("source.decl.attribute.escaping")
            public static let final = leaf("source.decl.attribute.final")
            public static let gkinspectable = leaf("source.decl.attribute.gkinspectable")
            public static let ibaction = leaf("source.decl.attribute.ibaction")
            public static let ibdesignable = leaf("source.decl.attribute.ibdesignable")
            public static let ibinspectable = leaf("source.decl.attribute.ibinspectable")
            public static let iboutlet = leaf("source.decl.attribute.iboutlet")
            public static let indirect = leaf("source.decl.attribute.indirect")
            public static let infix = leaf("source.decl.attribute.infix")
            public static let inline = leaf("source.decl.attribute.inline")
            public static let lazy = leaf("source.decl.attribute.lazy")
            public static let mutating = leaf("source.decl.attribute.mutating")
            public static let noescape = leaf("source.decl.attribute.noescape")
            public static let nonmutating = leaf("source.decl.attribute.nonmutating")
            public static let nonobjc = leaf("source.decl.attribute.nonobjc")
            public static let noreturn = leaf("source.decl.attribute.noreturn")
            public struct objc: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: objc) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: objc, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: objc) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: objc, rhs: UID?) -> Bool { return rhs == lhs }
                public static let name = leaf("source.decl.attribute.objc.name")
            }
            public static let objc_non_lazy_realization = leaf("source.decl.attribute.objc_non_lazy_realization")
            public static let optional = leaf("source.decl.attribute.optional")
            public static let override = leaf("source.decl.attribute.override")
            public static let postfix = leaf("source.decl.attribute.postfix")
            public static let prefix = leaf("source.decl.attribute.prefix")
            public static let required = leaf("source.decl.attribute.required")
            public static let requires_stored_property_inits = leaf("source.decl.attribute.requires_stored_property_inits")
            public static let `rethrows` = leaf("source.decl.attribute.rethrows")
            public static let sil_stored = leaf("source.decl.attribute.sil_stored")
            public static let swift3_migration = leaf("source.decl.attribute.swift3_migration")
            public static let testable = leaf("source.decl.attribute.testable")
            public static let unsafe_no_objc_tagged_pointer = leaf("source.decl.attribute.unsafe_no_objc_tagged_pointer")
            public static let warn_unqualified_access = leaf("source.decl.attribute.warn_unqualified_access")
            public static let weak = leaf("source.decl.attribute.weak")
        }
    }
    public struct diagnostic {
        public struct severity: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: severity) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: severity, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: severity) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: severity, rhs: UID?) -> Bool { return rhs == lhs }
            public static let error = leaf("source.diagnostic.severity.error")
            public static let note = leaf("source.diagnostic.severity.note")
            public static let warning = leaf("source.diagnostic.severity.warning")
        }
        public struct stage {
            public struct swift: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: swift) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: swift, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: swift) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: swift, rhs: UID?) -> Bool { return rhs == lhs }
                public static let parse = leaf("source.diagnostic.stage.swift.parse")
                public static let sema = leaf("source.diagnostic.stage.swift.sema")
            }
        }
    }
    public struct lang {
        public struct swift: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: swift) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: swift, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: swift) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: swift, rhs: UID?) -> Bool { return rhs == lhs }
            public struct accessibility: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: accessibility) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: accessibility, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: accessibility) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: accessibility, rhs: UID?) -> Bool { return rhs == lhs }
                public static let `fileprivate` = leaf("source.lang.swift.accessibility.fileprivate")
                public static let `internal` = leaf("source.lang.swift.accessibility.internal")
                public static let open = leaf("source.lang.swift.accessibility.open")
                public static let `private` = leaf("source.lang.swift.accessibility.private")
                public static let `public` = leaf("source.lang.swift.accessibility.public")
            }
            public struct attribute: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: attribute) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: attribute, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: attribute) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: attribute, rhs: UID?) -> Bool { return rhs == lhs }
                public static let availability = leaf("source.lang.swift.attribute.availability")
            }
            public struct codecomplete: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: codecomplete) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: codecomplete, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: codecomplete) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: codecomplete, rhs: UID?) -> Bool { return rhs == lhs }
                public static let group = leaf("source.lang.swift.codecomplete.group")
            }
            public struct decl: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: decl) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: decl, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: decl) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: decl, rhs: UID?) -> Bool { return rhs == lhs }
                public static let `associatedtype` = leaf("source.lang.swift.decl.associatedtype")
                public static let `class` = leaf("source.lang.swift.decl.class")
                public static let `enum` = leaf("source.lang.swift.decl.enum")
                public static let enumcase = leaf("source.lang.swift.decl.enumcase")
                public static let enumelement = leaf("source.lang.swift.decl.enumelement")
                public struct `extension`: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: `extension`) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: `extension`, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: `extension`) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: `extension`, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let `class` = leaf("source.lang.swift.decl.extension.class")
                    public static let `enum` = leaf("source.lang.swift.decl.extension.enum")
                    public static let `protocol` = leaf("source.lang.swift.decl.extension.protocol")
                    public static let `struct` = leaf("source.lang.swift.decl.extension.struct")
                }
                public struct function: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: function) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: function, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: function) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: function, rhs: UID?) -> Bool { return rhs == lhs }
                    public struct accessor: UIDNamespace {
                        public let uid: UID
                        public init(uid: UID) { self.uid = uid }
                        public static func ==(lhs: UID, rhs: accessor) -> Bool { return lhs == rhs.uid }
                        public static func ==(lhs: accessor, rhs: UID) -> Bool { return rhs == lhs }
                        public static func ==(lhs: UID?, rhs: accessor) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                        public static func ==(lhs: accessor, rhs: UID?) -> Bool { return rhs == lhs }
                        public static let address = leaf("source.lang.swift.decl.function.accessor.address")
                        public static let didset = leaf("source.lang.swift.decl.function.accessor.didset")
                        public static let getter = leaf("source.lang.swift.decl.function.accessor.getter")
                        public static let mutableaddress = leaf("source.lang.swift.decl.function.accessor.mutableaddress")
                        public static let setter = leaf("source.lang.swift.decl.function.accessor.setter")
                        public static let willset = leaf("source.lang.swift.decl.function.accessor.willset")
                    }
                    public static let constructor = leaf("source.lang.swift.decl.function.constructor")
                    public static let destructor = leaf("source.lang.swift.decl.function.destructor")
                    public static let free = leaf("source.lang.swift.decl.function.free")
                    public struct method: UIDNamespace {
                        public let uid: UID
                        public init(uid: UID) { self.uid = uid }
                        public static func ==(lhs: UID, rhs: method) -> Bool { return lhs == rhs.uid }
                        public static func ==(lhs: method, rhs: UID) -> Bool { return rhs == lhs }
                        public static func ==(lhs: UID?, rhs: method) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                        public static func ==(lhs: method, rhs: UID?) -> Bool { return rhs == lhs }
                        public static let `class` = leaf("source.lang.swift.decl.function.method.class")
                        public static let instance = leaf("source.lang.swift.decl.function.method.instance")
                        public static let `static` = leaf("source.lang.swift.decl.function.method.static")
                    }
                    public struct `operator`: UIDNamespace {
                        public let uid: UID
                        public init(uid: UID) { self.uid = uid }
                        public static func ==(lhs: UID, rhs: `operator`) -> Bool { return lhs == rhs.uid }
                        public static func ==(lhs: `operator`, rhs: UID) -> Bool { return rhs == lhs }
                        public static func ==(lhs: UID?, rhs: `operator`) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                        public static func ==(lhs: `operator`, rhs: UID?) -> Bool { return rhs == lhs }
                        public static let infix = leaf("source.lang.swift.decl.function.operator.infix")
                        public static let postfix = leaf("source.lang.swift.decl.function.operator.postfix")
                        public static let prefix = leaf("source.lang.swift.decl.function.operator.prefix")
                    }
                    public static let `subscript` = leaf("source.lang.swift.decl.function.subscript")
                }
                public static let generic_type_param = leaf("source.lang.swift.decl.generic_type_param")
                public static let module = leaf("source.lang.swift.decl.module")
                public static let `precedencegroup` = leaf("source.lang.swift.decl.precedencegroup")
                public static let `protocol` = leaf("source.lang.swift.decl.protocol")
                public static let `struct` = leaf("source.lang.swift.decl.struct")
                public static let `typealias` = leaf("source.lang.swift.decl.typealias")
                public struct `var`: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: `var`) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: `var`, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: `var`) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: `var`, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let `class` = leaf("source.lang.swift.decl.var.class")
                    public static let global = leaf("source.lang.swift.decl.var.global")
                    public static let instance = leaf("source.lang.swift.decl.var.instance")
                    public static let local = leaf("source.lang.swift.decl.var.local")
                    public static let parameter = leaf("source.lang.swift.decl.var.parameter")
                    public static let `static` = leaf("source.lang.swift.decl.var.static")
                }
            }
            public struct expr: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: expr) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: expr, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: expr) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: expr, rhs: UID?) -> Bool { return rhs == lhs }
                public static let argument = leaf("source.lang.swift.expr.argument")
                public static let array = leaf("source.lang.swift.expr.array")
                public static let call = leaf("source.lang.swift.expr.call")
                public static let dictionary = leaf("source.lang.swift.expr.dictionary")
                public static let object_literal = leaf("source.lang.swift.expr.object_literal")
            }
            public struct `import` {
                public struct module: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: module) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: module, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: module) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: module, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let clang = leaf("source.lang.swift.import.module.clang")
                    public static let swift = leaf("source.lang.swift.import.module.swift")
                }
            }
            public struct keyword: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: keyword) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: keyword, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: keyword) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: keyword, rhs: UID?) -> Bool { return rhs == lhs }
                public static let `Any` = leaf("source.lang.swift.keyword.Any")
                public static let `Self` = leaf("source.lang.swift.keyword.Self")
                public static let `_` = leaf("source.lang.swift.keyword._")
                public static let `__COLUMN__` = leaf("source.lang.swift.keyword.__COLUMN__")
                public static let `__DSO_HANDLE__` = leaf("source.lang.swift.keyword.__DSO_HANDLE__")
                public static let `__FILE__` = leaf("source.lang.swift.keyword.__FILE__")
                public static let `__FUNCTION__` = leaf("source.lang.swift.keyword.__FUNCTION__")
                public static let `__LINE__` = leaf("source.lang.swift.keyword.__LINE__")
                public static let `as` = leaf("source.lang.swift.keyword.as")
                public static let `associatedtype` = leaf("source.lang.swift.keyword.associatedtype")
                public static let `break` = leaf("source.lang.swift.keyword.break")
                public static let `case` = leaf("source.lang.swift.keyword.case")
                public static let `catch` = leaf("source.lang.swift.keyword.catch")
                public static let `class` = leaf("source.lang.swift.keyword.class")
                public static let `continue` = leaf("source.lang.swift.keyword.continue")
                public static let `default` = leaf("source.lang.swift.keyword.default")
                public static let `defer` = leaf("source.lang.swift.keyword.defer")
                public static let `deinit` = leaf("source.lang.swift.keyword.deinit")
                public static let `do` = leaf("source.lang.swift.keyword.do")
                public static let `else` = leaf("source.lang.swift.keyword.else")
                public static let `enum` = leaf("source.lang.swift.keyword.enum")
                public static let `extension` = leaf("source.lang.swift.keyword.extension")
                public static let `fallthrough` = leaf("source.lang.swift.keyword.fallthrough")
                public static let `false` = leaf("source.lang.swift.keyword.false")
                public static let `fileprivate` = leaf("source.lang.swift.keyword.fileprivate")
                public static let `for` = leaf("source.lang.swift.keyword.for")
                public static let `func` = leaf("source.lang.swift.keyword.func")
                public static let `guard` = leaf("source.lang.swift.keyword.guard")
                public static let `if` = leaf("source.lang.swift.keyword.if")
                public static let `import` = leaf("source.lang.swift.keyword.import")
                public static let `in` = leaf("source.lang.swift.keyword.in")
                public static let `init` = leaf("source.lang.swift.keyword.init")
                public static let `inout` = leaf("source.lang.swift.keyword.inout")
                public static let `internal` = leaf("source.lang.swift.keyword.internal")
                public static let `is` = leaf("source.lang.swift.keyword.is")
                public static let `let` = leaf("source.lang.swift.keyword.let")
                public static let `nil` = leaf("source.lang.swift.keyword.nil")
                public static let `operator` = leaf("source.lang.swift.keyword.operator")
                public static let `precedencegroup` = leaf("source.lang.swift.keyword.precedencegroup")
                public static let `private` = leaf("source.lang.swift.keyword.private")
                public static let `protocol` = leaf("source.lang.swift.keyword.protocol")
                public static let `public` = leaf("source.lang.swift.keyword.public")
                public static let `repeat` = leaf("source.lang.swift.keyword.repeat")
                public static let `rethrows` = leaf("source.lang.swift.keyword.rethrows")
                public static let `return` = leaf("source.lang.swift.keyword.return")
                public static let `self` = leaf("source.lang.swift.keyword.self")
                public static let `static` = leaf("source.lang.swift.keyword.static")
                public static let `struct` = leaf("source.lang.swift.keyword.struct")
                public static let `subscript` = leaf("source.lang.swift.keyword.subscript")
                public static let `super` = leaf("source.lang.swift.keyword.super")
                public static let `switch` = leaf("source.lang.swift.keyword.switch")
                public static let `throw` = leaf("source.lang.swift.keyword.throw")
                public static let `throws` = leaf("source.lang.swift.keyword.throws")
                public static let `true` = leaf("source.lang.swift.keyword.true")
                public static let `try` = leaf("source.lang.swift.keyword.try")
                public static let `typealias` = leaf("source.lang.swift.keyword.typealias")
                public static let `var` = leaf("source.lang.swift.keyword.var")
                public static let `where` = leaf("source.lang.swift.keyword.where")
                public static let `while` = leaf("source.lang.swift.keyword.while")
            }
            public struct literal: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: literal) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: literal, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: literal) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: literal, rhs: UID?) -> Bool { return rhs == lhs }
                public static let array = leaf("source.lang.swift.literal.array")
                public static let boolean = leaf("source.lang.swift.literal.boolean")
                public static let color = leaf("source.lang.swift.literal.color")
                public static let dictionary = leaf("source.lang.swift.literal.dictionary")
                public static let image = leaf("source.lang.swift.literal.image")
                public static let integer = leaf("source.lang.swift.literal.integer")
                public static let `nil` = leaf("source.lang.swift.literal.nil")
                public static let string = leaf("source.lang.swift.literal.string")
                public static let tuple = leaf("source.lang.swift.literal.tuple")
            }
            public static let pattern = leaf("source.lang.swift.pattern")
            public struct ref: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: ref) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: ref, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: ref) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: ref, rhs: UID?) -> Bool { return rhs == lhs }
                public static let `associatedtype` = leaf("source.lang.swift.ref.associatedtype")
                public static let `class` = leaf("source.lang.swift.ref.class")
                public static let `enum` = leaf("source.lang.swift.ref.enum")
                public static let enumelement = leaf("source.lang.swift.ref.enumelement")
                public struct function: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: function) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: function, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: function) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: function, rhs: UID?) -> Bool { return rhs == lhs }
                    public struct accessor: UIDNamespace {
                        public let uid: UID
                        public init(uid: UID) { self.uid = uid }
                        public static func ==(lhs: UID, rhs: accessor) -> Bool { return lhs == rhs.uid }
                        public static func ==(lhs: accessor, rhs: UID) -> Bool { return rhs == lhs }
                        public static func ==(lhs: UID?, rhs: accessor) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                        public static func ==(lhs: accessor, rhs: UID?) -> Bool { return rhs == lhs }
                        public static let address = leaf("source.lang.swift.ref.function.accessor.address")
                        public static let didset = leaf("source.lang.swift.ref.function.accessor.didset")
                        public static let getter = leaf("source.lang.swift.ref.function.accessor.getter")
                        public static let mutableaddress = leaf("source.lang.swift.ref.function.accessor.mutableaddress")
                        public static let setter = leaf("source.lang.swift.ref.function.accessor.setter")
                        public static let willset = leaf("source.lang.swift.ref.function.accessor.willset")
                    }
                    public static let constructor = leaf("source.lang.swift.ref.function.constructor")
                    public static let destructor = leaf("source.lang.swift.ref.function.destructor")
                    public static let free = leaf("source.lang.swift.ref.function.free")
                    public struct method: UIDNamespace {
                        public let uid: UID
                        public init(uid: UID) { self.uid = uid }
                        public static func ==(lhs: UID, rhs: method) -> Bool { return lhs == rhs.uid }
                        public static func ==(lhs: method, rhs: UID) -> Bool { return rhs == lhs }
                        public static func ==(lhs: UID?, rhs: method) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                        public static func ==(lhs: method, rhs: UID?) -> Bool { return rhs == lhs }
                        public static let `class` = leaf("source.lang.swift.ref.function.method.class")
                        public static let instance = leaf("source.lang.swift.ref.function.method.instance")
                        public static let `static` = leaf("source.lang.swift.ref.function.method.static")
                    }
                    public struct `operator`: UIDNamespace {
                        public let uid: UID
                        public init(uid: UID) { self.uid = uid }
                        public static func ==(lhs: UID, rhs: `operator`) -> Bool { return lhs == rhs.uid }
                        public static func ==(lhs: `operator`, rhs: UID) -> Bool { return rhs == lhs }
                        public static func ==(lhs: UID?, rhs: `operator`) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                        public static func ==(lhs: `operator`, rhs: UID?) -> Bool { return rhs == lhs }
                        public static let infix = leaf("source.lang.swift.ref.function.operator.infix")
                        public static let postfix = leaf("source.lang.swift.ref.function.operator.postfix")
                        public static let prefix = leaf("source.lang.swift.ref.function.operator.prefix")
                    }
                    public static let `subscript` = leaf("source.lang.swift.ref.function.subscript")
                }
                public static let generic_type_param = leaf("source.lang.swift.ref.generic_type_param")
                public static let module = leaf("source.lang.swift.ref.module")
                public static let `precedencegroup` = leaf("source.lang.swift.ref.precedencegroup")
                public static let `protocol` = leaf("source.lang.swift.ref.protocol")
                public static let `struct` = leaf("source.lang.swift.ref.struct")
                public static let `typealias` = leaf("source.lang.swift.ref.typealias")
                public struct `var`: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: `var`) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: `var`, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: `var`) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: `var`, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let `class` = leaf("source.lang.swift.ref.var.class")
                    public static let global = leaf("source.lang.swift.ref.var.global")
                    public static let instance = leaf("source.lang.swift.ref.var.instance")
                    public static let local = leaf("source.lang.swift.ref.var.local")
                    public static let `static` = leaf("source.lang.swift.ref.var.static")
                }
            }
            public struct stmt: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: stmt) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: stmt, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: stmt) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: stmt, rhs: UID?) -> Bool { return rhs == lhs }
                public static let brace = leaf("source.lang.swift.stmt.brace")
                public static let `case` = leaf("source.lang.swift.stmt.case")
                public static let `for` = leaf("source.lang.swift.stmt.for")
                public static let foreach = leaf("source.lang.swift.stmt.foreach")
                public static let `guard` = leaf("source.lang.swift.stmt.guard")
                public static let `if` = leaf("source.lang.swift.stmt.if")
                public static let repeatwhile = leaf("source.lang.swift.stmt.repeatwhile")
                public static let `switch` = leaf("source.lang.swift.stmt.switch")
                public static let `while` = leaf("source.lang.swift.stmt.while")
            }
            public struct structure {
                public struct elem: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: elem) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: elem, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: elem) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: elem, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let condition_expr = leaf("source.lang.swift.structure.elem.condition_expr")
                    public static let expr = leaf("source.lang.swift.structure.elem.expr")
                    public static let id = leaf("source.lang.swift.structure.elem.id")
                    public static let init_expr = leaf("source.lang.swift.structure.elem.init_expr")
                    public static let pattern = leaf("source.lang.swift.structure.elem.pattern")
                    public static let typeref = leaf("source.lang.swift.structure.elem.typeref")
                }
            }
            public struct syntaxtype: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: syntaxtype) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: syntaxtype, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: syntaxtype) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: syntaxtype, rhs: UID?) -> Bool { return rhs == lhs }
                public static let argument = leaf("source.lang.swift.syntaxtype.argument")
                public struct attribute: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: attribute) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: attribute, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: attribute) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: attribute, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let builtin = leaf("source.lang.swift.syntaxtype.attribute.builtin")
                    public static let id = leaf("source.lang.swift.syntaxtype.attribute.id")
                }
                public struct buildconfig: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: buildconfig) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: buildconfig, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: buildconfig) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: buildconfig, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let id = leaf("source.lang.swift.syntaxtype.buildconfig.id")
                    public static let keyword = leaf("source.lang.swift.syntaxtype.buildconfig.keyword")
                }
                public struct comment: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: comment) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: comment, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: comment) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: comment, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let mark = leaf("source.lang.swift.syntaxtype.comment.mark")
                    public static let url = leaf("source.lang.swift.syntaxtype.comment.url")
                }
                public struct doccomment: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: doccomment) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: doccomment, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: doccomment) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: doccomment, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let field = leaf("source.lang.swift.syntaxtype.doccomment.field")
                }
                public static let identifier = leaf("source.lang.swift.syntaxtype.identifier")
                public static let keyword = leaf("source.lang.swift.syntaxtype.keyword")
                public static let number = leaf("source.lang.swift.syntaxtype.number")
                public static let objectliteral = leaf("source.lang.swift.syntaxtype.objectliteral")
                public static let parameter = leaf("source.lang.swift.syntaxtype.parameter")
                public static let placeholder = leaf("source.lang.swift.syntaxtype.placeholder")
                public static let string = leaf("source.lang.swift.syntaxtype.string")
                public static let string_interpolation_anchor = leaf("source.lang.swift.syntaxtype.string_interpolation_anchor")
                public static let typeidentifier = leaf("source.lang.swift.syntaxtype.typeidentifier")
            }
            public static let type = leaf("source.lang.swift.type")
        }
    }
    public struct notification: UIDNamespace {
        public let uid: UID
        public init(uid: UID) { self.uid = uid }
        public static func ==(lhs: UID, rhs: notification) -> Bool { return lhs == rhs.uid }
        public static func ==(lhs: notification, rhs: UID) -> Bool { return rhs == lhs }
        public static func ==(lhs: UID?, rhs: notification) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
        public static func ==(lhs: notification, rhs: UID?) -> Bool { return rhs == lhs }
        public struct editor: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: editor) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: editor, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: editor) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: editor, rhs: UID?) -> Bool { return rhs == lhs }
            public static let documentupdate = leaf("source.notification.editor.documentupdate")
        }
        public static let sema_disabled = leaf("source.notification.sema_disabled")
    }
    public struct request: UIDNamespace {
        public let uid: UID
        public init(uid: UID) { self.uid = uid }
        public static func ==(lhs: UID, rhs: request) -> Bool { return lhs == rhs.uid }
        public static func ==(lhs: request, rhs: UID) -> Bool { return rhs == lhs }
        public static func ==(lhs: UID?, rhs: request) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
        public static func ==(lhs: request, rhs: UID?) -> Bool { return rhs == lhs }
        public struct buildsettings: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: buildsettings) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: buildsettings, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: buildsettings) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: buildsettings, rhs: UID?) -> Bool { return rhs == lhs }
            public static let register = leaf("source.request.buildsettings.register")
        }
        public struct codecomplete: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: codecomplete) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: codecomplete, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: codecomplete) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: codecomplete, rhs: UID?) -> Bool { return rhs == lhs }
            public struct cache: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: cache) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: cache, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: cache) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: cache, rhs: UID?) -> Bool { return rhs == lhs }
                public static let ondisk = leaf("source.request.codecomplete.cache.ondisk")
            }
            public static let close = leaf("source.request.codecomplete.close")
            public static let open = leaf("source.request.codecomplete.open")
            public static let setcustom = leaf("source.request.codecomplete.setcustom")
            public static let setpopularapi = leaf("source.request.codecomplete.setpopularapi")
            public static let update = leaf("source.request.codecomplete.update")
        }
        public static let crash_exit = leaf("source.request.crash_exit")
        public static let cursorinfo = leaf("source.request.cursorinfo")
        public static let demangle = leaf("source.request.demangle")
        public static let docinfo = leaf("source.request.docinfo")
        public struct editor: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: editor) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: editor, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: editor) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: editor, rhs: UID?) -> Bool { return rhs == lhs }
            public static let close = leaf("source.request.editor.close")
            public static let expand_placeholder = leaf("source.request.editor.expand_placeholder")
            public struct extract: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: extract) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: extract, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: extract) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: extract, rhs: UID?) -> Bool { return rhs == lhs }
                public static let comment = leaf("source.request.editor.extract.comment")
            }
            public static let find_interface_doc = leaf("source.request.editor.find_interface_doc")
            public static let find_usr = leaf("source.request.editor.find_usr")
            public static let formattext = leaf("source.request.editor.formattext")
            public struct open {
                public struct interface: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: interface) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: interface, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: interface) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: interface, rhs: UID?) -> Bool { return rhs == lhs }
                    public static let header = leaf("source.request.editor.open.interface.header")
                    public static let swiftsource = leaf("source.request.editor.open.interface.swiftsource")
                    public static let swifttype = leaf("source.request.editor.open.interface.swifttype")
                }
            }
            public static let replacetext = leaf("source.request.editor.replacetext")
        }
        public static let indexsource = leaf("source.request.indexsource")
        public static let mangle_simple_class = leaf("source.request.mangle_simple_class")
        public struct module: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: module) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: module, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: module) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: module, rhs: UID?) -> Bool { return rhs == lhs }
            public static let groups = leaf("source.request.module.groups")
        }
        public static let protocol_version = leaf("source.request.protocol_version")
        public static let relatedidents = leaf("source.request.relatedidents")
    }
}
