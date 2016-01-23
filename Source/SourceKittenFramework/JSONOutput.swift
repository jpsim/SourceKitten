//
//  JSONOutput.swift
//  SourceKitten
//
//  Created by Thomas Goyne on 9/17/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import Foundation

/**
 JSON Object to JSON String.

 - parameter object: Object to convert to JSON.

 - returns: JSON string representation of the input object.
 */
public func toJSON(object: AnyObject) -> String {
    do {
        let prettyJSONData = try NSJSONSerialization.dataWithJSONObject(object, options: .PrettyPrinted)
        if let jsonString = NSString(data: prettyJSONData, encoding: NSUTF8StringEncoding) as? String {
            return jsonString
        }
    } catch {}
    return ""
}

/**
 Convert [String: SourceKitRepresentable] to `[String: AnyObject]`.

 - parameter dictionary: [String: SourceKitRepresentable] to convert.

 - returns: JSON-serializable Dictionary.
 */
public func toAnyObject(dictionary: [String: SourceKitRepresentable]) -> [String: AnyObject] {
    var anyDictionary = [String: AnyObject]()
    for (key, object) in dictionary {
        switch object {
        case let object as AnyObject:
            anyDictionary[key] = object
        case let object as [SourceKitRepresentable]:
            anyDictionary[key] = object.map { toAnyObject($0 as! [String: SourceKitRepresentable]) }
        case let object as [[String: SourceKitRepresentable]]:
            anyDictionary[key] = object.map { toAnyObject($0) }
        case let object as [String: SourceKitRepresentable]:
            anyDictionary[key] = toAnyObject(object)
        case let object as String:
            anyDictionary[key] = object
        case let object as Int64:
            anyDictionary[key] = NSNumber(longLong: object)
        case let object as Bool:
            anyDictionary[key] = NSNumber(bool: object)
        default:
            fatalError("Should never happen because we've checked all SourceKitRepresentable types")
        }
    }
    return anyDictionary
}

public func declarationsToJSON(decl: [String: [SourceDeclaration]]) -> String {
    return toJSON(decl.map({ [$0: toOutputDictionary($1)] }).sort({ $0.keys.first < $1.keys.first }))
}

private func toOutputDictionary(decl: SourceDeclaration) -> [String: AnyObject] {
    var dict = [String: AnyObject]()
    func set(key: SwiftDocKey, _ value: AnyObject?) {
        if let value = value {
            dict[key.rawValue] = value
        }
    }
    func setA(key: SwiftDocKey, _ value: [AnyObject]?) {
        if let value = value where value.count > 0 {
            dict[key.rawValue] = value
        }
    }

    set(.Kind, decl.type.rawValue)
    set(.FilePath, decl.location.file)
    set(.DocFile, decl.location.file)
    set(.DocLine, Int(decl.location.line))
    set(.DocColumn, Int(decl.location.column))
    set(.Name, decl.name)
    set(.USR, decl.usr)
    set(.ParsedDeclaration, decl.declaration)
    set(.DocumentationComment, decl.commentBody)
    set(.ParsedScopeStart, Int(decl.extent.start.line))
    set(.ParsedScopeEnd, Int(decl.extent.end.line))

    setA(.DocResultDiscussion, decl.documentation?.returnDiscussion.map(toOutputDictionary))
    setA(.DocParameters, decl.documentation?.parameters.map(toOutputDictionary))
    setA(.Substructure, decl.children.map(toOutputDictionary))

    if decl.commentBody != nil {
        set(.FullXMLDocs, "")
    }

    return dict
}

private func toOutputDictionary(decl: [SourceDeclaration]) -> [String: AnyObject] {
    return ["key.substructure": decl.map(toOutputDictionary), "key.diagnostic_stage": ""]
}

private func toOutputDictionary(param: Parameter) -> [String: AnyObject] {
    return ["name": param.name, "discussion": param.discussion.map(toOutputDictionary)]
}

private func toOutputDictionary(text: Text) -> [String: AnyObject] {
    switch text {
    case .Para(let str, let kind):
        return ["kind": kind ?? "", "Para": str]
    case .Verbatim(let str):
        return ["kind": "", "Verbatim": str]
    }
}
