//
//  String+SourceKitten.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-05.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation

// swiftlint:disable file_length
// This file could easily be split up

/// Representation of line in String
public struct Line {
    /// origin = 0
    public let index: Int
    /// Content
    public let content: String
    /// UTF16 based range in entire String. Equivalent to Range<UTF16Index>
    public let range: NSRange
    /// Byte based range in entire String. Equivalent to Range<UTF8Index>
    public let byteRange: NSRange
}

/**
 * For "wall of asterisk" comment blocks, such as this one.
 */
private let commentLinePrefixCharacterSet: CharacterSet = {
    var characterSet = CharacterSet.whitespacesAndNewlines
    characterSet.insert(charactersIn: "*")
    return characterSet
}()

// swiftlint:disable:next line_length
// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/swift/grammar/line-break
private let newlinesCharacterSet = CharacterSet(charactersIn: "\u{000A}\u{000D}")

private extension RandomAccessCollection {
    /// Binary search assuming the collection is already sorted.
    ///
    /// - parameter comparing: Comparison function.
    ///
    /// - returns: The index in the collection of the element matching the `comparing` function.
    func indexAssumingSorted(comparing: (Element) throws -> ComparisonResult) rethrows -> Index? {
        guard !isEmpty else {
            return nil
        }

        var lowerBound = startIndex
        var upperBound = index(before: endIndex)
        var midIndex: Index

        while lowerBound <= upperBound {
            let boundDistance = distance(from: lowerBound, to: upperBound)
            midIndex = index(lowerBound, offsetBy: boundDistance / 2)
            let midElem = self[midIndex]

            switch try comparing(midElem) {
            case .orderedDescending: lowerBound = index(midIndex, offsetBy: 1)
            case .orderedAscending: upperBound = index(midIndex, offsetBy: -1)
            case .orderedSame: return midIndex
            }
        }

        return nil
    }
}

extension NSString {
    public func lineAndCharacterForCharacterOffset(offset: Int) -> (line: Int, character: Int)? {
        let range = NSRange(location: offset, length: 0)
        var numberOfLines = 0, index = 0, lineRangeStart = 0, previousIndex = 0
        while index < length {
            numberOfLines += 1
            if index > range.location {
                break
            }
            lineRangeStart = numberOfLines
            previousIndex = index
            index = NSMaxRange(lineRange(for: NSRange(location: index, length: 1)))
        }
        return (lineRangeStart, range.location - previousIndex + 1)
    }

    /**
    Returns a copy of `self` with the trailing contiguous characters belonging to `characterSet`
    removed.

    - parameter characterSet: Character set to check for membership.
    */
    public func trimmingTrailingCharacters(in characterSet: CharacterSet) -> String {
        guard length > 0 else {
            return ""
        }
        var unicodeScalars = self.bridge().unicodeScalars
        while let scalar = unicodeScalars.last {
            if !characterSet.contains(scalar) {
                return String(unicodeScalars)
            }
            unicodeScalars.removeLast()
        }
        return ""
    }

    /**
    Returns self represented as an absolute path.

    - parameter rootDirectory: Absolute parent path if not already an absolute path.
    */
    public func absolutePathRepresentation(rootDirectory: String = FileManager.default.currentDirectoryPath) -> String {
        if isAbsolutePath { return bridge() }
#if os(Linux)
        return NSURL(fileURLWithPath: NSURL.fileURL(withPathComponents: [rootDirectory, bridge()])!.path).standardizingPath!.path
#else
        return NSString.path(withComponents: [rootDirectory, bridge()]).bridge().standardizingPath
#endif
    }

    /**
    Converts a range of byte offsets in `self` to an `NSRange` suitable for filtering `self` as an
    `NSString`.

    - parameter start: Starting byte offset.
    - parameter length: Length of bytes to include in range.

    - returns: An equivalent `NSRange`.
    */
    public func byteRangeToNSRange(start: Int, length: Int) -> NSRange? {
        let string = self as String
        let startUTF8Index = string.utf8.index(string.utf8.startIndex, offsetBy: start)
        let endUTF8Index = string.utf8.index(startUTF8Index, offsetBy: length)
        
        let utf16View = string.utf16
        guard let startUTF16Index = startUTF8Index.samePosition(in: utf16View),
            let endUTF16Index = endUTF8Index.samePosition(in: utf16View) else {
                return nil
        }
        
        let location = utf16View.distance(from: utf16View.startIndex, to: startUTF16Index)
        let length = utf16View.distance(from: startUTF16Index, to: endUTF16Index)
        return NSRange(location: location, length: length)
    }

