//
//  SourceDeclaration.swift
//  SourceKitten
//
//  Created by JP Simard on 7/15/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

import SwiftXPC
import SWXMLHash

/// Represents a source code declaration.
public struct SourceDeclaration {
    let file: String
    let line: Int64?
    let column: Int64?

    let name: String?
    let usr: String?
    let declaration: String?
    let parameters: XPCArray
    let abstract: XPCArray?
    let discussion: XPCArray?
    let resultDiscussion: XPCArray?

    var dictionaryValue: [String: AnyObject] {
        var dict = [String: AnyObject]()
        dict["file"] = file
        dict["line"] = line.map(String.init) ?? NSNull()
        dict["column"] = column.map(String.init) ?? NSNull()
        dict["name"] = name ?? NSNull()
        dict["usr"] = usr ?? NSNull()
        dict["declaration"] = declaration ?? NSNull()
        func forceDict(array: XPCArray?) -> AnyObject {
            return array?.map { toAnyObject($0 as! XPCDictionary) } ?? NSNull()
        }
        dict["parameters"]       = forceDict(parameters)
        dict["abstract"]         = forceDict(abstract)
        dict["discussion"]       = forceDict(discussion)
        dict["resultDiscussion"] = forceDict(resultDiscussion)
        return dict
    }

    public init?(xmlString: String) {
        let cleanXMLDocs = xmlString.stringByReplacingOccurrencesOfString("<rawHTML>", withString: "")
            .stringByReplacingOccurrencesOfString("</rawHTML>", withString: "")
            .stringByReplacingOccurrencesOfString("<codeVoice>", withString: "`")
            .stringByReplacingOccurrencesOfString("</codeVoice>", withString: "`")
        guard let rootXML = SWXMLHash.parse(cleanXMLDocs).children.first else {
            return nil
        }
        file = rootXML.element?.attributes["file"] ?? "<none>"
        line = rootXML.element?.attributes["line"].flatMap { Int64($0) }
        column = rootXML.element?.attributes["column"].flatMap { Int64($0) }

        name = rootXML["Name"].element?.text
        usr = rootXML["USR"].element?.text
        declaration = rootXML["Declaration"].element?.text
        parameters = rootXML["Parameters"].children.map {
            [
                "name": $0["Name"].element?.text ?? "",
                "discussion": childrenAsArray($0["Discussion"]) ?? []
            ] as XPCDictionary
        } as XPCArray
        abstract = childrenAsArray(rootXML["Abstract"])
        discussion = childrenAsArray(rootXML["Discussion"])
        resultDiscussion = childrenAsArray(rootXML["ResultDiscussion"])
    }
}

// MARK: Equatable

extension SourceDeclaration: Equatable {}

/**
Returns true if `lhs` SourceDeclaration is equal to `rhs` SourceDeclaration.

- parameter lhs: SourceDeclaration to compare to `rhs`.
- parameter rhs: SourceDeclaration to compare to `lhs`.

- returns: True if `lhs` SourceDeclaration is equal to `rhs` SourceDeclaration.
*/
public func ==(lhs: SourceDeclaration, rhs: SourceDeclaration) -> Bool {
    return lhs.usr == rhs.usr
}

// MARK: Hashable

extension SourceDeclaration: Hashable {
    /// The hash value.
    public var hashValue: Int {
        return usr?.hashValue ?? 0
    }
}

// MARK: Comparable

extension SourceDeclaration: Comparable {}

/// A [strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order)
/// over instances of `Self`.
public func <(lhs: SourceDeclaration, rhs: SourceDeclaration) -> Bool {
    // Sort by file path.
    switch lhs.file.compare(rhs.file) {
    case .OrderedDescending:
        return false
    case .OrderedAscending:
        return true
    case .OrderedSame:
        break
    }

    // Then line.
    if lhs.line > rhs.line {
        return false
    } else if lhs.line < rhs.line {
        return true
    }

    // Then column.
    if lhs.column > rhs.column {
        return false
    }

    return true
}

// MARK: Helpers

/**
Parse XML from `key.doc.full_as_xml` from `cursor.info` request.

- parameter xmlDocs: Contents of `key.doc.full_as_xml` from SourceKit.

- returns: XML parsed as an `XPCDictionary`.
*/
public func parseFullXMLDocs(xmlDocs: String) -> XPCDictionary? {
    let cleanXMLDocs = xmlDocs.stringByReplacingOccurrencesOfString("<rawHTML>", withString: "")
        .stringByReplacingOccurrencesOfString("</rawHTML>", withString: "")
        .stringByReplacingOccurrencesOfString("<codeVoice>", withString: "`")
        .stringByReplacingOccurrencesOfString("</codeVoice>", withString: "`")
    return SWXMLHash.parse(cleanXMLDocs).children.first.map { rootXML in
        var docs = XPCDictionary()
        docs[SwiftDocKey.DocType.rawValue] = rootXML.element?.name
        docs[SwiftDocKey.DocFile.rawValue] = rootXML.element?.attributes["file"]
        docs[SwiftDocKey.DocLine.rawValue] = rootXML.element?.attributes["line"].flatMap {
            Int64($0)
        }
        docs[SwiftDocKey.DocColumn.rawValue] = rootXML.element?.attributes["column"].flatMap {
            Int64($0)
        }
        docs[SwiftDocKey.DocName.rawValue] = rootXML["Name"].element?.text
        docs[SwiftDocKey.DocUSR.rawValue] = rootXML["USR"].element?.text
        docs[SwiftDocKey.DocDeclaration.rawValue] = rootXML["Declaration"].element?.text
        let parameters = rootXML["Parameters"].children
        if parameters.count > 0 {
            docs[SwiftDocKey.DocParameters.rawValue] = parameters.map {
                [
                    "name": $0["Name"].element?.text ?? "",
                    "discussion": childrenAsArray($0["Discussion"]) ?? []
                ] as XPCDictionary
            } as XPCArray
        }
        docs[SwiftDocKey.DocDiscussion.rawValue] = childrenAsArray(rootXML["Discussion"])
        docs[SwiftDocKey.DocResultDiscussion.rawValue] = childrenAsArray(rootXML["ResultDiscussion"])
        return docs
    }
}

/**
Returns an `XPCArray` of `XPCDictionary` items from `indexer` children, if any.

- parameter indexer: `XMLIndexer` to traverse.
*/
private func childrenAsArray(indexer: XMLIndexer) -> XPCArray? {
    let children = indexer.children
    if children.count > 0 {
        return children.flatMap({ $0.element }).map {
            [$0.name: $0.text ?? ""] as XPCDictionary
        } as XPCArray
    }
    return nil
}
