//
//  String+SourceKitten.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-05.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation

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

private let whitespaceAndNewlineCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()

private let commentLinePrefixCharacterSet: NSCharacterSet = {
  let characterSet = NSMutableCharacterSet.whitespaceAndNewlineCharacterSet()
  /**
   * For "wall of asterisk" comment blocks, such as this one.
   */
  characterSet.addCharactersInString("*")
  return characterSet
}()

private var keyCacheContainer = 0

extension NSString {
    /**
    CacheContainer caches:

    - UTF16-based NSRange
    - UTF8-based NSRange
    - Line
    */
    @objc private class CacheContainer: NSObject {
        let lines: [Line]
        let utf8View: String.UTF8View

        init(_ string: NSString) {
            // Make a copy of the string to avoid holding a circular reference, which would leak
            // memory.
            //
            // If the string is a `Swift.String`, strongly referencing that in `CacheContainer` does
            // not cause a circular reference, because casting `String` to `NSString` makes a new
            // `NSString` instance.
            //
            // If the string is a native `NSString` instance, a circular reference is created when
            // assigning `self.utf8View = (string as String).utf8`.
            //
            // A reference to `NSString` is held by every cast `String` along with their views and
            // indices.
            let string = string.mutableCopy() as! String
            utf8View = string.utf8

            var start = 0       // line start
            var end = 0         // line end
            var contentsEnd = 0 // line end without line delimiter
            var lineIndex = 1   // start by 1
            var byteOffsetStart = 0
            var utf8indexStart = string.utf8.startIndex
            var utf16indexStart = string.utf16.startIndex

            let nsstring = string as NSString
            var lines = [Line]()
            while start < nsstring.length {
                let range = NSRange(location: start, length: 0)
                nsstring.getLineStart(&start, end: &end, contentsEnd: &contentsEnd, forRange: range)
                
                // range
                let lineRange = NSRange(location: start, length: end - start)
                let contentsRange = NSRange(location: start, length: contentsEnd - start)
                
                // byteRange
                let utf16indexEnd = utf16indexStart.advancedBy(end - start)
                let utf8indexEnd = utf16indexEnd.samePositionIn(utf8View)!
                let byteLength = utf8indexStart.distanceTo(utf8indexEnd)
                let byteRange = NSRange(location: byteOffsetStart, length: byteLength)
                
                // line
                let line = Line(index: lineIndex,
                    content: nsstring.substringWithRange(contentsRange),
                    range: lineRange, byteRange: byteRange)
                
                lines.append(line)
                
                lineIndex += 1
                start = end
                utf16indexStart = utf16indexEnd
                utf8indexStart = utf8indexEnd
                byteOffsetStart += byteLength
            }
            self.lines = lines
        }
        
        /**
        Returns UTF16 offset from UTF8 offset.

        - parameter byteOffset: UTF8-based offset of string.

        - returns: UTF16 based offset of string.
        */
        func locationFromByteOffset(byteOffset: Int) -> Int {
            if lines.isEmpty {
                return 0
            }
            let index = lines.indexOf({ NSLocationInRange(byteOffset, $0.byteRange) })
            // byteOffset may be out of bounds when sourcekitd points end of string.
            guard let line = (index.map { lines[$0] } ?? lines.last) else {
                fatalError()
            }
            let diff = byteOffset - line.byteRange.location
            if diff == 0 {
                return line.range.location
            } else if line.byteRange.length == diff {
                return NSMaxRange(line.range)
            }
            let utf8View = line.content.utf8
            let endUTF16index = utf8View.startIndex.advancedBy(diff, limit: utf8View.endIndex)
                .samePositionIn(line.content.utf16)!
            let utf16Diff = line.content.utf16.startIndex.distanceTo(endUTF16index)
            return line.range.location + utf16Diff
        }

        /**
        Returns UTF8 offset from UTF16 offset.

        - parameter location: UTF16-based offset of string.

        - returns: UTF8 based offset of string.
        */
        func byteOffsetFromLocation(location: Int) -> Int {
            if lines.isEmpty {
                return 0
            }
            let index = lines.indexOf({ NSLocationInRange(location, $0.range) })
            // location may be out of bounds when NSRegularExpression points end of string.
            guard let line = (index.map { lines[$0] } ?? lines.last) else {
                fatalError()
            }
            let diff = location - line.range.location
            if diff == 0 {
                return line.byteRange.location
            } else if line.range.length == diff {
                return NSMaxRange(line.byteRange)
            }
            let utf16View = line.content.utf16
            let endUTF8index = utf16View.startIndex.advancedBy(diff, limit: utf16View.endIndex)
                .samePositionIn(line.content.utf8)!
            let byteDiff = line.content.utf8.startIndex.distanceTo(endUTF8index)
            return line.byteRange.location + byteDiff
        }

