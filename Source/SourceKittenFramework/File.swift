//
//  File.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
import SWXMLHash
#if SWIFT_PACKAGE
import SourceKit
#endif

/// Represents a source file.
public final class File {
    /// File path. Nil if initialized directly with `File(contents:)`.
    public let path: String?
    /// File contents.
    public var contents: String
    /// File lines.
    public var lines: [Line]

    /**
    Failable initializer by path. Fails if file contents could not be read as a UTF8 string.

    - parameter path: File path.
    */
    public init?(path: String) {
        self.path = NSString(string: path).absolutePathRepresentation()
        do {
            contents = try String(contentsOfFile: path, encoding: .utf8)
            lines = NSString(string: contents).lines()
        } catch {
            fputs("Could not read contents of `\(path)`\n", stderr)
            return nil
        }
    }

    /**
    Initializer by file contents. File path is nil.

    - parameter contents: File contents.
    */
    public init(contents: String) {
        path = nil
        self.contents = contents
        lines = NSString(string: contents).lines()
    }

    /**
     Formats the file.
     */
    public func format(trimmingTrailingWhitespace: Bool,
                       useTabs: Bool,
                       indentWidth: Int) -> String {
        guard let path = path else {
            return contents
        }
        _ = Request.EditorOpen(file: self).send()
        var newContents = [String]()
        var offset = 0
        for line in lines {
            let formatResponse = Request.Format(file: path,
                                                line: Int64(line.index),
                                                useTabs: useTabs,
                                                indentWidth: Int64(indentWidth)).send()
            let newText = formatResponse["key.sourcetext"] as! String
            newContents.append(newText)

            guard newText != line.content else { continue }

            _ = Request.ReplaceText(file: path,
                                    offset: Int64(line.byteRange.location + offset),
                                    length: Int64(line.byteRange.length - 1),
                                    sourceText: newText).send()
            let oldLength = line.byteRange.length
            let newLength = newText.lengthOfBytes(using: .utf8)
            offset += 1 + newLength - oldLength
        }

        if trimmingTrailingWhitespace {
            newContents = newContents.map {
                NSString(string: $0).stringByTrimmingTrailingCharactersInSet(characterSet: .whitespaces)
            }
        }

        return newContents.joined(separator: "\n")
    }

    /**
    Parse source declaration string from SourceKit dictionary.

    - parameter dictionary: SourceKit dictionary to extract declaration from.

    - returns: Source declaration if successfully parsed.
    */
    public func parseDeclaration(_ dictionary: [String: SourceKitRepresentable]) -> String? {
        guard shouldParseDeclaration(dictionary),
            let start = SwiftDocKey.getOffset(dictionary).map({ Int($0) }) else {
            return nil
        }
        let substring: String?
        if let end = SwiftDocKey.getBodyOffset(dictionary) {
            substring = NSString(string: contents).substringStartingLinesWithByteRange(start: start, length: Int(end) - start)
        } else {
            substring = NSString(string: contents).substringLinesWithByteRange(start: start, length: 0)
        }
        return substring?.stringByTrimmingWhitespaceAndOpeningCurlyBrace()
    }

    /**
    Parse line numbers containing the declaration's implementation from SourceKit dictionary.
    
    - parameter dictionary: SourceKit dictionary to extract declaration from.
    
    - returns: Line numbers containing the declaration's implementation.
    */
    public func parseScopeRange(_ dictionary: [String: SourceKitRepresentable]) -> (start: Int, end: Int)? {
        if !shouldParseDeclaration(dictionary) {
            return nil
        }
        return SwiftDocKey.getOffset(dictionary).flatMap { start in
            let start = Int(start)
            let end = SwiftDocKey.getBodyOffset(dictionary).flatMap { bodyOffset in
                return SwiftDocKey.getBodyLength(dictionary).map { bodyLength in
                    return Int(bodyOffset + bodyLength)
                }
            } ?? start
            let length = end - start
            return NSString(string: contents).lineRangeWithByteRange(start: start, length: length)
        }
    }

