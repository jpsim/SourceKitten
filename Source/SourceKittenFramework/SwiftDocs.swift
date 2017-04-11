//
//  SwiftDocs.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Foundation
#if SWIFT_PACKAGE
import SourceKit
#endif

/// Represents docs for a Swift file.
public struct SwiftDocs {
    /// Documented File.
    public let file: File

    /// Docs information as an [String: SourceKitRepresentable].
    public let docsDictionary: [String: SourceKitRepresentable]

    /**
    Create docs for the specified Swift file and compiler arguments.

    - parameter file:      Swift file to document.
    - parameter arguments: compiler arguments to pass to SourceKit.
    - parameter processExpressions: Whether expressions should be processed or not. false by default

    */
    public init?(file: File, arguments: [String], processExpressions: Bool = false) {
        do {
            self.init(
                file: file,
                dictionary: try Request.editorOpen(file: file).failableSend(),
                cursorInfoRequest: Request.cursorInfoRequest(filePath: file.path, arguments: arguments),
                processExpressions: processExpressions
            )
        } catch let error as Request.Error {
            fputs(error.description, stderr)
            return nil
        } catch {
            return nil
        }
    }

    /**
    Create docs for the specified Swift file, editor.open SourceKit response and cursor info request.

    - parameter file:               Swift file to document.
    - parameter dictionary:         editor.open response from SourceKit.
    - parameter cursorInfoRequest:  SourceKit dictionary to use to send cursorinfo request.
    - parameter processExpressions: Whether expressions should be processed or not. false by default

    */
    public init(file: File, dictionary: [String: SourceKitRepresentable], cursorInfoRequest: sourcekitd_object_t?,
                processExpressions: Bool = false) {
        self.file = file
        var dictionary = dictionary
        let syntaxMapData = dictionary.removeValue(forKey: SwiftDocKey.syntaxMap.rawValue) as! [SourceKitRepresentable]
        let syntaxMap = SyntaxMap(data: syntaxMapData)
        let elementTypesToProcess: File.ProcessableElements = processExpressions ? .all : .declarationsAndComments
        dictionary = file.process(
            dictionary: dictionary,
            cursorInfoRequest: cursorInfoRequest,
            syntaxMap: syntaxMap,
            elementTypes: elementTypesToProcess
        )
        if let cursorInfoRequest = cursorInfoRequest {
            let documentedTokenOffsets = file.contents.documentedTokenOffsets(syntaxMap: syntaxMap)
            dictionary = file.furtherProcess(
                dictionary: dictionary,
                documentedTokenOffsets: documentedTokenOffsets,
                cursorInfoRequest: cursorInfoRequest,
                syntaxMap: syntaxMap,
                elementTypes: elementTypesToProcess
            )
        }
        docsDictionary = dictionary
    }
}

// MARK: CustomStringConvertible

extension SwiftDocs: CustomStringConvertible {
    /// A textual JSON representation of `SwiftDocs`.
    public var description: String {
        return toJSON(toNSDictionary([file.path ?? "<No File>": docsDictionary]))
    }
}
