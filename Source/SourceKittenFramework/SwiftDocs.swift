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

    /// Docs information as an [String: Any].
    public let docsDictionary: [String: Any]

    /**
    Create docs for the specified Swift file and compiler arguments.

    - parameter file:      Swift file to document.
    - parameter arguments: compiler arguments to pass to SourceKit.
    */
    public init?(file: File, arguments: [String]) {
        do {
            self.init(
                file: file,
                sourceKitVariant: try Request.editorOpen(file: file).failableSend(),
                cursorInfoRequest: Request.cursorInfoRequest(filePath: file.path, arguments: arguments)
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

    - parameter file:              Swift file to document.
    - parameter dictionary:        editor.open response from SourceKit.
    - parameter cursorInfoRequest: SourceKit dictionary to use to send cursorinfo request.
    */
    @available(*, unavailable, message: "Use SwiftDocs.init(file:sourceKitVariant:cursorInfoRequest:)")
    public init(file: File, dictionary: [String: Any], cursorInfoRequest: SourceKitObject?) {
        fatalError()
    }

    init(file: File, sourceKitVariant: SourceKitVariant, cursorInfoRequest: SourceKitObject?) {
        self.file = file
        var sourceKitVariant = sourceKitVariant
        let syntaxMap = SyntaxMap(sourceKitVariant: sourceKitVariant)
        sourceKitVariant = file.process(dictionary: sourceKitVariant, cursorInfoRequest: cursorInfoRequest, syntaxMap: syntaxMap)
        if let cursorInfoRequest = cursorInfoRequest {
            let documentedTokenOffsets = file.contents.documentedTokenOffsets(syntaxMap: syntaxMap)
            sourceKitVariant = file.furtherProcess(
                dictionary: sourceKitVariant,
                documentedTokenOffsets: documentedTokenOffsets,
                cursorInfoRequest: cursorInfoRequest,
                syntaxMap: syntaxMap
            )
        }
        var dictionary = sourceKitVariant.any as! [String:Any]
        _ = dictionary.removeValue(forKey: UID.Key.syntaxmap.description)
        docsDictionary = dictionary
    }
}

// MARK: CustomStringConvertible

extension SwiftDocs: CustomStringConvertible {
    /// A textual JSON representation of `SwiftDocs`.
    public var description: String {
        return toJSON([file.path ?? "<No File>": docsDictionary])
    }
}
