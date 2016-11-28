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
        self.path = path.bridge().absolutePathRepresentation()
        do {
            contents = try String(contentsOfFile: path, encoding: .utf8)
            lines = contents.bridge().lines()
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
        lines = contents.bridge().lines()
    }

    /// Formats the file.
    ///
    /// - Parameters:
    ///   - trimmingTrailingWhitespace: Boolean
    ///   - useTabs: Boolean
    ///   - indentWidth: Int
    /// - Returns: formatted String
    /// - Throws: Request.Error
    public func format(trimmingTrailingWhitespace: Bool,
                       useTabs: Bool,
                       indentWidth: Int) throws -> String {
        guard let path = path else {
            return contents
        }
        _ = try Request.editorOpen(file: self).failableSend()
        var newContents = [String]()
        var offset = 0
        for line in lines {
            let formatResponse = try Request.format(file: path,
                                                line: Int64(line.index),
                                                useTabs: useTabs,
                                                indentWidth: Int64(indentWidth)).failableSend()
            let newText = formatResponse.sourceText!
            newContents.append(newText)

            guard newText != line.content else { continue }

            _ = try Request.replaceText(file: path,
                                    offset: Int64(line.byteRange.location + offset),
                                    length: Int64(line.byteRange.length - 1),
                                    sourceText: newText).failableSend()
            let oldLength = line.byteRange.length
            let newLength = newText.lengthOfBytes(using: .utf8)
            offset += 1 + newLength - oldLength
        }

        if trimmingTrailingWhitespace {
            newContents = newContents.map {
                $0.bridge().trimmingTrailingCharacters(in: .whitespaces)
            }
        }

        return newContents.joined(separator: "\n") + "\n"
    }

    /**
    Parse source declaration string from SourceKit dictionary.

    - parameter dictionary: SourceKit dictionary to extract declaration from.

    - returns: Source declaration if successfully parsed.
    */
    public func parseDeclaration(_ dictionary: SourceKitVariant) -> String? {
        guard shouldParseDeclaration(dictionary),
            let start = dictionary.offset else {
            return nil
        }
        let substring: String?
        if let end = dictionary.bodyOffset {
            substring = contents.bridge().substringStartingLinesWithByteRange(start: start, length: Int(end) - start)
        } else {
            substring = contents.bridge().substringLinesWithByteRange(start: start, length: 0)
        }
        return substring?.trimmingWhitespaceAndOpeningCurlyBrace()
    }

    /**
    Parse line numbers containing the declaration's implementation from SourceKit dictionary.
    
    - parameter dictionary: SourceKit dictionary to extract declaration from.
    
    - returns: Line numbers containing the declaration's implementation.
    */
    public func parseScopeRange(_ dictionary: SourceKitVariant) -> (start: Int, end: Int)? {
        if !shouldParseDeclaration(dictionary) {
            return nil
        }
        return dictionary.offset.flatMap { start in
            let end = dictionary.bodyOffset.flatMap { bodyOffset in
                dictionary.bodyLength.map { bodyLength in
                    bodyOffset + bodyLength
                }
            } ?? start
            let length = end - start
            return contents.bridge().lineRangeWithByteRange(start: start, length: length)
        }
    }

    /**
    Extract mark-style comment string from doc dictionary. e.g. '// MARK: - The Name'

    - parameter dictionary: Doc dictionary to parse.

    - returns: Mark name if successfully parsed.
    */
    private func parseMarkName(_ dictionary: SourceKitVariant) -> String? {
        precondition(dictionary.kind == UID.SourceLangSwiftSyntaxtype.commentMark)
        guard let offset = dictionary.offset,
            let length = dictionary.length,
            let fileContentsData = contents.data(using: .utf8) else {
                return nil
        }
        let subdata = fileContentsData.subdata(in: Range(offset..<(offset + length)))
        return String(data: subdata, encoding: .utf8)
    }

    /**
    Returns a copy of the input dictionary with comment mark names, cursor.info information and
    parsed declarations for the top-level of the input dictionary and its substructures.

    - parameter dictionary:        Dictionary to process.
    - parameter cursorInfoRequest: Cursor.Info request to get declaration information.
    */
    public func process(dictionary: SourceKitVariant, cursorInfoRequest: sourcekitd_object_t? = nil, syntaxMap: SyntaxMap? = nil) -> SourceKitVariant {
        var dictionary = dictionary
        if let cursorInfoRequest = cursorInfoRequest {
            dictionary = dictionary.merging(with:
                dictWithCommentMarkNamesCursorInfo(dictionary, cursorInfoRequest: cursorInfoRequest)
            )
        }

        // Parse declaration and add to dictionary
        if let parsedDeclaration = parseDeclaration(dictionary) {
            dictionary.parsedDeclaration = parsedDeclaration
        }

        // Parse scope range and add to dictionary
        if let parsedScopeRange = parseScopeRange(dictionary) {
            dictionary.parsedScopeStart = parsedScopeRange.start
            dictionary.parsedScopeEnd = parsedScopeRange.end
        }

        // Parse `key.doc.full_as_xml` and add to dictionary
        if let parsedXMLDocs = dictionary.docFullAsXML.flatMap(parseFullXMLDocs) {
            dictionary = dictionary.merging(with: parsedXMLDocs)
        }

        if let commentBody = (syntaxMap.flatMap { parseDocumentationCommentBody(dictionary, syntaxMap: $0) }) {
            // Parse documentation comment and add to dictionary
            dictionary.documentationComment = commentBody
        }

        // Update substructure
        if let substructure = newSubstructure(dictionary, cursorInfoRequest: cursorInfoRequest, syntaxMap: syntaxMap) {
            dictionary.subStructure = substructure
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
    internal func furtherProcess(dictionary: SourceKitVariant, documentedTokenOffsets: [Int], cursorInfoRequest: sourcekitd_object_t, syntaxMap: SyntaxMap) -> SourceKitVariant {
        var dictionary = dictionary
        let offsetMap = makeOffsetMap(documentedTokenOffsets: documentedTokenOffsets, dictionary: dictionary)
        for offset in offsetMap.keys.reversed() { // Do this in reverse to insert the doc at the correct offset
            if let response = Request.send(cursorInfoRequest: cursorInfoRequest, atOffset: offset).map({ process(dictionary: $0, cursorInfoRequest: nil, syntaxMap: syntaxMap) }),
                let kind = response.kind,
                kind.isMemberOfSourceLangSwiftDecl,
                let parentOffset = offsetMap[offset],
                let inserted = insert(doc: response, parent: dictionary, offset: parentOffset) {
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
    private func newSubstructure(_ dictionary: SourceKitVariant, cursorInfoRequest: sourcekitd_object_t?, syntaxMap: SyntaxMap?) -> [SourceKitVariant]? {
        return dictionary.subStructure?
            .filter(isDeclarationOrCommentMark)
            .map {
                process(dictionary: $0, cursorInfoRequest: cursorInfoRequest, syntaxMap: syntaxMap)
        }
    }

    /**
    Returns an updated copy of the input dictionary with comment mark names and cursor.info information.

    - parameter dictionary:        Dictionary to update.
    - parameter cursorInfoRequest: Cursor.Info request to get declaration information.
    */
    private func dictWithCommentMarkNamesCursorInfo(_ sourceKitVariant: SourceKitVariant, cursorInfoRequest: sourcekitd_object_t) -> SourceKitVariant? {
        guard let kind = sourceKitVariant.kind else {
            return nil
        }
        // Only update dictionaries with a 'kind' key
        if kind == UID.SourceLangSwiftSyntaxtype.commentMark, let markName = parseMarkName(sourceKitVariant) {
            // Update comment marks
            return [UID.Key.name.uid: SourceKitVariant(markName)]
        } else if kind != UID.SourceLangSwiftDecl.varParameter {
            // Update if kind is a declaration (but not a parameter)
            var updateDict = Request.send(cursorInfoRequest: cursorInfoRequest,
                atOffset: sourceKitVariant.nameOffset!) ?? [:]

            // Skip kinds, since values from editor.open are more accurate than cursorinfo
            updateDict.removeValue(forKey: .kind)

            // Skip offset and length.
            // Their values are same with "key.nameoffset" and "key.namelength" in most case.
            // When kind is extension, their values locate **the type's declaration** in their declared file.
            // That may be different from the file declaring extension.
            updateDict.removeValue(forKey: .offset)
            updateDict.removeValue(forKey: .length)
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
    private func shouldInsert(parent: SourceKitVariant, offset: Int) -> Bool {
        return parent.subStructure != nil &&
            ((offset == 0) ||
            (shouldTreatAsSameFile(parent) && parent.nameOffset == offset))
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
    private func insert(doc: SourceKitVariant, parent: SourceKitVariant, offset: Int) -> SourceKitVariant? {
        var parent = parent
        if shouldInsert(parent: parent, offset: offset) {
            var substructure = parent.subStructure!
            var insertIndex = substructure.count
            for (index, structure) in substructure.reversed().enumerated() {
                if structure.offset! < offset {
                    break
                }
                insertIndex = substructure.count - index
            }
            substructure.insert(doc, at: insertIndex)
            parent.subStructure = substructure
            return parent
        }
        for (key, value) in parent.dictionary! {
            if var subArray = value.array {
                for i in 0..<subArray.count {
                    if let subDict = insert(doc: doc, parent: subArray[i], offset: offset) {
                        subArray[i] = subDict
                        parent[key] = SourceKitVariant(subArray)
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
    internal func shouldTreatAsSameFile(_ sourceKitVariant: SourceKitVariant) -> Bool {
        return path == sourceKitVariant.filePath
    }

    /**
    Returns true if the input dictionary contains a parseable declaration.

    - parameter dictionary: Dictionary to parse.
    */
    private func shouldParseDeclaration(_ sourceKitVariant: SourceKitVariant) -> Bool {
        let sameFile                = shouldTreatAsSameFile(sourceKitVariant)
        let hasTypeName             = sourceKitVariant.typeName != nil
        let hasAnnotatedDeclaration = sourceKitVariant.annotatedDeclaration != nil
        let hasOffset               = sourceKitVariant.offset != nil
        let isntExtension           = sourceKitVariant.kind != UID.SourceLangSwiftDecl.extension
        return sameFile && hasTypeName && hasAnnotatedDeclaration && hasOffset && isntExtension
    }

    /**
    Parses `dictionary`'s documentation comment body.

    - parameter dictionary: Dictionary to parse.
    - parameter syntaxMap:  SyntaxMap for current file.

    - returns: `dictionary`'s documentation comment body as a string, without any documentation
               syntax (`/** ... */` or `/// ...`).
    */
    public func parseDocumentationCommentBody(_ variant: SourceKitVariant, syntaxMap: SyntaxMap) -> String? {
        let isExtension = variant.kind == UID.SourceLangSwiftDecl.extension
        let hasFullXMLDocs = variant.docFullAsXML != nil
        let hasRawDocComment = variant
            .attributes?
            .flatMap({ $0.attribute?.description })
            .contains("source.decl.attribute.__raw_doc_comment") ?? false

        let hasDocumentationComment = (hasFullXMLDocs && !isExtension) || hasRawDocComment
        guard hasDocumentationComment else { return nil }

        if let offset = isExtension ? variant.nameOffset : variant.offset,
           let commentByteRange = syntaxMap.commentRange(beforeOffset: offset),
           let nsRange = contents.bridge().byteRangeToNSRange(start: commentByteRange.lowerBound, length: commentByteRange.upperBound - commentByteRange.lowerBound) {
            return contents.commentBody(range: nsRange)
        }
        return nil
    }
}

/**
Returns true if the dictionary represents a source declaration or a mark-style comment.

- parameter dictionary: Dictionary to parse.
*/
private func isDeclarationOrCommentMark(_ dictionary: SourceKitVariant) -> Bool {
    if let kind = dictionary.kind {
        return kind != UID.SourceLangSwiftDecl.varParameter &&
            (kind == UID.SourceLangSwiftSyntaxtype.commentMark || kind.isMemberOfSourceLangSwiftDecl)
    }
    return false
}

/**
Parse XML from `key.doc.full_as_xml` from `cursor.info` request.

- parameter xmlDocs: Contents of `key.doc.full_as_xml` from SourceKit.

- returns: XML parsed as an `SourceKitVariant`.
*/
public func parseFullXMLDocs(_ xmlDocs: String) -> SourceKitVariant? {
    let cleanXMLDocs = xmlDocs.replacingOccurrences(of: "<rawHTML>", with: "")
        .replacingOccurrences(of: "</rawHTML>", with: "")
        .replacingOccurrences(of: "<codeVoice>", with: "`")
        .replacingOccurrences(of: "</codeVoice>", with: "`")
    return SWXMLHash.parse(cleanXMLDocs).children.first.map { rootXML in
        var docs: SourceKitVariant = [:]
        docs.docType = rootXML.element?.name
        docs.docFile = rootXML.element?.allAttributes["file"]?.text
        docs.docLine = (rootXML.element?.allAttributes["line"]?.text).flatMap { Int($0) }
        docs.docColumn = (rootXML.element?.allAttributes["column"]?.text).flatMap { Int($0) }
        docs.docName = rootXML["Name"].element?.text
        docs.usr = rootXML["USR"].element?.text
        docs.docDeclaration = rootXML["Declaration"].element?.text
        let parameters = rootXML["Parameters"].children
        if !parameters.isEmpty {
            func docParameters(from indexer: XMLIndexer) -> SourceKitVariant {
                return [
                    "name": SourceKitVariant(indexer["Name"].element?.text ?? ""),
                    "discussion": SourceKitVariant(indexer["Discussion"].childrenAsArray() ?? []),
                ]
            }
            docs.docParameters = parameters.map(docParameters(from:))
        }
        docs.docDiscussion = rootXML["Discussion"].childrenAsArray()
        docs.docResultDiscussion = rootXML["ResultDiscussion"].childrenAsArray()
        return docs
    }
}

private extension XMLIndexer {
    /**
    Returns an `[SourceKitVariant]` of `[UID:SourceKitVariant]` items from `indexer` children, if any.
    */
    func childrenAsArray() -> [SourceKitVariant]? {
        if children.isEmpty {
            return nil
        }
        let elements = children.flatMap { $0.element }
        func variant(from element: SWXMLHash.XMLElement) -> SourceKitVariant {
            return [UID(element.name): SourceKitVariant(element.text ?? "")]
        }
        return elements.map(variant(from:))
    }
}

// MARK: - migration support
extension File {
    @available(*, unavailable, renamed: "process(dictionary:cursorInfoRequest:syntaxMap:)")
    public func processDictionary(_ dictionary: [String: SourceKitRepresentable], cursorInfoRequest: sourcekitd_object_t? = nil, syntaxMap: SyntaxMap? = nil) -> [String: SourceKitRepresentable] {
        fatalError()
    }

    @available(*, unavailable, renamed: "parseDocumentationCommentBody(_:syntaxMap:)")
    public func getDocumentationCommentBody(_ dictionary: [String: SourceKitRepresentable], syntaxMap: SyntaxMap) -> String? {
        fatalError()
    }
}
