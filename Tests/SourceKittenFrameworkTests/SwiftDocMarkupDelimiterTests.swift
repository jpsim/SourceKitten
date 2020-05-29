//
//  SwiftDocMarkupDelimiterTests.swift
//  SourceKittenFrameworkTests
//
//  Created by Eneko Alonso on 5/28/20.
//  Copyright © 2020 SourceKitten. All rights reserved.
//

import SourceKittenFramework
import XCTest

let markupDelmitersXML = """
<Function file=\"/path/to/file.swift\" line=\"126\" column=\"17\">\
<Name>hello(name:)</Name>\
<USR>s:14SourceDocsDemo10FullMarkupV5hello4nameS2S_tKF</USR>\
<Declaration>public func hello(name: String) throws -&gt; String</Declaration>\
<CommentParts>\
<Abstract>\
<Para>Method to say hello to a person or thing</Para>\
</Abstract>\
<Parameters>\
<Parameter>\
<Name>name</Name>\
<Direction isExplicit=\"0\">in</Direction>\
<Discussion>\
<Para>Name of the person or thing to salute</Para>\
</Discussion>\
</Parameter>\
<Parameter>\
<Name>name</Name>\
<Direction isExplicit=\"0\">in</Direction>\
<Discussion>\
<Para>Name of the person or thing to salute</Para>\
</Discussion>\
</Parameter>\
</Parameters>\
<ResultDiscussion>\
<Para>\
<codeVoice>String</codeVoice> with salute (eg. “Hello, Kelly!”)</Para>\
</ResultDiscussion>\
<ThrowsDiscussion>\
<Para>\
<codeVoice>Error.noName</codeVoice> when name is empty</Para>\
</ThrowsDiscussion>\
<Discussion>\
<Para>This should be the discussion, where we can ellaborate what the method does, providing details and examples.</Para>\
<rawHTML>\
<![CDATA[<hr/>]]>\
</rawHTML>\
<rawHTML>\
<![CDATA[<h1>]]>\
</rawHTML>Heading 1<rawHTML>\
<![CDATA[</h1>]]>\
</rawHTML>\
<Para>Foo</Para>\
<rawHTML>\
<![CDATA[<h2>]]>\
</rawHTML>Heading 2<rawHTML>\
<![CDATA[</h2>]]>\
</rawHTML>\
<Para>Bar</Para>\
<rawHTML>\
<![CDATA[<h3>]]>\
</rawHTML>Heading 3<rawHTML>\
<![CDATA[</h3>]]>\
</rawHTML>\
<Para>Baz</Para>\
<CodeListing language=\"swift\">\
<zCodeLineNumbered>\
<![CDATA[print(\"This is some code\")]]>\
</zCodeLineNumbered>\
<zCodeLineNumbered>\
</zCodeLineNumbered>\
</CodeListing>\
<Para>This should be blockquoted text</Para>\
<CodeListing language=\"swift\">\
<zCodeLineNumbered>\
<![CDATA[dump(\"Code block with backquotes\")]]>\
</zCodeLineNumbered>\
<zCodeLineNumbered>\
</zCodeLineNumbered>\
</CodeListing>\
<Para>An ordered list of elements:</Para>\
<List-Number>\
<Item>\
<Para>Foo</Para>\
</Item>\
<Item>\
<Para>Bar</Para>\
</Item>\
<Item>\
<Para>Baz</Para>\
</Item>\
</List-Number>\
<Para>A bulleted list:</Para>\
<List-Bullet>\
<Item>\
<Para>Foo</Para>\
</Item>\
<Item>\
<Para>Bar</Para>\
</Item>\
<Item>\
<Para>Baz</Para>\
</Item>\
</List-Bullet>\
<Para>\
<emphasis>Italics</emphasis> and <emphasis>italics</emphasis> <bold>Bold</bold> and <bold>bold</bold>\
</Para>\
<Para>* This is not a bullet item</Para>\
<rawHTML>\
<![CDATA[<hr/>]]>\
</rawHTML>\
<Attention>\
<Para>Use the callout to highlight information for the user of the symbol.</Para>\
</Attention>\
<Author>\
<Para>Use the callout to display the author of the code for a symbol.</Para>\
</Author>\
<Authors>\
<Para> A</Para>\
<Para>List</Para>\
<Para>Of Authors</Para>\
</Authors>\
<Bug>\
<Para>Use the callout to display a bug for a symbol.</Para>\
</Bug>\
<Complexity>\
<Para>Use the callout to display the algorithmic complexity of a method or function.</Para>\
</Complexity>\
<Copyright>\
<Para>Use the callout to display copyright information for a symbol.</Para>\
</Copyright>\
<Date>\
<Para>May 28, 2020</Para>\
</Date>\
<Experiment>\
<Para>Here is some example code:</Para>\
<CodeListing language=\"swift\">\
<zCodeLineNumbered>\
<![CDATA[FullMarkup.hello(name: \"Foo\")]]>\
</zCodeLineNumbered>\
<zCodeLineNumbered>\
</zCodeLineNumbered>\
</CodeListing>\
</Experiment>\
<Important>\
<Para>Use the callout to highlight information that can have adverse effects on the tasks a user is trying to accomplish.</Para>\
</Important>\
<Invariant>\
<Para>Use the callout to display a condition that is guaranteed to be true during the execution of the documented symbol.</Para>\
</Invariant>\
<Note>\
<Para>This is a note, that I’m sure of</Para>\
</Note>\
<Postcondition>\
<Para>Use the callout to document conditions which have guaranteed values upon completion of the execution of the symbol.</Para>\
</Postcondition>\
<Precondition>\
<Para>Use the callout to document any conditions that are held for the documented symbol to work.</Para>\
</Precondition>\
<Remark>\
<Para>This is <emphasis>remarkable</emphasis>\
</Para>\
</Remark>\
<Requires>\
<Para>Non-empty name</Para>\
</Requires>\
<See>\
<Para>Use the callout to add references to other information.</Para>\
</See>\
<Since>\
<Para>Use the callout to add information about when the symbol became available. Some example of the types of information include dates, \
framework versions, and operating system versions.</Para>\
</Since>\
<TODO>\
<Para>Use the callout to add tasks required to complete or update the functionality of the symbol.</Para>\
</TODO>\
<Version>\
<Para>v1.2.3</Para>\
</Version>\
<Warning>\
<Para>So many delimiters</Para>\
</Warning>\
<List-Bullet>\
<Item>\
<Para>Foo: Custom unsuported delimiters, appear as bulleted list items</Para>\
</Item>\
</List-Bullet>\
<Para>This is more text after all the delimiters list. Still part of the main discussion.</Para>\
</Discussion>\
</CommentParts>\
</Function>
"""

