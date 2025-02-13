import Foundation

#if SWIFT_PACKAGE
import SourceKit
#endif

#if os(macOS)
import Darwin
#elseif os(Linux)
#if canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif
#elseif os(Windows)
import ucrt
#else
#error("Unsupported platform")
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
    */
    public init?(file: File, arguments: [String]) {
        do {
            self.init(
                file: file,
                dictionary: try Request.editorOpen(file: file).send(),
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
    public init(file: File, dictionary: [String: SourceKitRepresentable], cursorInfoRequest: SourceKitObject?) {
        self.file = file
        var dictionary = dictionary
        let syntaxMapData = dictionary.removeValue(forKey: SwiftDocKey.syntaxMap.rawValue) as! [SourceKitRepresentable]
        let syntaxMap = SyntaxMap(data: syntaxMapData)
        dictionary = file.process(dictionary: dictionary, cursorInfoRequest: cursorInfoRequest, syntaxMap: syntaxMap)
        if let cursorInfoRequest = cursorInfoRequest {
            let documentedTokenOffsets = file.stringView.documentedTokenOffsets(syntaxMap: syntaxMap)
            dictionary = file.furtherProcess(
                dictionary: dictionary,
                documentedTokenOffsets: documentedTokenOffsets,
                cursorInfoRequest: cursorInfoRequest,
                syntaxMap: syntaxMap
            )
        }
        docsDictionary = file.addDocComments(dictionary: dictionary, syntaxMap: syntaxMap)
    }
}

// MARK: CustomStringConvertible

extension SwiftDocs: CustomStringConvertible {
    /// A textual JSON representation of `SwiftDocs`.
    public var description: String {
        let source: String
        if let path = file.path {
            source = URL(fileURLWithPath: path).standardizedFileURL.withUnsafeFileSystemRepresentation {
                String(cString: $0!)
            }
        } else {
            source = "<No File>"
        }
        return toJSON(toNSDictionary([source: docsDictionary]))
    }
}