    /**
    Converts an `NSRange` suitable for filtering `self` as an
    `NSString` to a range of byte offsets in `self`.

    - parameter start: Starting character index in the string.
    - parameter length: Number of characters to include in range.

    - returns: An equivalent `NSRange`.
    */
    public func NSRangeToByteRange(start: Int, length: Int) -> NSRange? {
        let string = self as String
        let startUTF16Index = string.utf16.index(string.utf16.startIndex, offsetBy: start)
        let endUTF16Index = string.utf16.index(startUTF16Index, offsetBy: length)
        
        let utf8View = string.utf8
        guard let startUTF8Index = startUTF16Index.samePosition(in: utf8View),
            let endUTF8Index = endUTF16Index.samePosition(in: utf8View) else {
                return nil
        }
        
        let location = utf8View.distance(from: utf8View.startIndex, to: startUTF8Index)
        let length = utf8View.distance(from: startUTF8Index, to: endUTF8Index)
        return NSRange(location: location, length: length)
    }

    /**
    Returns a substring with the provided byte range.

    - parameter start: Starting byte offset.
    - parameter length: Length of bytes to include in range.
    */
    public func substringWithByteRange(start: Int, length: Int) -> String? {
        return byteRangeToNSRange(start: start, length: length).map(substring)
    }

    /**
    Returns a substring starting at the beginning of `start`'s line and ending at the end of `end`'s
    line. Returns `start`'s entire line if `end` is nil.

    - parameter start: Starting byte offset.
    - parameter length: Length of bytes to include in range.
    */
    public func substringLinesWithByteRange(start: Int, length: Int) -> String? {
        return byteRangeToNSRange(start: start, length: length).map { range in
            var lineStart = 0, lineEnd = 0
            getLineStart(&lineStart, end: &lineEnd, contentsEnd: nil, for: range)
            return substring(with: NSRange(location: lineStart, length: lineEnd - lineStart))
        }
    }

    public func substringStartingLinesWithByteRange(start: Int, length: Int) -> String? {
        return byteRangeToNSRange(start: start, length: length).map { range in
            var lineStart = 0, lineEnd = 0
            getLineStart(&lineStart, end: &lineEnd, contentsEnd: nil, for: range)
            return substring(with: NSRange(location: lineStart, length: NSMaxRange(range) - lineStart))
        }
    }

    /**
    Returns line numbers containing starting and ending byte offsets.

    - parameter start: Starting byte offset.
    - parameter length: Length of bytes to include in range.
    */
    public func lineRangeWithByteRange(start: Int, length: Int) -> (start: Int, end: Int)? {
        return byteRangeToNSRange(start: start, length: length).flatMap { range in
            var numberOfLines = 0, index = 0, lineRangeStart = 0
            while index < self.length {
                numberOfLines += 1
                if index <= range.location {
                    lineRangeStart = numberOfLines
                }
                index = NSMaxRange(lineRange(for: NSRange(location: index, length: 1)))
                if index > NSMaxRange(range) {
                    return (lineRangeStart, numberOfLines)
                }
            }
            return nil
        }
    }

    /**
    Returns an array of Lines for each line in the file.
    */
    public func lines() -> [Line] {
        let string = bridge()
        var utf16CountSoFar = 0
        var bytesSoFar = 0
        var lines = [Line]()
        let lineContents = string.components(separatedBy: newlinesCharacterSet)
        // Be compatible with `NSString.getLineStart(_:end:contentsEnd:forRange:)`
        let endsWithNewLineCharacter: Bool
        if let lastChar = string.utf16.last,
            let lastCharScalar = UnicodeScalar(lastChar) {
            endsWithNewLineCharacter = newlinesCharacterSet.contains(lastCharScalar)
        } else {
            endsWithNewLineCharacter = false
        }
        // if string ends with new line character, no empty line is generated after that.
        let enumerator = endsWithNewLineCharacter
            ? AnySequence(lineContents.dropLast().enumerated())
            : AnySequence(lineContents.enumerated())
        for (index, content) in enumerator {
            let index = index + 1
            let rangeStart = utf16CountSoFar
            let utf16Count = content.utf16.count
            utf16CountSoFar += utf16Count

            let byteRangeStart = bytesSoFar
            let byteCount = content.lengthOfBytes(using: .utf8)
            bytesSoFar += byteCount

            let newlineLength = index != lineContents.count ? 1 : 0 // FIXME: assumes \n

            let line = Line(
                index: index,
                content: content,
                range: NSRange(location: rangeStart, length: utf16Count + newlineLength),
                byteRange: NSRange(location: byteRangeStart, length: byteCount + newlineLength)
            )
            lines.append(line)

            utf16CountSoFar += newlineLength
            bytesSoFar += newlineLength
        }

        return lines
    }