        func lineAndCharacterForCharacterOffset(offset: Int) -> (line: Int, character: Int)? {
            let index = lines.indexOf { NSLocationInRange(offset, $0.range) }
            return index.map {
                let line = lines[$0]
                return (line: line.index, character: offset - line.range.location + 1)
            }
        }
        
        func lineAndCharacterForByteOffset(offset: Int) -> (line: Int, character: Int)? {
            let index = lines.indexOf { NSLocationInRange(offset, $0.byteRange) }
            return index.map {
                let line = lines[$0]
                
                let character: Int
                let content = line.content
                let length = offset - line.byteRange.location + 1
                if length == line.byteRange.length {
                    character = content.utf16.count
                } else {
                    let utf8View = content.utf8
                    let endIndex = utf8View.startIndex.advancedBy(length, limit: utf8View.endIndex)
                        .samePositionIn(content.utf16) ?? content.utf16.endIndex
                    character = content.utf16.startIndex.distanceTo(endIndex)
                }
                return (line: line.index, character: character)
            }
        }
    }

    /**
    CacheContainer instance is stored to instance of NSString as associated object.
    */
    private var cacheContainer: CacheContainer {
        if let cache = objc_getAssociatedObject(self, &keyCacheContainer) as? CacheContainer {
            return cache
        }
        let cache = CacheContainer(self)
        objc_setAssociatedObject(self, &keyCacheContainer, cache, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return cache
    }

    /**
    Returns line number and character for utf16 based offset.

    - parameter offset: utf16 based index.
    */
    public func lineAndCharacterForCharacterOffset(offset: Int) -> (line: Int, character: Int)? {
        return cacheContainer.lineAndCharacterForCharacterOffset(offset)
    }

    /**
    Returns line number and character for byte offset.

    - parameter offset: byte offset.
    */
    public func lineAndCharacterForByteOffset(offset: Int) -> (line: Int, character: Int)? {
        return cacheContainer.lineAndCharacterForByteOffset(offset)
    }

    /**
    Returns a copy of `self` with the trailing contiguous characters belonging to `characterSet`
    removed.

    - parameter characterSet: Character set to check for membership.
    */
    public func stringByTrimmingTrailingCharactersInSet(characterSet: NSCharacterSet) -> String {
        if length == 0 {
            return self as String
        }
        var charBuffer = [unichar](count: length, repeatedValue: 0)
        getCharacters(&charBuffer)
        for newLength in (1...length).reverse() {
            if !characterSet.characterIsMember(charBuffer[newLength - 1]) {
                return substringWithRange(NSRange(location: 0, length: newLength))
            }
        }
        return ""
    }

    /**
    Returns self represented as an absolute path.

    - parameter rootDirectory: Absolute parent path if not already an absolute path.
    */
    public func absolutePathRepresentation(rootDirectory: String = NSFileManager.defaultManager().currentDirectoryPath) -> String {
        if absolutePath {
            return self as String
        }
        return (NSString.pathWithComponents([rootDirectory, self as String]) as NSString).stringByStandardizingPath
    }

    /**
    Converts a range of byte offsets in `self` to an `NSRange` suitable for filtering `self` as an
    `NSString`.

    - parameter start: Starting byte offset.
    - parameter length: Length of bytes to include in range.

    - returns: An equivalent `NSRange`.
    */
    public func byteRangeToNSRange(start start: Int, length: Int) -> NSRange? {
        if self.length == 0 { return nil }
        let utf16Start = cacheContainer.locationFromByteOffset(start)
        if length == 0 {
            return NSRange(location: utf16Start, length: 0)
        }
        let utf16End = cacheContainer.locationFromByteOffset(start + length)
        return NSRange(location: utf16Start, length: utf16End - utf16Start)
    }

    /**
    Converts an `NSRange` suitable for filtering `self` as an
    `NSString` to a range of byte offsets in `self`.

    - parameter start: Starting character index in the string.
    - parameter length: Number of characters to include in range.

    - returns: An equivalent `NSRange`.
    */
    public func NSRangeToByteRange(start start: Int, length: Int) -> NSRange? {
        let string = self as String

        let utf16View = string.utf16
        let startUTF16Index = utf16View.startIndex.advancedBy(start)
        let endUTF16Index = startUTF16Index.advancedBy(length)

        let utf8View = string.utf8
        guard let startUTF8Index = startUTF16Index.samePositionIn(utf8View),
            let endUTF8Index = endUTF16Index.samePositionIn(utf8View) else {
                return nil
        }

        // Don't using `CacheContainer` if string is short.
        // There are two reasons for:
        // 1. Avoid using associatedObject on NSTaggedPointerString (< 7 bytes) because that does
        //    not free associatedObject.
        // 2. Using cache is overkill for short string.
        let byteOffset: Int
        if utf16View.count > 50 {
            byteOffset = cacheContainer.byteOffsetFromLocation(start)
        } else {
            byteOffset = utf8View.startIndex.distanceTo(startUTF8Index)
        }

        // `cacheContainer` will hit for below, but that will be calculated from startUTF8Index
        // in most case.
        let length = startUTF8Index.distanceTo(endUTF8Index)
        return NSRange(location: byteOffset, length: length)
    }

    /**
    Returns a substring with the provided byte range.

    - parameter start: Starting byte offset.
    - parameter length: Length of bytes to include in range.
    */
    public func substringWithByteRange(start start: Int, length: Int) -> String? {
        return byteRangeToNSRange(start: start, length: length).map(substringWithRange)
    }

    /**
    Returns a substring starting at the beginning of `start`'s line and ending at the end of `end`'s
    line. Returns `start`'s entire line if `end` is nil.

    - parameter start: Starting byte offset.
    - parameter length: Length of bytes to include in range.
    */
    public func substringLinesWithByteRange(start start: Int, length: Int) -> String? {
        return byteRangeToNSRange(start: start, length: length).map { range in
            var lineStart = 0, lineEnd = 0
            getLineStart(&lineStart, end: &lineEnd, contentsEnd: nil, forRange: range)
            return substringWithRange(NSRange(location: lineStart, length: lineEnd - lineStart))
        }
    }

    /**
    Returns line numbers containing starting and ending byte offsets.

    - parameter start: Starting byte offset.
    - parameter length: Length of bytes to include in range.
    */
    public func lineRangeWithByteRange(start start: Int, length: Int) -> (start: Int, end: Int)? {
        return byteRangeToNSRange(start: start, length: length).flatMap { range in
            var numberOfLines = 0, index = 0, lineRangeStart = 0
            while index < self.length {
                numberOfLines += 1
                if index <= range.location {
                    lineRangeStart = numberOfLines
                }
                index = NSMaxRange(lineRangeForRange(NSRange(location: index, length: 1)))
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
        return cacheContainer.lines
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

    /**
    Returns a substring from a start and end SourceLocation.
    */
    public func substringWithSourceRange(start: SourceLocation, end: SourceLocation) -> String? {
        return substringWithByteRange(start: Int(start.offset), length: Int(end.offset - start.offset))
    }
}

extension String {
    /// Returns the `#pragma mark`s in the string.
    /// Just the content; no leading dashes or leading `#pragma mark`.
    public func pragmaMarks(filename: String, excludeRanges: [NSRange], limitRange: NSRange?) -> [SourceDeclaration] {
        let regex = try! NSRegularExpression(pattern: "(#pragma\\smark|@name)[ -]*([^\\n]+)", options: []) // Safe to force try
        let range: NSRange
        if let limitRange = limitRange {
            range = NSRange(location: limitRange.location, length: min(utf16.count - limitRange.location, limitRange.length))
        } else {
            range = NSRange(location: 0, length: utf16.count)
        }
        let matches = regex.matchesInString(self, options: [], range: range)

        return matches.flatMap { match in
            let markRange = match.rangeAtIndex(2)
            for excludedRange in excludeRanges {
                if NSIntersectionRange(excludedRange, markRange).length > 0 {
                    return nil
                }
            }
            let markString = (self as NSString).substringWithRange(markRange)
                .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if markString.isEmpty {
                return nil
            }
            guard let markByteRange = self.NSRangeToByteRange(start: markRange.location, length: markRange.length) else {
                return nil
            }
            let location = SourceLocation(file: filename,
                line: UInt32((self as NSString).lineRangeWithByteRange(start: markByteRange.location, length: 0)!.start),
                column: 1, offset: UInt32(markByteRange.location))
            return SourceDeclaration(type: .Mark, location: location, extent: (location, location), name: markString,
                usr: nil, declaration: nil, documentation: nil, commentBody: nil, children: [])
        }
    }

    /**
    Returns whether or not the `token` can be documented. Either because it is a
    `SyntaxKind.Identifier` or because it is a function treated as a `SyntaxKind.Keyword`:

    - `subscript`
    - `init`
    - `deinit`

    - parameter token: Token to process.
    */
    public func isTokenDocumentable(token: SyntaxToken) -> Bool {
        if token.type == SyntaxKind.Keyword.rawValue {
            let keywordFunctions = ["subscript", "init", "deinit"]
            return ((self as NSString).substringWithByteRange(start: token.offset, length: token.length))
                .map(keywordFunctions.contains) ?? false
        }
        return token.type == SyntaxKind.Identifier.rawValue
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
        let matches = regex.matchesInString(self, options: [], range: range)

        return matches.flatMap { match in
            documentableOffsets.filter({ $0 >= match.range.location }).first
        }
    }

    /**
    Returns the body of the comment if the string is a comment.

    - parameter range: Range to restrict the search for a comment body.
    */
    public func commentBody(range: NSRange? = nil) -> String? {
        let nsString = self as NSString
        let patterns: [(pattern: String, options: NSRegularExpressionOptions)] = [
            ("^\\s*\\/\\*\\*\\s*(.*?)\\*\\/", [.AnchorsMatchLines, .DotMatchesLineSeparators]), // multi: ^\s*\/\*\*\s*(.*?)\*\/
            ("^\\s*\\/\\/\\/(.+)?",           .AnchorsMatchLines)                               // single: ^\s*\/\/\/(.+)?
        ]
        let range = range ?? NSRange(location: 0, length: nsString.length)
        for pattern in patterns {
            let regex = try! NSRegularExpression(pattern: pattern.pattern, options: pattern.options) // Safe to force try
            let matches = regex.matchesInString(self, options: [], range: range)
            let bodyParts = matches.flatMap { match -> [String] in
                let numberOfRanges = match.numberOfRanges
                if numberOfRanges < 1 {
                    return []
                }
                return (1..<numberOfRanges).map { rangeIndex in
                    let range = match.rangeAtIndex(rangeIndex)
                    if range.location == NSNotFound {
                        return "" // empty capture group, return empty string
                    }
                    var lineStart = 0
                    var lineEnd = nsString.length
                    let indexRange = NSRange(location: range.location, length: 0)
                    nsString.getLineStart(&lineStart, end: &lineEnd, contentsEnd: nil, forRange: indexRange)
                    let leadingWhitespaceCountToAdd = nsString.substringWithRange(NSRange(location: lineStart, length: lineEnd - lineStart)).countOfLeadingCharactersInSet(whitespaceAndNewlineCharacterSet)
                    let leadingWhitespaceToAdd = String(count: leadingWhitespaceCountToAdd, repeatedValue: Character(" "))

                    let bodySubstring = nsString.substringWithRange(range)
                    if bodySubstring.containsString("@name") {
                        return "" // appledoc directive, return empty string
                    }
                    return leadingWhitespaceToAdd + bodySubstring
                }
            }
            if bodyParts.count > 0 {
                return bodyParts
                    .joinWithSeparator("\n")
                    .stringByTrimmingTrailingCharactersInSet(whitespaceAndNewlineCharacterSet)
                    .stringByRemovingCommonLeadingWhitespaceFromLines()
            }
        }
        return nil
    }

    /// Returns a copy of `self` with the leading whitespace common in each line removed.
    public func stringByRemovingCommonLeadingWhitespaceFromLines() -> String {
        var minLeadingCharacters = Int.max

        enumerateLines { line, _ in
            let lineLeadingWhitespace = line.countOfLeadingCharactersInSet(whitespaceAndNewlineCharacterSet)
            let lineLeadingCharacters = line.countOfLeadingCharactersInSet(commentLinePrefixCharacterSet)
            // Is this prefix smaller than our last and not entirely whitespace?
            if lineLeadingCharacters < minLeadingCharacters && lineLeadingWhitespace != line.characters.count {
                minLeadingCharacters = lineLeadingCharacters
            }
        }
        var lines = [String]()
        enumerateLines { line, _ in
            if line.characters.count >= minLeadingCharacters {
                lines.append(line[line.startIndex.advancedBy(minLeadingCharacters)..<line.endIndex])
            } else {
                lines.append(line)
            }
        }
        return lines.joinWithSeparator("\n")
    }

    /**
    Returns the number of contiguous characters at the start of `self` belonging to `characterSet`.

    - parameter characterSet: Character set to check for membership.
    */
    public func countOfLeadingCharactersInSet(characterSet: NSCharacterSet) -> Int {
        let utf16View = utf16
        var count = 0
        for char in utf16View {
            if !characterSet.characterIsMember(char) {
                break
            }
            count += 1
        }
        return count
    }

    /// Returns a copy of the string by trimming whitespace and the opening curly brace (`{`).
    internal func stringByTrimmingWhitespaceAndOpeningCurlyBrace() -> String? {
        let unwantedSet = whitespaceAndNewlineCharacterSet.mutableCopy() as! NSMutableCharacterSet
        unwantedSet.addCharactersInString("{")
        return stringByTrimmingCharactersInSet(unwantedSet)
    }
}
