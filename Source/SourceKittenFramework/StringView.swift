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

// swiftlint:disable:next line_length
// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html#//apple_ref/swift/grammar/line-break
private let newlinesCharacterSet = CharacterSet(charactersIn: "\u{000A}\u{000D}")

/// Strucutre that precalculates lines for the specified string and then uses this information for
/// ByteRange to NSRange and NSRange to ByteRange operations
public struct StringView {


    /// Reference to the NSString of represented string
    public let nsString: NSString

    /// Full range of nsString
    public let range: NSRange

    /// Reference to the String of the represented strin
    public let string: String

    /// All lines of the original string
    public let lines: [Line]

    let utf8View: String.UTF8View
    let utf16View: String.UTF16View

    public init(_ string: String) {
        self.init(string, string as NSString)
    }

    public init(_ nsstring: NSString) {
        self.init(nsstring as String, nsstring)
    }

    private init(_ string: String, _ nsString: NSString) {
        self.string = string
        self.nsString = nsString
        self.range = NSRange(location: 0, length: nsString.length)

        utf8View = string.utf8
        utf16View = string.utf16

        var utf16CountSoFar = 0
        var bytesSoFar = 0
        var lines = [Line]()
        let lineContents = string.components(separatedBy: newlinesCharacterSet)
        // Be compatible with `NSString.getLineStart(_:end:contentsEnd:forRange:)`
        let endsWithNewLineCharacter: Bool
        if let lastChar = utf16View.last,
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
        self.lines = lines
    }

    /// Returns substring in with UTF-16 range specified
    /// - Parameter range: UTF16 Range
    public func substring(with range: NSRange) -> String {
        return nsString.substring(with: range)
    }

    #if !os(Linux)
    /**
     Returns a substring from a start and end SourceLocation.
     */
    public func substringWithSourceRange(start: SourceLocation, end: SourceLocation) -> String? {
        return substringWithByteRange(start: Int(start.offset), length: Int(end.offset - start.offset))
    }
    #endif

    /**
     Returns a substring with the provided byte range.

     - parameter start: Starting byte offset.
     - parameter length: Length of bytes to include in range.
     */
    public func substringWithByteRange(start: Int, length: Int) -> String? {
        return byteRangeToNSRange(start: start, length: length).map(nsString.substring)
    }


    /// Returns a substictg, started at UTF-16 location
    /// - Parameter location: UTF-16 location
    func substring(from location: Int) -> String {
        return nsString.substring(from: location)
    }

    /**
     Converts a range of byte offsets in `self` to an `NSRange` suitable for filtering `self` as an
     `NSString`.

     - parameter start: Starting byte offset.
     - parameter length: Length of bytes to include in range.

     - returns: An equivalent `NSRange`.
     */
    public func byteRangeToNSRange(start: Int, length: Int) -> NSRange? {
        guard !string.isEmpty else { return nil }
        let utf16Start = location(fromByteOffset: start)
        if length == 0 {
            return NSRange(location: utf16Start, length: 0)
        }
        let utf16End = location(fromByteOffset: start + length)
        return NSRange(location: utf16Start, length: utf16End - utf16Start)
    }

    /**
     Returns UTF8 offset from UTF16 offset.

     - parameter location: UTF16-based offset of string.

     - returns: UTF8 based offset of string.
     */
    public func byteOffset(fromLocation location: Int) -> Int {
        if lines.isEmpty {
            return 0
        }
        let index = lines.indexAssumingSorted { line in
            if location < line.range.location {
                return .orderedAscending
            } else if location >= line.range.location + line.range.length {
                return .orderedDescending
            }
            return .orderedSame
        }
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
        let endUTF8index = utf16View.index(utf16View.startIndex, offsetBy: diff, limitedBy: utf16View.endIndex)!
            .samePosition(in: line.content.utf8)!
        let byteDiff = line.content.utf8.distance(from: line.content.utf8.startIndex, to: endUTF8index)
        return line.byteRange.location + byteDiff
    }