    /**
    Returns true if self is an Objective-C header file.
    */
    public func isObjectiveCHeaderFile() -> Bool {
        return ["h", "hpp", "hh"].contains(pathExtension)
    }

    /**
    Returns true if self is a Swift file.
    */
    public func isSwiftFile() -> Bool {
        return pathExtension == "swift"
    }

#if !os(Linux)
    /**
    Returns a substring from a start and end SourceLocation.
    */
    public func substringWithSourceRange(start: SourceLocation, end: SourceLocation) -> String? {
        return substringWithByteRange(start: Int(start.offset), length: Int(end.offset - start.offset))
    }
#endif
}

extension String {
    internal var isFile: Bool {
        return FileManager.default.fileExists(atPath: self)
    }

    internal func capitalizingFirstLetter() -> String {
        return String(prefix(1)).capitalized + String(dropFirst())
    }

#if !os(Linux)
    /// Returns the `#pragma mark`s in the string.
    /// Just the content; no leading dashes or leading `#pragma mark`.
    public func pragmaMarks(filename: String, excludeRanges: [NSRange], limit: NSRange?) -> [SourceDeclaration] {
        let regex = try! NSRegularExpression(pattern: "(#pragma\\smark|@name)[ -]*([^\\n]+)", options: []) // Safe to force try
        let range: NSRange
        if let limit = limit {
            range = NSRange(location: limit.location, length: min(utf16.count - limit.location, limit.length))
        } else {
            range = NSRange(location: 0, length: utf16.count)
        }
        let matches = regex.matches(in: self, options: [], range: range)

        return matches.compactMap { match in
            let markRange = match.range(at: 2)
            for excludedRange in excludeRanges {
                if NSIntersectionRange(excludedRange, markRange).length > 0 {
                    return nil
                }
            }
            let markString = (self as NSString).substring(with: markRange).trimmingCharacters(in: .whitespaces)
            if markString.isEmpty {
                return nil
            }
            guard let markByteRange = self.NSRangeToByteRange(start: markRange.location, length: markRange.length) else {
                return nil
            }
            let location = SourceLocation(file: filename,
                line: UInt32((self as NSString).lineRangeWithByteRange(start: markByteRange.location, length: 0)!.start),
                column: 1, offset: UInt32(markByteRange.location))
            return SourceDeclaration(type: .mark, location: location, extent: (location, location), name: markString,
                                     usr: nil, declaration: nil, documentation: nil, commentBody: nil, children: [],
                                     swiftDeclaration: nil, swiftName: nil, availability: nil)
        }
    }
#endif

    /**
    Returns whether or not the `token` can be documented. Either because it is a
    `SyntaxKind.Identifier` or because it is a function treated as a `SyntaxKind.Keyword`:

    - `subscript`
    - `init`
    - `deinit`

    - parameter token: Token to process.
    */
    public func isTokenDocumentable(token: SyntaxToken) -> Bool {
        if token.type == SyntaxKind.keyword.rawValue {
            let keywordFunctions = ["subscript", "init", "deinit"]
            return bridge().substringWithByteRange(start: token.offset, length: token.length)
                .map(keywordFunctions.contains) ?? false
        }
        return token.type == SyntaxKind.identifier.rawValue
    }

    /**
    Find integer offsets of documented Swift tokens in self.

    - parameter syntaxMap: Syntax Map returned from SourceKit editor.open request.

    - returns: Array of documented token offsets.
    */
    public func documentedTokenOffsets(syntaxMap: SyntaxMap) -> [Int] {
        let documentableOffsets = syntaxMap.tokens.filter(isTokenDocumentable).map {
            $0.offset
        }

        let regex = try! NSRegularExpression(pattern: "(///.*\\n|\\*/\\n)", options: []) // Safe to force try
        let range = NSRange(location: 0, length: utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)

        return matches.compactMap { match in
            documentableOffsets.first { $0 >= match.range.location }
        }
    }

