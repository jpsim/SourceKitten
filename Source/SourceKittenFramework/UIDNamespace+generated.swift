extension UID {
    public struct key: UIDNamespace {
        public let uid: UID
        public init(uid: UID) { self.uid = uid }
        public static func ==(lhs: UID, rhs: key) -> Bool { return lhs == rhs.uid }
        public static func ==(lhs: key, rhs: UID) -> Bool { return rhs == lhs }
        public static func ==(lhs: UID?, rhs: key) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
        public static func ==(lhs: key, rhs: UID?) -> Bool { return rhs == lhs }
        public init(stringLiteral value: String) { self.init(uid: UID(value)) }
        public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
        public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
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
                public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
            }
        }
        public struct codecompletion: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: codecompletion) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: codecompletion, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: codecompletion) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: codecompletion, rhs: UID?) -> Bool { return rhs == lhs }
            public init(stringLiteral value: String) { self.init(uid: UID(value)) }
            public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
            public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
        }
        public struct decl {
            public struct attribute: UIDNamespace {
                public let uid: UID
                public init(uid: UID) { self.uid = uid }
                public static func ==(lhs: UID, rhs: attribute) -> Bool { return lhs == rhs.uid }
                public static func ==(lhs: attribute, rhs: UID) -> Bool { return rhs == lhs }
                public static func ==(lhs: UID?, rhs: attribute) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                public static func ==(lhs: attribute, rhs: UID?) -> Bool { return rhs == lhs }
                public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
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
                public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
            }
            public struct stage {
                public struct swift: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: swift) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: swift, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: swift) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: swift, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
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
                public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                public struct accessibility: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: accessibility) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: accessibility, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: accessibility) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: accessibility, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
                public struct attribute: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: attribute) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: attribute, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: attribute) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: attribute, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
                public struct codecomplete: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: codecomplete) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: codecomplete, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: codecomplete) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: codecomplete, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
                public struct decl: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: decl) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: decl, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: decl) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: decl, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
                public struct expr: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: expr) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: expr, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: expr) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: expr, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
                public struct `import` {
                    public struct module: UIDNamespace {
                        public let uid: UID
                        public init(uid: UID) { self.uid = uid }
                        public static func ==(lhs: UID, rhs: module) -> Bool { return lhs == rhs.uid }
                        public static func ==(lhs: module, rhs: UID) -> Bool { return rhs == lhs }
                        public static func ==(lhs: UID?, rhs: module) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                        public static func ==(lhs: module, rhs: UID?) -> Bool { return rhs == lhs }
                        public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                        public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                        public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                    }
                }
                public struct keyword: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: keyword) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: keyword, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: keyword) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: keyword, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
                public struct literal: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: literal) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: literal, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: literal) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: literal, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
                public struct ref: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: ref) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: ref, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: ref) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: ref, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
                public struct stmt: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: stmt) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: stmt, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: stmt) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: stmt, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
                public struct structure {
                    public struct elem: UIDNamespace {
                        public let uid: UID
                        public init(uid: UID) { self.uid = uid }
                        public static func ==(lhs: UID, rhs: elem) -> Bool { return lhs == rhs.uid }
                        public static func ==(lhs: elem, rhs: UID) -> Bool { return rhs == lhs }
                        public static func ==(lhs: UID?, rhs: elem) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                        public static func ==(lhs: elem, rhs: UID?) -> Bool { return rhs == lhs }
                        public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                        public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                        public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                    }
                }
                public struct syntaxtype: UIDNamespace {
                    public let uid: UID
                    public init(uid: UID) { self.uid = uid }
                    public static func ==(lhs: UID, rhs: syntaxtype) -> Bool { return lhs == rhs.uid }
                    public static func ==(lhs: syntaxtype, rhs: UID) -> Bool { return rhs == lhs }
                    public static func ==(lhs: UID?, rhs: syntaxtype) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
                    public static func ==(lhs: syntaxtype, rhs: UID?) -> Bool { return rhs == lhs }
                    public init(stringLiteral value: String) { self.init(uid: UID(value)) }
                    public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
                    public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
                }
            }
        }
        public struct notification: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: notification) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: notification, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: notification) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: notification, rhs: UID?) -> Bool { return rhs == lhs }
            public init(stringLiteral value: String) { self.init(uid: UID(value)) }
            public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
            public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
        }
        public struct request: UIDNamespace {
            public let uid: UID
            public init(uid: UID) { self.uid = uid }
            public static func ==(lhs: UID, rhs: request) -> Bool { return lhs == rhs.uid }
            public static func ==(lhs: request, rhs: UID) -> Bool { return rhs == lhs }
            public static func ==(lhs: UID?, rhs: request) -> Bool { return lhs.map { $0 == rhs.uid } ?? false }
            public static func ==(lhs: request, rhs: UID?) -> Bool { return rhs == lhs }
            public init(stringLiteral value: String) { self.init(uid: UID(value)) }
            public init(unicodeScalarLiteral value: String) { self.init(uid: UID(value)) }
            public init(extendedGraphemeClusterLiteral value: String) { self.init(uid: UID(value)) }
        }
    }
}