    /**
    Extract mark-style comment string from doc dictionary. e.g. '// MARK: - The Name'

    - parameter dictionary: Doc dictionary to parse.

    - returns: Mark name if successfully parsed.
    */
    private func markNameFromDictionary(_ dictionary: [String: SourceKitRepresentable]) -> String? {
        precondition(SwiftDocKey.getKind(dictionary)! == SyntaxKind.CommentMark.rawValue)
        let offset = Int(SwiftDocKey.getOffset(dictionary)!)
        let length = Int(SwiftDocKey.getLength(dictionary)!)
        let fileContentsData = contents.data(using: .utf8)
        let subdata = fileContentsData?.subdata(in: Range(offset..<(offset + length)))
        return subdata.flatMap({ String(data: $0, encoding: .utf8) })
    }

    /**
    Returns a copy of the input dictionary with comment mark names, cursor.info information and
    parsed declarations for the top-level of the input dictionary and its substructures.

    - parameter dictionary:        Dictionary to process.
    - parameter cursorInfoRequest: Cursor.Info request to get declaration information.
    */
    public func processDictionary(_ dictionary: [String: SourceKitRepresentable], cursorInfoRequest: sourcekitd_object_t? = nil, syntaxMap: SyntaxMap? = nil) -> [String: SourceKitRepresentable] {
        var dictionary = dictionary
        if let cursorInfoRequest = cursorInfoRequest {
            dictionary = merge(
                dictionary,
                dictWithCommentMarkNamesCursorInfo(dictionary, cursorInfoRequest: cursorInfoRequest)
            )
        }

        // Parse declaration and add to dictionary
        if let parsedDeclaration = parseDeclaration(dictionary) {
            dictionary[SwiftDocKey.ParsedDeclaration.rawValue] = parsedDeclaration
        }

        // Parse scope range and add to dictionary
        if let parsedScopeRange = parseScopeRange(dictionary) {
            dictionary[SwiftDocKey.ParsedScopeStart.rawValue] = Int64(parsedScopeRange.start)
            dictionary[SwiftDocKey.ParsedScopeEnd.rawValue] = Int64(parsedScopeRange.end)
        }

        // Parse `key.doc.full_as_xml` and add to dictionary
        if let parsedXMLDocs = (SwiftDocKey.getFullXMLDocs(dictionary).flatMap(parseFullXMLDocs)) {
            dictionary = merge(dictionary, parsedXMLDocs)
        }

        if let commentBody = (syntaxMap.flatMap { getDocumentationCommentBody(dictionary, syntaxMap: $0) }) {
            // Parse documentation comment and add to dictionary
            dictionary[SwiftDocKey.DocumentationComment.rawValue] = commentBody
        }

        // Update substructure
        if let substructure = newSubstructure(dictionary, cursorInfoRequest: cursorInfoRequest, syntaxMap: syntaxMap) {
            dictionary[SwiftDocKey.Substructure.rawValue] = substructure
        }
        return dictionary
    }

    /**
    Returns a copy of the input dictionary with additional cursorinfo information at the given
    `documentationTokenOffsets` that haven't yet been documented.

    - parameter dictionary:             Dictionary to insert new docs into.
    - parameter documentedTokenOffsets: Offsets that are likely documented.
    - parameter cursorInfoRequest:      Cursor.Info request to get declaration information.
    */
    internal func furtherProcessDictionary(dictionary: [String: SourceKitRepresentable], documentedTokenOffsets: [Int], cursorInfoRequest: sourcekitd_object_t, syntaxMap: SyntaxMap) -> [String: SourceKitRepresentable] {
        var dictionary = dictionary
        let offsetMap = generateOffsetMap(documentedTokenOffsets: documentedTokenOffsets, dictionary: dictionary)
        for offset in offsetMap.keys.reversed() { // Do this in reverse to insert the doc at the correct offset
            if let response = Request.sendCursorInfoRequest(cursorInfoRequest, atOffset: Int64(offset)).map({ processDictionary($0, cursorInfoRequest: nil, syntaxMap: syntaxMap) }),
                kind = SwiftDocKey.getKind(response),
                _ = SwiftDeclarationKind(rawValue: kind),
                parentOffset = offsetMap[offset].flatMap({ Int64($0) }),
                inserted = insertDoc(response, parent: dictionary, offset: parentOffset) {
                dictionary = inserted
            }
        }
        return dictionary
    }