    /**
    Returns the body of the comment if the string is a comment.

    - parameter range: Range to restrict the search for a comment body.
    */
    public func commentBody(range: NSRange? = nil) -> String? {
        let nsString = bridge()
        let patterns: [(pattern: String, options: NSRegularExpression.Options)] = [
            ("^\\s*\\/\\*\\*\\s*(.*?)\\*\\/", [.anchorsMatchLines, .dotMatchesLineSeparators]), // multi: ^\s*\/\*\*\s*(.*?)\*\/
            ("^\\s*\\/\\/\\/(.+)?",           .anchorsMatchLines)                               // single: ^\s*\/\/\/(.+)?
            // swiftlint:disable:previous comma
        ]
        let range = range ?? NSRange(location: 0, length: nsString.length)
        for pattern in patterns {
            let regex = try! NSRegularExpression(pattern: pattern.pattern, options: pattern.options) // Safe to force try
            let matches = regex.matches(in: self, options: [], range: range)
            let bodyParts = matches.flatMap { match -> [String] in
                let numberOfRanges = match.numberOfRanges
                if numberOfRanges < 1 {
                    return []
                }
                return (1..<numberOfRanges).map { rangeIndex in
                    let range = match.range(at: rangeIndex)
                    if range.location == NSNotFound {
                        return "" // empty capture group, return empty string
                    }
                    var lineStart = 0
                    var lineEnd = nsString.length
                    let indexRange = NSRange(location: range.location, length: 0)
                    nsString.getLineStart(&lineStart, end: &lineEnd, contentsEnd: nil, for: indexRange)
                    let leadingWhitespaceCountToAdd = nsString.substring(with: NSRange(location: lineStart, length: lineEnd - lineStart))
                                                              .countOfLeadingCharacters(in: .whitespacesAndNewlines)
                    let leadingWhitespaceToAdd = String(repeating: " ", count: leadingWhitespaceCountToAdd)

                    let bodySubstring = nsString.substring(with: range)
                    if bodySubstring.contains("@name") {
                        return "" // appledoc directive, return empty string
                    }
                    return leadingWhitespaceToAdd + bodySubstring
                }
            }
            if !bodyParts.isEmpty {
                return bodyParts.joined(separator: "\n").bridge()
                    .trimmingTrailingCharacters(in: .whitespacesAndNewlines)
                    .removingCommonLeadingWhitespaceFromLines()
            }
        }
        return nil
    }

    /// Returns a copy of `self` with the leading whitespace common in each line removed.
    public func removingCommonLeadingWhitespaceFromLines() -> String {
        var minLeadingCharacters = Int.max

        let lineComponents = components(separatedBy: newlinesCharacterSet)

        for line in lineComponents {
            let lineLeadingWhitespace = line.countOfLeadingCharacters(in: .whitespacesAndNewlines)
            let lineLeadingCharacters = line.countOfLeadingCharacters(in: commentLinePrefixCharacterSet)
            // Is this prefix smaller than our last and not entirely whitespace?
            if lineLeadingCharacters < minLeadingCharacters && lineLeadingWhitespace != line.count {
                minLeadingCharacters = lineLeadingCharacters
            }
        }

        return lineComponents.map { line in
            if line.count >= minLeadingCharacters {
                return String(line[line.index(line.startIndex, offsetBy: minLeadingCharacters)...])
            }
            return line
        }.joined(separator: "\n")
    }

    /**
    Returns the number of contiguous characters at the start of `self` belonging to `characterSet`.

    - parameter characterSet: Character set to check for membership.
    */
    public func countOfLeadingCharacters(in characterSet: CharacterSet) -> Int {
        let characterSet = characterSet.bridge()
        var count = 0
        for char in utf16 {
            if !characterSet.characterIsMember(char) {
                break
            }
            count += 1
        }
        return count
    }

    /// Returns a copy of the string by trimming whitespace and the opening curly brace (`{`).
    internal func trimmingWhitespaceAndOpeningCurlyBrace() -> String? {
        var unwantedSet = CharacterSet.whitespacesAndNewlines
        unwantedSet.insert(charactersIn: "{")
        return trimmingCharacters(in: unwantedSet)
    }

    /// Returns the byte offset of the section of the string following the last dot ".", or 0 if no dots.
    internal func byteOffsetOfInnerTypeName() -> Int64 {
        guard let range = range(of: ".", options: .backwards),
            let utf8pos = index(after: range.lowerBound).samePosition(in: utf8) else {
            return 0
        }
        return Int64(utf8.distance(from: utf8.startIndex, to: utf8pos))
    }
}
