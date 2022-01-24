import SWXMLHash

public extension Dictionary where Key == String, Value == SourceKitRepresentable {
    var referencedUSRs: [String] {
        if let usr = self["key.usr"] as? String,
            let kind = self["key.kind"] as? String,
            kind.contains("source.lang.swift.ref") {
            if let relatedDecls = self["key.related_decls"] as? [[String: SourceKitRepresentable]] {
                return [usr] + relatedDecls.compactMap { ($0["key.annotated_decl"] as? String)?.relatedNameUSR }
            } else {
                return [usr]
            }
        }

        return []
    }
}

private extension String {
    var relatedNameUSR: String? {
        return XMLHash.parse(self)["RelatedName"].element?.value(ofAttribute: "usr")
    }
}