    /**
    Update input dictionary's substructure by running `processDictionary(_:cursorInfoRequest:syntaxMap:)` on
    its elements, only keeping comment marks and declarations.

    - parameter dictionary:        Input dictionary to process its substructure.
    - parameter cursorInfoRequest: Cursor.Info request to get declaration information.

    - returns: A copy of the input dictionary's substructure processed by running
               `processDictionary(_:cursorInfoRequest:syntaxMap:)` on its elements, only keeping comment marks
               and declarations.
    */
    private func newSubstructure(_ dictionary: [String: SourceKitRepresentable], cursorInfoRequest: sourcekitd_object_t?, syntaxMap: SyntaxMap?) -> [SourceKitRepresentable]? {
        return SwiftDocKey.getSubstructure(dictionary)?
            .map({ $0 as! [String: SourceKitRepresentable] })
            .filter(isDeclarationOrCommentMark)
            .map {
                processDictionary($0, cursorInfoRequest: cursorInfoRequest, syntaxMap: syntaxMap)
        }
    }

    /**
    Returns an updated copy of the input dictionary with comment mark names and cursor.info information.

    - parameter dictionary:        Dictionary to update.
    - parameter cursorInfoRequest: Cursor.Info request to get declaration information.
    */
    private func dictWithCommentMarkNamesCursorInfo(_ dictionary: [String: SourceKitRepresentable], cursorInfoRequest: sourcekitd_object_t) -> [String: SourceKitRepresentable]? {
        guard let kind = SwiftDocKey.getKind(dictionary) else {
            return nil
        }
        // Only update dictionaries with a 'kind' key
        if kind == SyntaxKind.CommentMark.rawValue, let markName = markNameFromDictionary(dictionary) {
            // Update comment marks
            return [SwiftDocKey.Name.rawValue: markName]
        } else if let decl = SwiftDeclarationKind(rawValue: kind) where decl != .VarParameter {
            // Update if kind is a declaration (but not a parameter)
            var updateDict = Request.sendCursorInfoRequest(cursorInfoRequest,
                atOffset: SwiftDocKey.getNameOffset(dictionary)!) ?? [String: SourceKitRepresentable]()

            // Skip kinds, since values from editor.open are more accurate than cursorinfo
            updateDict.removeValue(forKey: SwiftDocKey.Kind.rawValue)

            // Skip offset and length.
            // Their values are same with "key.nameoffset" and "key.namelength" in most case.
            // When kind is extension, their values locate **the type's declaration** in their declared file.
            // That may be different from the file declaring extension.
            updateDict.removeValue(forKey: SwiftDocKey.Offset.rawValue)
            updateDict.removeValue(forKey: SwiftDocKey.Length.rawValue)
            return updateDict
        }
        return nil
    }

    /**
    Returns whether or not a doc should be inserted into a parent at the provided offset.

    - parameter parent: Parent dictionary to evaluate.
    - parameter offset: Offset to search for in parent dictionary.

    - returns: True if a doc should be inserted in the parent at the provided offset.
    */
    private func shouldInsert(_ parent: [String: SourceKitRepresentable], offset: Int64) -> Bool {
        return SwiftDocKey.getSubstructure(parent) != nil &&
            ((offset == 0) ||
            (shouldTreatAsSameFile(parent) && SwiftDocKey.getNameOffset(parent) == offset))
    }