class SwiftDocMarkupDelimiterTests: XCTestCase {

    func testAbstract() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Method to say hello to a person or thing"]]
        XCTAssertEqual(dictionary?.get(.docAbstract), expectation)
    }

    func testThrowsDiscussion() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "`Error.noName` when name is empty"]]
        XCTAssertEqual(dictionary?.get(.docThrowsDiscussion), expectation)
    }

    func testAttentionDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Use the callout to highlight information for the user of the symbol."]]
        XCTAssertEqual(dictionary?.get(.docAttention), expectation)
    }

    func testAuthorDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Use the callout to display the author of the code for a symbol."]]
        XCTAssertEqual(dictionary?.get(.docAuthor), expectation)
    }

    func testAuthorsDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [
            ["Para": " A"],
            ["Para": "List"],
            ["Para": "Of Authors"]
        ]
        XCTAssertEqual(dictionary?.get(.docAuthors), expectation)
    }

    func testBugDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Use the callout to display a bug for a symbol."]]
        XCTAssertEqual(dictionary?.get(.docBug), expectation)
    }

    func testComplexityDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Use the callout to display the algorithmic complexity of a method or function."]]
        XCTAssertEqual(dictionary?.get(.docComplexity), expectation)
    }

    func testCopyrightDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Use the callout to display copyright information for a symbol."]]
        XCTAssertEqual(dictionary?.get(.docCopyright), expectation)
    }

    func testDateDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "May 28, 2020"]]
        XCTAssertEqual(dictionary?.get(.docDate), expectation)
    }

    /// - toDo: Figure out a way to extract paragraphs and any other type of nested elements (lists, code blocks, etc)
    func testExperimentDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [
            ["Para": "Here is some example code:"],
            ["CodeListing": ""]
        ]
        XCTAssertEqual(dictionary?.get(.docExperiment), expectation)
    }

    func testImportantDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [
            ["Para": "Use the callout to highlight information that can have adverse effects on the tasks a user is trying to accomplish."]
        ]
        XCTAssertEqual(dictionary?.get(.docImportant), expectation)
    }

    func testInvariantDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [
            ["Para": "Use the callout to display a condition that is guaranteed to be true during the execution of the documented symbol."]
        ]
        XCTAssertEqual(dictionary?.get(.docInvariant), expectation)
    }

    func testNoteDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "This is a note, that I’m sure of"]]
        XCTAssertEqual(dictionary?.get(.docNote), expectation)
    }

    func testPostconditionDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Use the callout to document conditions which have guaranteed values upon completion of the execution of the symbol."]]
        XCTAssertEqual(dictionary?.get(.docPostcondition), expectation)
    }

    func testPreconditionDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Use the callout to document any conditions that are held for the documented symbol to work."]]
        XCTAssertEqual(dictionary?.get(.docPrecondition), expectation)
    }

    func testRemarkDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "This is _remarkable_"]]
        XCTAssertEqual(dictionary?.get(.docRemark), expectation)
    }

    func testRequiresDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Non-empty name"]]
        XCTAssertEqual(dictionary?.get(.docRequires), expectation)
    }

    func testSeeAlsoDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Use the callout to add references to other information."]]
        XCTAssertEqual(dictionary?.get(.docSeeAlso), expectation)
    }

    func testSinceDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": """
            Use the callout to add information about when the symbol became available. \
            Some example of the types of information include dates, \
            framework versions, and operating system versions.
            """]
        ]
        XCTAssertEqual(dictionary?.get(.docSince), expectation)
    }

    func testToDoDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "Use the callout to add tasks required to complete or update the functionality of the symbol."]]
        XCTAssertEqual(dictionary?.get(.docToDo), expectation)
    }

    func testVersionDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "v1.2.3"]]
        XCTAssertEqual(dictionary?.get(.docVersion), expectation)
    }

    func testWarningDelimiter() {
        let dictionary = parseFullXMLDocs(markupDelmitersXML)
        let expectation = [["Para": "So many delimiters"]]
        XCTAssertEqual(dictionary?.get(.docWarning), expectation)
    }
}

extension Dictionary where Key == String, Value == SourceKitRepresentable {
    func get(_ key: SwiftDocKey) -> [[String: String]]? {
        return self[key.rawValue] as? [[String: String]]
    }
}