    /**
    Converts an `NSRange` suitable for filtering `self` as an
    `NSString` to a range of byte offsets in `self`.

    - parameter start: Starting character index in the string.
    - parameter length: Number of characters to include in range.

    - returns: An equivalent `NSRange`.
    */
    public func NSRangeToByteRange(start: Int, length: Int) -> NSRange? {
        let startUTF16Index = utf16View.index(utf16View.startIndex, offsetBy: start)
        let endUTF16Index = utf16View.index(startUTF16Index, offsetBy: length)

        guard let startUTF8Index = startUTF16Index.samePosition(in: utf8View),
            let endUTF8Index = endUTF16Index.samePosition(in: utf8View) else {
                return nil
        }

        // TODO: Use cache?
        // Don't using `CacheContainer` if string is short.
        // There are reason for it:
        // 1. Using cache is overkill for short string.
        let byteOffset: Int
        if utf16View.count > 50 {
            byteOffset = self.byteOffset(fromLocation: start)
        } else {
            byteOffset = utf8View.distance(from: utf8View.startIndex, to: startUTF8Index)
        }

        // `cacheContainer` will hit for below, but that will be calculated from startUTF8Index
        // in most case.
        let length = utf8View.distance(from: startUTF8Index, to: endUTF8Index)
        return NSRange(location: byteOffset, length: length)
    }

    public func NSRangeToByteRange(_ range: NSRange) -> NSRange? {
        return NSRangeToByteRange(start: range.location, length: range.length)
    }

    /**
     Returns UTF16 offset from UTF8 offset.

     - parameter byteOffset: UTF8-based offset of string.

     - returns: UTF16 based offset of string.
     */
    public func location(fromByteOffset byteOffset: Int) -> Int {
        if lines.isEmpty {
            return 0
        }
        let index = lines.indexAssumingSorted { line in
            if byteOffset < line.byteRange.location {
                return .orderedAscending
            } else if byteOffset >= line.byteRange.location + line.byteRange.length {
                return .orderedDescending
            }
            return .orderedSame
        }
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
        let endUTF8Index = utf8View.index(utf8View.startIndex, offsetBy: diff, limitedBy: utf8View.endIndex) ?? utf8View.endIndex
        let utf16Diff = line.content.utf16.distance(from: line.content.utf16.startIndex, to: endUTF8Index)
        return line.range.location + utf16Diff
    }

    public func substringStartingLinesWithByteRange(start: Int, length: Int) -> String? {
        return byteRangeToNSRange(start: start, length: length).map { range in
            var lineStart = 0, lineEnd = 0
            nsString.getLineStart(&lineStart, end: &lineEnd, contentsEnd: nil, for: range)
            return nsString.substring(with: NSRange(location: lineStart, length: NSMaxRange(range) - lineStart))
        }
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
            nsString.getLineStart(&lineStart, end: &lineEnd, contentsEnd: nil, for: range)
            return nsString.substring(with: NSRange(location: lineStart, length: lineEnd - lineStart))
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
            while index < nsString.length {
                numberOfLines += 1
                if index <= range.location {
                    lineRangeStart = numberOfLines
                }
                index = NSMaxRange(nsString.lineRange(for: NSRange(location: index, length: 1)))
                if index > NSMaxRange(range) {
                    return (lineRangeStart, numberOfLines)
                }
            }
            return nil
        }
    }

    public func lineAndCharacter(forByteOffset offset: Int, expandingTabsToWidth tabWidth: Int = 1) -> (line: Int, character: Int)? {
        let characterOffset = location(fromByteOffset: offset)
        return lineAndCharacter(forCharacterOffset: characterOffset, expandingTabsToWidth: tabWidth)
    }

    public func lineAndCharacter(forCharacterOffset offset: Int, expandingTabsToWidth tabWidth: Int = 1) -> (line: Int, character: Int)? {
        assert(tabWidth > 0)

        let index = lines.indexAssumingSorted { line in
            if offset < line.range.location {
                return .orderedAscending
            } else if offset >= line.range.location + line.range.length {
                return .orderedDescending
            }
            return .orderedSame
        }
        return index.map {
            let line = lines[$0]

            let prefixLength = offset - line.range.location
            let character: Int

            if tabWidth == 1 {
                character = prefixLength
            } else {
                character = line.content.prefix(prefixLength).reduce(0) { sum, character in
                    if character == "\t" {
                        return sum - (sum % tabWidth) + tabWidth
                    } else {
                        return sum + 1
                    }
                }
            }

            return (line: line.index, character: character + 1)
        }
    }

}