    /**
    Inserts a document dictionary at the specified offset.
    Parent will be traversed until the offset is found.
    Returns nil if offset could not be found.

    - parameter doc:    Document dictionary to insert.
    - parameter parent: Parent to traverse to find insertion point.
    - parameter offset: Offset to insert document dictionary.

    - returns: Parent with doc inserted if successful.
    */
    private func insertDoc(_ doc: [String: SourceKitRepresentable], parent: [String: SourceKitRepresentable], offset: Int64) -> [String: SourceKitRepresentable]? {
        var parent = parent
        if shouldInsert(parent, offset: offset) {
            var substructure = SwiftDocKey.getSubstructure(parent)!
            var insertIndex = substructure.count
            for (index, structure) in substructure.reversed().enumerated() {
                if SwiftDocKey.getOffset(structure as! [String: SourceKitRepresentable])! < offset {
                    break
                }
                insertIndex = substructure.count - index
            }
            substructure.insert(doc, at: insertIndex)
            parent[SwiftDocKey.Substructure.rawValue] = substructure
            return parent
        }
        for key in parent.keys {
            if let subArray = parent[key] as? [SourceKitRepresentable] {
                var subArray = subArray
                for i in 0..<subArray.count {
                    if let subDict = insertDoc(doc, parent: subArray[i] as! [String: SourceKitRepresentable], offset: offset) {
                        subArray[i] = subDict
                        parent[key] = subArray
                        return parent
                    }
                }
            }
        }
        return nil
    }

    /**
    Returns true if path is nil or if path has the same last path component as `key.filepath` in the
    input dictionary.

    - parameter dictionary: Dictionary to parse.
    */
    internal func shouldTreatAsSameFile(_ dictionary: [String: SourceKitRepresentable]) -> Bool {
        return path == SwiftDocKey.getFilePath(dictionary)
    }

    /**
    Returns true if the input dictionary contains a parseable declaration.

    - parameter dictionary: Dictionary to parse.
    */
    private func shouldParseDeclaration(_ dictionary: [String: SourceKitRepresentable]) -> Bool {
        let sameFile                = shouldTreatAsSameFile(dictionary)
        let hasTypeName             = SwiftDocKey.getTypeName(dictionary) != nil
        let hasAnnotatedDeclaration = SwiftDocKey.getAnnotatedDeclaration(dictionary) != nil
        let hasOffset               = SwiftDocKey.getOffset(dictionary) != nil
        let isntExtension           = SwiftDocKey.getKind(dictionary) != SwiftDeclarationKind.Extension.rawValue
        return sameFile && hasTypeName && hasAnnotatedDeclaration && hasOffset && isntExtension
    }

    /**
    Parses `dictionary`'s documentation comment body.

    - parameter dictionary: Dictionary to parse.
    - parameter syntaxMap:  SyntaxMap for current file.

    - returns: `dictionary`'s documentation comment body as a string, without any documentation
               syntax (`/** ... */` or `/// ...`).
    */
    public func getDocumentationCommentBody(_ dictionary: [String: SourceKitRepresentable], syntaxMap: SyntaxMap) -> String? {
        let isExtension = SwiftDocKey.getKind(dictionary).flatMap({ SwiftDeclarationKind(rawValue: $0) }) == .Extension
        let hasFullXMLDocs = dictionary.keys.contains(SwiftDocKey.FullXMLDocs.rawValue)
        let hasRawDocComment: Bool = {
            if !dictionary.keys.contains("key.attributes") { return false }
            let attributes = (dictionary["key.attributes"] as! [SourceKitRepresentable])
                .flatMap({ ($0 as! [String: SourceKitRepresentable]).values })
                .map({ $0 as! String })
            return attributes.contains("source.decl.attribute.__raw_doc_comment")
        }()

        let hasDocumentationComment = (hasFullXMLDocs && !isExtension) || hasRawDocComment
        guard hasDocumentationComment else { return nil }

        let maybeOffset = isExtension ? SwiftDocKey.getNameOffset(dictionary) : SwiftDocKey.getOffset(dictionary)
        return maybeOffset.flatMap { offset in
            return syntaxMap.commentRangeBeforeOffset(Int(offset)).flatMap { commentByteRange in
                return NSString(string: contents).byteRangeToNSRange(start: commentByteRange.lowerBound, length: commentByteRange.upperBound - commentByteRange.lowerBound).flatMap { nsRange in
                    return contents.commentBody(range: nsRange)
                }
            }
        }
    }
}

