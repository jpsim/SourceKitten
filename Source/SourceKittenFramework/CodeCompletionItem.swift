//
//  CodeCompletionItem.swift
//  SourceKitten
//
//  Created by JP Simard on 9/4/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import Foundation

extension NSMutableDictionary {
    private func addIfNotNil(_ key: NSString, _ value: NSString?) {
        if let value = value {
            self[key] = value
        }
    }
}

public struct CodeCompletionItem {
    public let kind: String
    public let context: String
    public let name: String?
    public let descriptionKey: String?
    public let sourcetext: String?
    public let typeName: String?
    public let moduleName: String?
    public let docBrief: String?
    public let associatedUSRs: String?

    /// Dictionary representation of CodeCompletionItem. Useful for NSJSONSerialization.
    public var dictionaryValue: NSDictionary {
        let dict: NSMutableDictionary = [
            NSString(string: "kind"): NSString(string: kind),
            NSString(string: "context"): NSString(string: context)
        ]
        dict.addIfNotNil("name", name.flatMap(NSString.init))
        dict.addIfNotNil("descriptionKey", descriptionKey.flatMap(NSString.init))
        dict.addIfNotNil("sourcetext", sourcetext.flatMap(NSString.init))
        dict.addIfNotNil("typeName", typeName.flatMap(NSString.init))
        dict.addIfNotNil("moduleName", moduleName.flatMap(NSString.init))
        dict.addIfNotNil("docBrief", docBrief.flatMap(NSString.init))
        dict.addIfNotNil("associatedUSRs", associatedUSRs.flatMap(NSString.init))
        return dict
    }

    public var description: String {
        return toJSON(dictionaryValue)
    }

    public static func parseResponse(response: [String: SourceKitRepresentable]) -> [CodeCompletionItem] {
        return (response["key.results"] as! [SourceKitRepresentable]).map { item in
            let dict = item as! [String: SourceKitRepresentable]
            return CodeCompletionItem(kind: dict["key.kind"] as! String,
                context: dict["key.context"] as! String,
                name: dict["key.name"] as? String,
                descriptionKey: dict["key.description"] as? String,
                sourcetext: dict["key.sourcetext"] as? String,
                typeName: dict["key.typename"] as? String,
                moduleName: dict["key.modulename"] as? String,
                docBrief: dict["key.doc.brief"] as? String,
                associatedUSRs: dict["key.associated_usrs"] as? String)
        }
    }
}