public extension StringView {

    /**
     Returns whether or not the `token` can be documented. Either because it is a
     `SyntaxKind.Identifier` or because it is a function treated as a `SyntaxKind.Keyword`:

     - `subscript`
     - `init`
     - `deinit`

     - parameter token: Token to process.
     */
    func isTokenDocumentable(token: SyntaxToken) -> Bool {
        if token.type == SyntaxKind.keyword.rawValue {
            let keywordFunctions = ["subscript", "init", "deinit"]
            return substringWithByteRange(start: token.offset, length: token.length)
                .map(keywordFunctions.contains) ?? false
        }
        return token.type == SyntaxKind.identifier.rawValue
    }

    #if !os(Linux)
    /// Returns the `#pragma mark`s in the string.
    /// Just the content; no leading dashes or leading `#pragma mark`.
    func pragmaMarks(filename: String, excludeRanges: [NSRange], limit: NSRange?) -> [SourceDeclaration] {
        let regex = try! NSRegularExpression(pattern: "(#pragma\\smark|@name)[ -]*([^\\n]+)", options: []) // Safe to force try
        let range: NSRange
        if let limit = limit {
            range = NSRange(location: limit.location, length: min(utf16View.count - limit.location, limit.length))
        } else {
            range = NSRange(location: 0, length: utf16View.count)
        }
        let matches = regex.matches(in: string, options: [], range: range)

        return matches.compactMap { match in
            let markRange = match.range(at: 2)
            for excludedRange in excludeRanges {
                if NSIntersectionRange(excludedRange, markRange).length > 0 {
                    return nil
                }
            }
            let markString = nsString.substring(with: markRange).trimmingCharacters(in: .whitespaces)
            if markString.isEmpty {
                return nil
            }
            guard let markByteRange = self.NSRangeToByteRange(start: markRange.location, length: markRange.length) else {
                return nil
            }
            let location = SourceLocation(file: filename,
                                          line: UInt32(lineRangeWithByteRange(start: markByteRange.location, length: 0)!.start),
                                          column: 1, offset: UInt32(markByteRange.location))
            return SourceDeclaration(type: .mark, location: location, extent: (location, location), name: markString,
                                     usr: nil, declaration: nil, documentation: nil, commentBody: nil, children: [],
                                     annotations: nil, swiftDeclaration: nil, swiftName: nil, availability: nil)
        }
    }
    #endif

    /**
     Find integer offsets of documented Swift tokens in self.

     - parameter syntaxMap: Syntax Map returned from SourceKit editor.open request.

     - returns: Array of documented token offsets.
     */
    func documentedTokenOffsets(syntaxMap: SyntaxMap) -> [Int] {
        let documentableOffsets = syntaxMap.tokens.filter(isTokenDocumentable).map {
            $0.offset
        }

        let regex = try! NSRegularExpression(pattern: "(///.*\\n|\\*/\\n)", options: []) // Safe to force try
        let range = NSRange(location: 0, length: string.utf16.count)
        let matches = regex.matches(in: string, options: [], range: range)

        return matches.compactMap { match in
            documentableOffsets.first { $0 >= match.range.location }
        }
    }
}


extension String {

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