/**
Returns true if the dictionary represents a source declaration or a mark-style comment.

- parameter dictionary: Dictionary to parse.
*/
private func isDeclarationOrCommentMark(_ dictionary: [String: SourceKitRepresentable]) -> Bool {
    if let kind = SwiftDocKey.getKind(dictionary) {
        return kind != SwiftDeclarationKind.VarParameter.rawValue &&
            (kind == SyntaxKind.CommentMark.rawValue || SwiftDeclarationKind(rawValue: kind) != nil)
    }
    return false
}

/**
Parse XML from `key.doc.full_as_xml` from `cursor.info` request.

- parameter xmlDocs: Contents of `key.doc.full_as_xml` from SourceKit.

- returns: XML parsed as an `[String: SourceKitRepresentable]`.
*/
public func parseFullXMLDocs(_ xmlDocs: String) -> [String: SourceKitRepresentable]? {
    let cleanXMLDocs = xmlDocs.replacingOccurrences(of: "<rawHTML>", with: "")
        .replacingOccurrences(of: "</rawHTML>", with: "")
        .replacingOccurrences(of: "<codeVoice>", with: "`")
        .replacingOccurrences(of: "</codeVoice>", with: "`")
    return SWXMLHash.parse(cleanXMLDocs).children.first.map { rootXML in
        var docs = [String: SourceKitRepresentable]()
        docs[SwiftDocKey.DocType.rawValue] = rootXML.element?.name
        docs[SwiftDocKey.DocFile.rawValue] = rootXML.element?.attributes["file"]
        docs[SwiftDocKey.DocLine.rawValue] = rootXML.element?.attributes["line"].flatMap {
            Int64($0)
        }
        docs[SwiftDocKey.DocColumn.rawValue] = rootXML.element?.attributes["column"].flatMap {
            Int64($0)
        }
        docs[SwiftDocKey.DocName.rawValue] = rootXML["Name"].element?.text
        docs[SwiftDocKey.USR.rawValue] = rootXML["USR"].element?.text
        docs[SwiftDocKey.DocDeclaration.rawValue] = rootXML["Declaration"].element?.text
        let parameters = rootXML["Parameters"].children
        if parameters.count > 0 {
            docs[SwiftDocKey.DocParameters.rawValue] = parameters.map {
                [
                    "name": $0["Name"].element?.text ?? "",
                    "discussion": childrenAsArray($0["Discussion"]) ?? []
                ] as [String: SourceKitRepresentable]
            } as [SourceKitRepresentable]
        }
        docs[SwiftDocKey.DocDiscussion.rawValue] = childrenAsArray(rootXML["Discussion"])
        docs[SwiftDocKey.DocResultDiscussion.rawValue] = childrenAsArray(rootXML["ResultDiscussion"])
        return docs
    }
}

/**
Returns an `[SourceKitRepresentable]` of `[String: SourceKitRepresentable]` items from `indexer` children, if any.

- parameter indexer: `XMLIndexer` to traverse.
*/
private func childrenAsArray(_ indexer: XMLIndexer) -> [SourceKitRepresentable]? {
    let children = indexer.children
    if children.count > 0 {
        return children.flatMap({ $0.element }).map {
            [$0.name: $0.text ?? ""] as [String: SourceKitRepresentable]
        } as [SourceKitRepresentable]
    }
    return nil
}
