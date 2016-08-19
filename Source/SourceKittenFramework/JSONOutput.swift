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
public func toJSON<Element>(_ object: Array<Element>) -> String {
    if object.isEmpty {
        return "[\n\n]"
    }
    return toJSON(any: object.bridge())
}

public func toJSON(_ object: NSDictionary) -> String {
    return toJSON(any: object)
}

private func toJSON(any: Any) -> String {
    return (try? JSONSerialization.data(withJSONObject: any, options: .prettyPrinted)).flatMap { data in
        return String(data: data, encoding: .utf8)
    } ?? ""
}

/**
 Convert [String: SourceKitRepresentable] to `Any`.

 - parameter dictionary: [String: SourceKitRepresentable] to convert.

 - returns: JSON-serializable value.
 */
public func toNSDictionary(_ dictionary: [String: SourceKitRepresentable]) -> NSDictionary {
    var anyDictionary = [String: Any]()
    for (key, object) in dictionary {
        switch object {
        case let object as [SourceKitRepresentable]:
            anyDictionary[key] = object.map { toNSDictionary($0 as! [String: SourceKitRepresentable]) }
        case let object as [[String: SourceKitRepresentable]]:
            anyDictionary[key] = object.map { toNSDictionary($0) }
        case let object as [String: SourceKitRepresentable]:
            anyDictionary[key] = toNSDictionary(object)
        case let object as String:
            anyDictionary[key] = object.bridge()
        case let object as Int64:
            anyDictionary[key] = NSNumber(value: object)
        case let object as Bool:
            anyDictionary[key] = NSNumber(value: object)
        case let object as Any:
            anyDictionary[key] = object
        default:
            fatalError("Should never happen because we've checked all SourceKitRepresentable types")
        }
    }
    return anyDictionary.bridge()
}

#if !os(Linux)

public func declarationsToJSON(_ decl: [String: [SourceDeclaration]]) -> String {
    return toJSON(decl.map({ [$0: toOutputDictionary($1)] }).sorted { $0.keys.first! < $1.keys.first! })
}

private func toOutputDictionary(_ decl: SourceDeclaration) -> [String: Any] {
    var dict = [String: Any]()
    func set(_ key: SwiftDocKey, _ value: Any?) {
        if let value = value {
            dict[key.rawValue] = value
        }
    }
    func setA(_ key: SwiftDocKey, _ value: [Any]?) {
        if let value = value, value.count > 0 {
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
    set(.SwiftDeclaration, decl.swiftDeclaration)

    setA(.DocResultDiscussion, decl.documentation?.returnDiscussion.map(toOutputDictionary))
    setA(.DocParameters, decl.documentation?.parameters.map(toOutputDictionary))
    setA(.Substructure, decl.children.map(toOutputDictionary))

    if decl.commentBody != nil {
        set(.FullXMLDocs, "")
    }

    return dict
}

private func toOutputDictionary(_ decl: [SourceDeclaration]) -> [String: Any] {
    return ["key.substructure": decl.map(toOutputDictionary), "key.diagnostic_stage": ""]
}

private func toOutputDictionary(_ param: Parameter) -> [String: Any] {
    return ["name": param.name, "discussion": param.discussion.map(toOutputDictionary)]
}

private func toOutputDictionary(_ text: Text) -> [String: Any] {
    switch text {
    case .Para(let str, let kind):
        return ["kind": kind ?? "", "Para": str]
    case .Verbatim(let str):
        return ["kind": "", "Verbatim": str]
    }
}

#endif