extension UID.key {
    public static let accessibility: UID.key = "key.accessibility"
    public static let annotated_decl: UID.key = "key.annotated_decl"
    public static let annotations: UID.key = "key.annotations"
    public static let associated_usrs: UID.key = "key.associated_usrs"
    public static let attribute: UID.key = "key.attribute"
    public static let attributes: UID.key = "key.attributes"
    public static let bodylength: UID.key = "key.bodylength"
    public static let bodyoffset: UID.key = "key.bodyoffset"
    public struct codecomplete {
        public static let addinitstotoplevel: UID.key = "key.codecomplete.addinitstotoplevel"
        public static let addinneroperators: UID.key = "key.codecomplete.addinneroperators"
        public static let addinnerresults: UID.key = "key.codecomplete.addinnerresults"
        public static let filterrules: UID.key = "key.codecomplete.filterrules"
        public static let filtertext: UID.key = "key.codecomplete.filtertext"
        public static let fuzzymatching: UID.key = "key.codecomplete.fuzzymatching"
        public struct group {
            public static let overloads: UID.key = "key.codecomplete.group.overloads"
            public static let stems: UID.key = "key.codecomplete.group.stems"
        }
        public static let hidebyname: UID.key = "key.codecomplete.hidebyname"
        public static let hidelowpriority: UID.key = "key.codecomplete.hidelowpriority"
        public static let hideunderscores: UID.key = "key.codecomplete.hideunderscores"
        public static let includeexactmatch: UID.key = "key.codecomplete.includeexactmatch"
        public static let options: UID.key = "key.codecomplete.options"
        public static let requestlimit: UID.key = "key.codecomplete.requestlimit"
        public static let requeststart: UID.key = "key.codecomplete.requeststart"
        public static let showtopnonliteralresults: UID.key = "key.codecomplete.showtopnonliteralresults"
        public struct sort {
            public static let byname: UID.key = "key.codecomplete.sort.byname"
            public static let contextweight: UID.key = "key.codecomplete.sort.contextweight"
            public static let fuzzyweight: UID.key = "key.codecomplete.sort.fuzzyweight"
            public static let popularitybonus: UID.key = "key.codecomplete.sort.popularitybonus"
            public static let useimportdepth: UID.key = "key.codecomplete.sort.useimportdepth"
        }
    }
    public static let column: UID.key = "key.column"
    public static let compilerargs: UID.key = "key.compilerargs"
    public static let conforms: UID.key = "key.conforms"
    public static let containertypeusr: UID.key = "key.containertypeusr"
    public static let context: UID.key = "key.context"
    public static let default_implementation_of: UID.key = "key.default_implementation_of"
    public static let dependencies: UID.key = "key.dependencies"
    public static let deprecated: UID.key = "key.deprecated"
    public static let description: UID.key = "key.description"
    public static let diagnostic_stage: UID.key = "key.diagnostic_stage"
    public static let diagnostics: UID.key = "key.diagnostics"
    public struct doc {
        public static let brief: UID.key = "key.doc.brief"
        public static let full_as_xml: UID.key = "key.doc.full_as_xml"
    }
    public static let duration: UID.key = "key.duration"
    public struct editor {
        public struct format {
            public static let indentwidth: UID.key = "key.editor.format.indentwidth"
            public static let options: UID.key = "key.editor.format.options"
            public static let tabwidth: UID.key = "key.editor.format.tabwidth"
            public static let usetabs: UID.key = "key.editor.format.usetabs"
        }
    }
    public static let elements: UID.key = "key.elements"
    public static let enablediagnostics: UID.key = "key.enablediagnostics"
    public static let enablesubstructure: UID.key = "key.enablesubstructure"
    public static let enablesyntaxmap: UID.key = "key.enablesyntaxmap"
    public static let entities: UID.key = "key.entities"
    public static let extends: UID.key = "key.extends"
    public static let filepath: UID.key = "key.filepath"
    public static let fixits: UID.key = "key.fixits"
    public static let fully_annotated_decl: UID.key = "key.fully_annotated_decl"
    public static let generic_params: UID.key = "key.generic_params"
    public static let generic_requirements: UID.key = "key.generic_requirements"
    public static let groupname: UID.key = "key.groupname"
    public static let hash: UID.key = "key.hash"
    public static let hide: UID.key = "key.hide"
    public static let inheritedtypes: UID.key = "key.inheritedtypes"
    public static let inherits: UID.key = "key.inherits"
    public static let interested_usr: UID.key = "key.interested_usr"
    public static let introduced: UID.key = "key.introduced"
    public static let is_deprecated: UID.key = "key.is_deprecated"
    public static let is_dynamic: UID.key = "key.is_dynamic"
    public static let is_local: UID.key = "key.is_local"
    public static let is_optional: UID.key = "key.is_optional"
    public static let is_system: UID.key = "key.is_system"
    public static let is_test_candidate: UID.key = "key.is_test_candidate"
    public static let is_unavailable: UID.key = "key.is_unavailable"
    public static let keyword: UID.key = "key.keyword"
    public static let kind: UID.key = "key.kind"
    public static let length: UID.key = "key.length"
    public static let line: UID.key = "key.line"
    public static let message: UID.key = "key.message"
    public static let module_interface_name: UID.key = "key.module_interface_name"
    public static let modulegroups: UID.key = "key.modulegroups"
    public static let moduleimportdepth: UID.key = "key.moduleimportdepth"
    public static let modulename: UID.key = "key.modulename"
    public static let name: UID.key = "key.name"
    public static let namelength: UID.key = "key.namelength"
    public static let nameoffset: UID.key = "key.nameoffset"
    public static let names: UID.key = "key.names"
    public static let nextrequeststart: UID.key = "key.nextrequeststart"
    public static let not_recommended: UID.key = "key.not_recommended"
    public static let notification: UID.key = "key.notification"
    public static let num_bytes_to_erase: UID.key = "key.num_bytes_to_erase"
    public static let obsoleted: UID.key = "key.obsoleted"
    public static let offset: UID.key = "key.offset"
    public static let original_usr: UID.key = "key.original_usr"
    public static let overrides: UID.key = "key.overrides"
    public static let platform: UID.key = "key.platform"
    public static let popular: UID.key = "key.popular"
    public static let ranges: UID.key = "key.ranges"
    public static let receiver_usr: UID.key = "key.receiver_usr"
    public static let related: UID.key = "key.related"
    public static let related_decls: UID.key = "key.related_decls"
    public static let removecache: UID.key = "key.removecache"
    public static let request: UID.key = "key.request"
    public static let results: UID.key = "key.results"
    public static let runtime_name: UID.key = "key.runtime_name"
    public static let selector_name: UID.key = "key.selector_name"
    public static let setter_accessibility: UID.key = "key.setter_accessibility"
    public static let severity: UID.key = "key.severity"
    public static let simplified: UID.key = "key.simplified"
    public static let sourcefile: UID.key = "key.sourcefile"
    public static let sourcetext: UID.key = "key.sourcetext"
    public static let substructure: UID.key = "key.substructure"
    public static let syntactic_only: UID.key = "key.syntactic_only"
    public static let syntaxmap: UID.key = "key.syntaxmap"
    public static let synthesizedextensions: UID.key = "key.synthesizedextensions"
    public static let throwlength: UID.key = "key.throwlength"
    public static let throwoffset: UID.key = "key.throwoffset"
    public static let typeinterface: UID.key = "key.typeinterface"
    public static let typename: UID.key = "key.typename"
    public static let typeusr: UID.key = "key.typeusr"
    public static let uids: UID.key = "key.uids"
    public static let unpopular: UID.key = "key.unpopular"
    public static let usr: UID.key = "key.usr"
    public static let version_major: UID.key = "key.version_major"
    public static let version_minor: UID.key = "key.version_minor"
}
extension UID.source.availability.platform {
    public static let ios: UID.source.availability.platform = "source.availability.platform.ios"
    public static let ios_app_extension: UID.source.availability.platform = "source.availability.platform.ios_app_extension"
    public static let osx: UID.source.availability.platform = "source.availability.platform.osx"
    public static let osx_app_extension: UID.source.availability.platform = "source.availability.platform.osx_app_extension"
    public static let tvos: UID.source.availability.platform = "source.availability.platform.tvos"
    public static let tvos_app_extension: UID.source.availability.platform = "source.availability.platform.tvos_app_extension"
    public static let watchos: UID.source.availability.platform = "source.availability.platform.watchos"
    public static let watchos_app_extension: UID.source.availability.platform = "source.availability.platform.watchos_app_extension"
}
extension UID.source.codecompletion {
    public struct context {
        public static let exprspecific: UID.source.codecompletion = "source.codecompletion.context.exprspecific"
        public static let local: UID.source.codecompletion = "source.codecompletion.context.local"
        public static let none: UID.source.codecompletion = "source.codecompletion.context.none"
        public static let otherclass: UID.source.codecompletion = "source.codecompletion.context.otherclass"
        public static let othermodule: UID.source.codecompletion = "source.codecompletion.context.othermodule"
        public static let superclass: UID.source.codecompletion = "source.codecompletion.context.superclass"
        public static let thisclass: UID.source.codecompletion = "source.codecompletion.context.thisclass"
        public static let thismodule: UID.source.codecompletion = "source.codecompletion.context.thismodule"
    }
    public static let custom: UID.source.codecompletion = "source.codecompletion.custom"
    public static let everything: UID.source.codecompletion = "source.codecompletion.everything"
    public static let identifier: UID.source.codecompletion = "source.codecompletion.identifier"
    public static let keyword: UID.source.codecompletion = "source.codecompletion.keyword"
    public static let literal: UID.source.codecompletion = "source.codecompletion.literal"
    public static let module: UID.source.codecompletion = "source.codecompletion.module"
}
extension UID.source.decl.attribute {
    public static let LLDBDebuggerFunction: UID.source.decl.attribute = "source.decl.attribute.LLDBDebuggerFunction"
    public static let NSApplicationMain: UID.source.decl.attribute = "source.decl.attribute.NSApplicationMain"
    public static let NSCopying: UID.source.decl.attribute = "source.decl.attribute.NSCopying"
    public static let NSManaged: UID.source.decl.attribute = "source.decl.attribute.NSManaged"
    public static let UIApplicationMain: UID.source.decl.attribute = "source.decl.attribute.UIApplicationMain"
    public static let __objc_bridged: UID.source.decl.attribute = "source.decl.attribute.__objc_bridged"
    public static let __synthesized_protocol: UID.source.decl.attribute = "source.decl.attribute.__synthesized_protocol"
    public static let _alignment: UID.source.decl.attribute = "source.decl.attribute._alignment"
    public static let _cdecl: UID.source.decl.attribute = "source.decl.attribute._cdecl"
    public static let _exported: UID.source.decl.attribute = "source.decl.attribute._exported"
    public static let _fixed_layout: UID.source.decl.attribute = "source.decl.attribute._fixed_layout"
    public static let _semantics: UID.source.decl.attribute = "source.decl.attribute._semantics"
    public static let _silgen_name: UID.source.decl.attribute = "source.decl.attribute._silgen_name"
    public static let _specialize: UID.source.decl.attribute = "source.decl.attribute._specialize"
    public static let _swift_native_objc_runtime_base: UID.source.decl.attribute = "source.decl.attribute._swift_native_objc_runtime_base"
    public static let _transparent: UID.source.decl.attribute = "source.decl.attribute._transparent"
    public static let _versioned: UID.source.decl.attribute = "source.decl.attribute._versioned"
    public static let autoclosure: UID.source.decl.attribute = "source.decl.attribute.autoclosure"
    public static let available: UID.source.decl.attribute = "source.decl.attribute.available"
    public static let convenience: UID.source.decl.attribute = "source.decl.attribute.convenience"
    public static let discardableResult: UID.source.decl.attribute = "source.decl.attribute.discardableResult"
    public static let dynamic: UID.source.decl.attribute = "source.decl.attribute.dynamic"
    public static let effects: UID.source.decl.attribute = "source.decl.attribute.effects"
    public static let escaping: UID.source.decl.attribute = "source.decl.attribute.escaping"
    public static let final: UID.source.decl.attribute = "source.decl.attribute.final"
    public static let gkinspectable: UID.source.decl.attribute = "source.decl.attribute.gkinspectable"
    public static let ibaction: UID.source.decl.attribute = "source.decl.attribute.ibaction"
    public static let ibdesignable: UID.source.decl.attribute = "source.decl.attribute.ibdesignable"
    public static let ibinspectable: UID.source.decl.attribute = "source.decl.attribute.ibinspectable"
    public static let iboutlet: UID.source.decl.attribute = "source.decl.attribute.iboutlet"
    public static let indirect: UID.source.decl.attribute = "source.decl.attribute.indirect"
    public static let infix: UID.source.decl.attribute = "source.decl.attribute.infix"
    public static let inline: UID.source.decl.attribute = "source.decl.attribute.inline"
    public static let lazy: UID.source.decl.attribute = "source.decl.attribute.lazy"
    public static let mutating: UID.source.decl.attribute = "source.decl.attribute.mutating"
    public static let noescape: UID.source.decl.attribute = "source.decl.attribute.noescape"
    public static let nonmutating: UID.source.decl.attribute = "source.decl.attribute.nonmutating"
    public static let nonobjc: UID.source.decl.attribute = "source.decl.attribute.nonobjc"
    public static let noreturn: UID.source.decl.attribute = "source.decl.attribute.noreturn"
    public struct objc {
        public static let name: UID.source.decl.attribute = "source.decl.attribute.objc.name"
    }
    public static let objc_non_lazy_realization: UID.source.decl.attribute = "source.decl.attribute.objc_non_lazy_realization"
    public static let optional: UID.source.decl.attribute = "source.decl.attribute.optional"
    public static let override: UID.source.decl.attribute = "source.decl.attribute.override"
    public static let postfix: UID.source.decl.attribute = "source.decl.attribute.postfix"
    public static let prefix: UID.source.decl.attribute = "source.decl.attribute.prefix"
    public static let required: UID.source.decl.attribute = "source.decl.attribute.required"
    public static let requires_stored_property_inits: UID.source.decl.attribute = "source.decl.attribute.requires_stored_property_inits"
    public static let `rethrows`: UID.source.decl.attribute = "source.decl.attribute.rethrows"
    public static let sil_stored: UID.source.decl.attribute = "source.decl.attribute.sil_stored"
    public static let swift3_migration: UID.source.decl.attribute = "source.decl.attribute.swift3_migration"
    public static let testable: UID.source.decl.attribute = "source.decl.attribute.testable"
    public static let unsafe_no_objc_tagged_pointer: UID.source.decl.attribute = "source.decl.attribute.unsafe_no_objc_tagged_pointer"
    public static let warn_unqualified_access: UID.source.decl.attribute = "source.decl.attribute.warn_unqualified_access"
    public static let weak: UID.source.decl.attribute = "source.decl.attribute.weak"
}
extension UID.source.diagnostic.severity {
    public static let error: UID.source.diagnostic.severity = "source.diagnostic.severity.error"
    public static let note: UID.source.diagnostic.severity = "source.diagnostic.severity.note"
    public static let warning: UID.source.diagnostic.severity = "source.diagnostic.severity.warning"
}
extension UID.source.diagnostic.stage.swift {
    public static let parse: UID.source.diagnostic.stage.swift = "source.diagnostic.stage.swift.parse"
    public static let sema: UID.source.diagnostic.stage.swift = "source.diagnostic.stage.swift.sema"
}
extension UID.source.lang.swift {
    public static let pattern: UID.source.lang.swift = "source.lang.swift.pattern"
    public static let type: UID.source.lang.swift = "source.lang.swift.type"
}
extension UID.source.lang.swift.accessibility {
    public static let `fileprivate`: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.fileprivate"
    public static let `internal`: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.internal"
    public static let open: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.open"
    public static let `private`: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.private"
    public static let `public`: UID.source.lang.swift.accessibility = "source.lang.swift.accessibility.public"
}
extension UID.source.lang.swift.attribute {
    public static let availability: UID.source.lang.swift.attribute = "source.lang.swift.attribute.availability"
}
extension UID.source.lang.swift.codecomplete {
    public static let group: UID.source.lang.swift.codecomplete = "source.lang.swift.codecomplete.group"
}
extension UID.source.lang.swift.decl {
    public static let `associatedtype`: UID.source.lang.swift.decl = "source.lang.swift.decl.associatedtype"
    public static let `class`: UID.source.lang.swift.decl = "source.lang.swift.decl.class"
    public static let `enum`: UID.source.lang.swift.decl = "source.lang.swift.decl.enum"
    public static let enumcase: UID.source.lang.swift.decl = "source.lang.swift.decl.enumcase"
    public static let enumelement: UID.source.lang.swift.decl = "source.lang.swift.decl.enumelement"
    public struct `extension` {
        public static let `class`: UID.source.lang.swift.decl = "source.lang.swift.decl.extension.class"
        public static let `enum`: UID.source.lang.swift.decl = "source.lang.swift.decl.extension.enum"
        public static let `protocol`: UID.source.lang.swift.decl = "source.lang.swift.decl.extension.protocol"
        public static let `struct`: UID.source.lang.swift.decl = "source.lang.swift.decl.extension.struct"
    }
    public struct function {
        public struct accessor {
            public static let address: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.address"
            public static let didset: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.didset"
            public static let getter: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.getter"
            public static let mutableaddress: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.mutableaddress"
            public static let setter: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.setter"
            public static let willset: UID.source.lang.swift.decl = "source.lang.swift.decl.function.accessor.willset"
        }
        public static let constructor: UID.source.lang.swift.decl = "source.lang.swift.decl.function.constructor"
        public static let destructor: UID.source.lang.swift.decl = "source.lang.swift.decl.function.destructor"
        public static let free: UID.source.lang.swift.decl = "source.lang.swift.decl.function.free"
        public struct method {
            public static let `class`: UID.source.lang.swift.decl = "source.lang.swift.decl.function.method.class"
            public static let instance: UID.source.lang.swift.decl = "source.lang.swift.decl.function.method.instance"
            public static let `static`: UID.source.lang.swift.decl = "source.lang.swift.decl.function.method.static"
        }
        public struct `operator` {
            public static let infix: UID.source.lang.swift.decl = "source.lang.swift.decl.function.operator.infix"
            public static let postfix: UID.source.lang.swift.decl = "source.lang.swift.decl.function.operator.postfix"
            public static let prefix: UID.source.lang.swift.decl = "source.lang.swift.decl.function.operator.prefix"
        }
        public static let `subscript`: UID.source.lang.swift.decl = "source.lang.swift.decl.function.subscript"
    }
    public static let generic_type_param: UID.source.lang.swift.decl = "source.lang.swift.decl.generic_type_param"
    public static let module: UID.source.lang.swift.decl = "source.lang.swift.decl.module"
    public static let `precedencegroup`: UID.source.lang.swift.decl = "source.lang.swift.decl.precedencegroup"
    public static let `protocol`: UID.source.lang.swift.decl = "source.lang.swift.decl.protocol"
    public static let `struct`: UID.source.lang.swift.decl = "source.lang.swift.decl.struct"
    public static let `typealias`: UID.source.lang.swift.decl = "source.lang.swift.decl.typealias"
    public struct `var` {
        public static let `class`: UID.source.lang.swift.decl = "source.lang.swift.decl.var.class"
        public static let global: UID.source.lang.swift.decl = "source.lang.swift.decl.var.global"
        public static let instance: UID.source.lang.swift.decl = "source.lang.swift.decl.var.instance"
        public static let local: UID.source.lang.swift.decl = "source.lang.swift.decl.var.local"
        public static let parameter: UID.source.lang.swift.decl = "source.lang.swift.decl.var.parameter"
        public static let `static`: UID.source.lang.swift.decl = "source.lang.swift.decl.var.static"
    }
}
extension UID.source.lang.swift.expr {
    public static let argument: UID.source.lang.swift.expr = "source.lang.swift.expr.argument"
    public static let array: UID.source.lang.swift.expr = "source.lang.swift.expr.array"
    public static let call: UID.source.lang.swift.expr = "source.lang.swift.expr.call"
    public static let dictionary: UID.source.lang.swift.expr = "source.lang.swift.expr.dictionary"
    public static let object_literal: UID.source.lang.swift.expr = "source.lang.swift.expr.object_literal"
}
extension UID.source.lang.swift.`import`.module {
    public static let clang: UID.source.lang.swift.`import`.module = "source.lang.swift.import.module.clang"
    public static let swift: UID.source.lang.swift.`import`.module = "source.lang.swift.import.module.swift"
}
extension UID.source.lang.swift.keyword {
    public static let `Any`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.Any"
    public static let `Self`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.Self"
    public static let `_`: UID.source.lang.swift.keyword = "source.lang.swift.keyword._"
    public static let `__COLUMN__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__COLUMN__"
    public static let `__DSO_HANDLE__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__DSO_HANDLE__"
    public static let `__FILE__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__FILE__"
    public static let `__FUNCTION__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__FUNCTION__"
    public static let `__LINE__`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.__LINE__"
    public static let `as`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.as"
    public static let `associatedtype`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.associatedtype"
    public static let `break`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.break"
    public static let `case`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.case"
    public static let `catch`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.catch"
    public static let `class`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.class"
    public static let `continue`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.continue"
    public static let `default`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.default"
    public static let `defer`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.defer"
    public static let `deinit`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.deinit"
    public static let `do`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.do"
    public static let `else`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.else"
    public static let `enum`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.enum"
    public static let `extension`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.extension"
    public static let `fallthrough`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.fallthrough"
    public static let `false`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.false"
    public static let `fileprivate`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.fileprivate"
    public static let `for`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.for"
    public static let `func`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.func"
    public static let `guard`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.guard"
    public static let `if`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.if"
    public static let `import`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.import"
    public static let `in`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.in"
    public static let `init`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.init"
    public static let `inout`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.inout"
    public static let `internal`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.internal"
    public static let `is`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.is"
    public static let `let`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.let"
    public static let `nil`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.nil"
    public static let `operator`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.operator"
    public static let `precedencegroup`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.precedencegroup"
    public static let `private`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.private"
    public static let `protocol`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.protocol"
    public static let `public`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.public"
    public static let `repeat`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.repeat"
    public static let `rethrows`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.rethrows"
    public static let `return`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.return"
    public static let `self`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.self"
    public static let `static`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.static"
    public static let `struct`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.struct"
    public static let `subscript`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.subscript"
    public static let `super`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.super"
    public static let `switch`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.switch"
    public static let `throw`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.throw"
    public static let `throws`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.throws"
    public static let `true`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.true"
    public static let `try`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.try"
    public static let `typealias`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.typealias"
    public static let `var`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.var"
    public static let `where`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.where"
    public static let `while`: UID.source.lang.swift.keyword = "source.lang.swift.keyword.while"
}
extension UID.source.lang.swift.literal {
    public static let array: UID.source.lang.swift.literal = "source.lang.swift.literal.array"
    public static let boolean: UID.source.lang.swift.literal = "source.lang.swift.literal.boolean"
    public static let color: UID.source.lang.swift.literal = "source.lang.swift.literal.color"
    public static let dictionary: UID.source.lang.swift.literal = "source.lang.swift.literal.dictionary"
    public static let image: UID.source.lang.swift.literal = "source.lang.swift.literal.image"
    public static let integer: UID.source.lang.swift.literal = "source.lang.swift.literal.integer"
    public static let `nil`: UID.source.lang.swift.literal = "source.lang.swift.literal.nil"
    public static let string: UID.source.lang.swift.literal = "source.lang.swift.literal.string"
    public static let tuple: UID.source.lang.swift.literal = "source.lang.swift.literal.tuple"
}
extension UID.source.lang.swift.ref {
    public static let `associatedtype`: UID.source.lang.swift.ref = "source.lang.swift.ref.associatedtype"
    public static let `class`: UID.source.lang.swift.ref = "source.lang.swift.ref.class"
    public static let `enum`: UID.source.lang.swift.ref = "source.lang.swift.ref.enum"
    public static let enumelement: UID.source.lang.swift.ref = "source.lang.swift.ref.enumelement"
    public struct function {
        public struct accessor {
            public static let address: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.address"
            public static let didset: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.didset"
            public static let getter: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.getter"
            public static let mutableaddress: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.mutableaddress"
            public static let setter: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.setter"
            public static let willset: UID.source.lang.swift.ref = "source.lang.swift.ref.function.accessor.willset"
        }
        public static let constructor: UID.source.lang.swift.ref = "source.lang.swift.ref.function.constructor"
        public static let destructor: UID.source.lang.swift.ref = "source.lang.swift.ref.function.destructor"
        public static let free: UID.source.lang.swift.ref = "source.lang.swift.ref.function.free"
        public struct method {
            public static let `class`: UID.source.lang.swift.ref = "source.lang.swift.ref.function.method.class"
            public static let instance: UID.source.lang.swift.ref = "source.lang.swift.ref.function.method.instance"
            public static let `static`: UID.source.lang.swift.ref = "source.lang.swift.ref.function.method.static"
        }
        public struct `operator` {
            public static let infix: UID.source.lang.swift.ref = "source.lang.swift.ref.function.operator.infix"
            public static let postfix: UID.source.lang.swift.ref = "source.lang.swift.ref.function.operator.postfix"
            public static let prefix: UID.source.lang.swift.ref = "source.lang.swift.ref.function.operator.prefix"
        }
        public static let `subscript`: UID.source.lang.swift.ref = "source.lang.swift.ref.function.subscript"
    }
    public static let generic_type_param: UID.source.lang.swift.ref = "source.lang.swift.ref.generic_type_param"
    public static let module: UID.source.lang.swift.ref = "source.lang.swift.ref.module"
    public static let `precedencegroup`: UID.source.lang.swift.ref = "source.lang.swift.ref.precedencegroup"
    public static let `protocol`: UID.source.lang.swift.ref = "source.lang.swift.ref.protocol"
    public static let `struct`: UID.source.lang.swift.ref = "source.lang.swift.ref.struct"
    public static let `typealias`: UID.source.lang.swift.ref = "source.lang.swift.ref.typealias"
    public struct `var` {
        public static let `class`: UID.source.lang.swift.ref = "source.lang.swift.ref.var.class"
        public static let global: UID.source.lang.swift.ref = "source.lang.swift.ref.var.global"
        public static let instance: UID.source.lang.swift.ref = "source.lang.swift.ref.var.instance"
        public static let local: UID.source.lang.swift.ref = "source.lang.swift.ref.var.local"
        public static let `static`: UID.source.lang.swift.ref = "source.lang.swift.ref.var.static"
    }
}
extension UID.source.lang.swift.stmt {
    public static let brace: UID.source.lang.swift.stmt = "source.lang.swift.stmt.brace"
    public static let `case`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.case"
    public static let `for`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.for"
    public static let foreach: UID.source.lang.swift.stmt = "source.lang.swift.stmt.foreach"
    public static let `guard`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.guard"
    public static let `if`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.if"
    public static let repeatwhile: UID.source.lang.swift.stmt = "source.lang.swift.stmt.repeatwhile"
    public static let `switch`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.switch"
    public static let `while`: UID.source.lang.swift.stmt = "source.lang.swift.stmt.while"
}
extension UID.source.lang.swift.structure.elem {
    public static let condition_expr: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.condition_expr"
    public static let expr: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.expr"
    public static let id: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.id"
    public static let init_expr: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.init_expr"
    public static let pattern: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.pattern"
    public static let typeref: UID.source.lang.swift.structure.elem = "source.lang.swift.structure.elem.typeref"
}
extension UID.source.lang.swift.syntaxtype {
    public static let argument: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.argument"
    public struct attribute {
        public static let builtin: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.attribute.builtin"
        public static let id: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.attribute.id"
    }
    public struct buildconfig {
        public static let id: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.buildconfig.id"
        public static let keyword: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.buildconfig.keyword"
    }
    public struct comment {
        public static let mark: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.comment.mark"
        public static let url: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.comment.url"
    }
    public struct doccomment {
        public static let field: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.doccomment.field"
    }
    public static let identifier: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.identifier"
    public static let keyword: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.keyword"
    public static let number: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.number"
    public static let objectliteral: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.objectliteral"
    public static let parameter: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.parameter"
    public static let placeholder: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.placeholder"
    public static let string: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.string"
    public static let string_interpolation_anchor: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.string_interpolation_anchor"
    public static let typeidentifier: UID.source.lang.swift.syntaxtype = "source.lang.swift.syntaxtype.typeidentifier"
}
extension UID.source.notification {
    public struct editor {
        public static let documentupdate: UID.source.notification = "source.notification.editor.documentupdate"
    }
    public static let sema_disabled: UID.source.notification = "source.notification.sema_disabled"
}
extension UID.source.request {
    public struct buildsettings {
        public static let register: UID.source.request = "source.request.buildsettings.register"
    }
    public struct codecomplete {
        public struct cache {
            public static let ondisk: UID.source.request = "source.request.codecomplete.cache.ondisk"
        }
        public static let close: UID.source.request = "source.request.codecomplete.close"
        public static let open: UID.source.request = "source.request.codecomplete.open"
        public static let setcustom: UID.source.request = "source.request.codecomplete.setcustom"
        public static let setpopularapi: UID.source.request = "source.request.codecomplete.setpopularapi"
        public static let update: UID.source.request = "source.request.codecomplete.update"
    }
    public static let crash_exit: UID.source.request = "source.request.crash_exit"
    public static let cursorinfo: UID.source.request = "source.request.cursorinfo"
    public static let demangle: UID.source.request = "source.request.demangle"
    public static let docinfo: UID.source.request = "source.request.docinfo"
    public struct editor {
        public static let close: UID.source.request = "source.request.editor.close"
        public static let expand_placeholder: UID.source.request = "source.request.editor.expand_placeholder"
        public struct extract {
            public static let comment: UID.source.request = "source.request.editor.extract.comment"
        }
        public static let find_interface_doc: UID.source.request = "source.request.editor.find_interface_doc"
        public static let find_usr: UID.source.request = "source.request.editor.find_usr"
        public static let formattext: UID.source.request = "source.request.editor.formattext"
        public struct open {
            public struct interface {
                public static let header: UID.source.request = "source.request.editor.open.interface.header"
                public static let swiftsource: UID.source.request = "source.request.editor.open.interface.swiftsource"
                public static let swifttype: UID.source.request = "source.request.editor.open.interface.swifttype"
            }
        }
        public static let replacetext: UID.source.request = "source.request.editor.replacetext"
    }
    public static let indexsource: UID.source.request = "source.request.indexsource"
    public static let mangle_simple_class: UID.source.request = "source.request.mangle_simple_class"
    public struct module {
        public static let groups: UID.source.request = "source.request.module.groups"
    }
    public static let protocol_version: UID.source.request = "source.request.protocol_version"
    public static let relatedidents: UID.source.request = "source.request.relatedidents"
}