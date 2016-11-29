//
//  Request.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-03.
//  Copyright (c) 2015 JP Simard. All rights reserved.
//

import Dispatch
import Foundation
#if SWIFT_PACKAGE
import SourceKit
#endif

@available(*, unavailable, message: "Use SourceKitVariant instead of SourceKitRepresentable")
typealias SourceKitRepresentable = Any

/// Lazily and singly computed Void constants to initialize SourceKit once per session.
private let initializeSourceKit: Void = {
    sourcekitd_initialize()
}()
private let initializeSourceKitFailable: Void = {
    initializeSourceKit
    sourcekitd_set_notification_handler() { response in
        if !sourcekitd_response_is_error(response!) {
            fflush(stdout)
            fputs("sourcekitten: connection to SourceKitService restored!\n", stderr)
            sourceKitWaitingRestoredSemaphore.signal()
        }
        sourcekitd_response_dispose(response!)
    }
}()

/// dispatch_semaphore_t used when waiting for sourcekitd to be restored.
private var sourceKitWaitingRestoredSemaphore = DispatchSemaphore(value: 0)

internal extension String {
    /**
     Returns Swift's native String from NSUTF8StringEncoding bytes and length

     `String(bytesNoCopy:length:encoding:)` creates `String` based on `NSString`.
     That is slower than Swift's native String on some scene.

     - parameter bytes: UnsafePointer<Int8>
     - parameter length: length of bytes

     - returns: String Swift's native String
     */
    init?(bytes: UnsafePointer<Int8>, length: Int) {
        let pointer = UnsafeMutablePointer<Int8>(mutating: bytes)
        // It seems SourceKitService returns string in other than NSUTF8StringEncoding.
        // We'll try another encodings if fail.
        for encoding in [String.Encoding.utf8, .nextstep, .ascii] {
            if let string = String(bytesNoCopy: pointer, length: length, encoding: encoding,
                                   freeWhenDone: false) {
                self = "\(string)"
                return
            }
        }
        return nil
    }
}

/// Represents a SourceKit request.
public enum Request {
    /// An `editor.open` request for the given File.
    case editorOpen(file: File)
    /// A `cursorinfo` request for an offset in the given file, using the `arguments` given.
    case cursorInfo(file: String, offset: Int, arguments: [String])
    /// A custom request by passing in the SourceKitObject directly.
    case customRequest(request: SourceKitObject)
    /// A `codecomplete` request by passing in the file name, contents, offset
    /// for which to generate code completion options and array of compiler arguments.
    case codeCompletionRequest(file: String, contents: String, offset: Int, arguments: [String])
    /// ObjC Swift Interface
    case interface(file: String, uuid: String)
    /// Find USR
    case findUSR(file: String, usr: String)
    /// Index
    case index(file: String, arguments: [String])
    /// Format
    case format(file: String, line: Int, useTabs: Bool, indentWidth: Int)
    /// ReplaceText
    case replaceText(file: String, offset: Int, length: Int, sourceText: String)
    /// A documentation request for the given source text.
    case docInfo(text: String, arguments: [String])
    /// A documentation request for the given module.
    case moduleInfo(module: String, arguments: [String])

    fileprivate var sourcekitObject: SourceKitObject {
        switch self {
        case .editorOpen(let file):
            if let path = file.path {
                return [
                    "key.request": UID.SourceRequest.editorOpen,
                    "key.name": path,
                    "key.sourcefile": path
                ]
            } else {
                return [
                    "key.request": UID.SourceRequest.editorOpen,
                    "key.name": String(file.contents.hash),
                    "key.sourcetext": file.contents
                ]
            }
        case .cursorInfo(let file, let offset, let arguments):
            return [
                "key.request": UID.SourceRequest.cursorinfo,
                "key.name": file,
                "key.sourcefile": file,
                "key.offset": offset,
                "key.compilerargs": arguments
            ]
        case .customRequest(let request):
            return request
        case .codeCompletionRequest(let file, let contents, let offset, let arguments):
            return [
                "key.request": UID.SourceRequest.codecomplete,
                "key.name": file,
                "key.sourcefile": file,
                "key.sourcetext": contents,
                "key.offset": offset,
                "key.compilerargs": arguments
            ]
        case .interface(let file, let uuid):
            let arguments = ["-x", "objective-c", file, "-isysroot", sdkPath()]
            return [
                "key.request": UID.SourceRequest.editorOpenInterfaceHeader,
                "key.name": uuid,
                "key.filepath": file,
                "key.compilerargs": arguments
            ]
        case .findUSR(let file, let usr):
            return [
                "key.request": UID.SourceRequest.editorFind_Usr,
                "key.usr": usr,
                "key.sourcefile": file
            ]
        case .index(let file, let arguments):
            return [
                "key.request": UID.SourceRequest.indexsource,
                "key.sourcefile": file,
                "key.compilerargs": arguments
            ]
        case .format(let file, let line, let useTabs, let indentWidth):
            return [
                "key.request": UID.SourceRequest.editorFormattext,
                "key.name": file,
                "key.line": line,
                "key.editor.format.options": [
                    "key.editor.format.indentwidth": indentWidth,
                    "key.editor.format.tabwidth": indentWidth,
                    "key.editor.format.usetabs": (useTabs ? 1 : 0),
                ]
            ]
        case .replaceText(let file, let offset, let length, let sourceText):
            return [
                "key.request": UID.SourceRequest.editorReplacetext,
                "key.name": file,
                "key.offset": offset,
                "key.length": length,
                "key.sourcetext": sourceText,
            ]
        case .docInfo(let text, let arguments):
            return [
                "key.request": UID.SourceRequest.docinfo,
                "key.name": NSUUID().uuidString,
                "key.compilerargs": arguments,
                "key.sourcetext": text,
            ]
        case .moduleInfo(let module, let arguments):
            return [
                "key.request": UID.SourceRequest.docinfo,
                "key.name": NSUUID().uuidString,
                "key.compilerargs": arguments,
                "key.modulename": module,
            ]
        }
    }

    /**
    Create a Request.CursorInfo.sourcekitObject() from a file path and compiler arguments.

    - parameter filePath:  Path of the file to create request.
    - parameter arguments: Compiler arguments.

    - returns: SourceKitObject representation of the Request, if successful.
    */
    internal static func cursorInfoRequest(filePath: String?, arguments: [String]) -> SourceKitObject? {
        if let path = filePath {
            return Request.cursorInfo(file: path, offset: 0, arguments: arguments).sourcekitObject
        }
        return nil
    }

    /**
    Send a Request.CursorInfo by updating its offset. Returns SourceKit response if successful.

    - parameter cursorInfoRequest: SourceKitObject representation of Request.CursorInfo
    - parameter offset:            Offset to update request.

    - returns: SourceKit response if successful.
    */
    internal static func send(cursorInfoRequest: SourceKitObject, atOffset offset: Int) -> SourceKitVariant? {
        if offset == 0 {
            return nil
        }
        cursorInfoRequest.updateValue(offset, forKey: .offset)
        return try? Request.customRequest(request: cursorInfoRequest).failableSend()
    }

    /**
    Sends the request to SourceKit and return the response as an [String: SourceKitRepresentable].

    - returns: SourceKit output as a dictionary.
    */
    @available(*, unavailable, message: "Use `failableSend()` instead of `send()`")
    public func send() -> [String: Any] {
        fatalError()
    }

    /// A enum representation of SOURCEKITD_ERROR_*
    public enum Error: Swift.Error, CustomStringConvertible {
        case connectionInterrupted(String?)
        case invalid(String?)
        case failed(String?)
        case cancelled(String?)
        case unknown(String?)

        /// A textual representation of `self`.
        public var description: String {
            return getDescription() ?? "no description"
        }

        private func getDescription() -> String? {
            switch self {
            case .connectionInterrupted(let string): return string
            case .invalid(let string): return string
            case .failed(let string): return string
            case .cancelled(let string): return string
            case .unknown(let string): return string
            }
        }

        fileprivate init(response: sourcekitd_response_t) {
            let description = String(validatingUTF8: sourcekitd_response_error_get_description(response)!)
            switch sourcekitd_response_error_get_kind(response) {
            case SOURCEKITD_ERROR_CONNECTION_INTERRUPTED: self = .connectionInterrupted(description)
            case SOURCEKITD_ERROR_REQUEST_INVALID: self = .invalid(description)
            case SOURCEKITD_ERROR_REQUEST_FAILED: self = .failed(description)
            case SOURCEKITD_ERROR_REQUEST_CANCELLED: self = .cancelled(description)
            default: self = .unknown(description)
            }
        }
    }

    /**
     Sends the request to SourceKit and return the response as an SourceKitVariant.

     - returns: SourceKit output as a SourceKitVariant.
     - throws: Request.Error on fail ()
     */
    public func failableSend() throws -> SourceKitVariant {
        initializeSourceKitFailable
        let response = sourcekitd_send_request_sync(sourcekitObject.object!)
        if sourcekitd_response_is_error(response!) {
            let error = Request.Error(response: response!)
            if case .connectionInterrupted = error {
                _ = sourceKitWaitingRestoredSemaphore.wait(timeout: DispatchTime.now() + 10)
            }
            sourcekitd_response_dispose(response!)
            throw error
        }
        return SourceKitVariant(variant: sourcekitd_response_get_value(response!), response: response!)
    }
}

// MARK: CustomStringConvertible

extension Request: CustomStringConvertible {
    /// A textual representation of `Request`.
    public var description: String { return sourcekitObject.description }
}

private func interfaceForModule(_ module: String, compilerArguments: [String]) throws -> SourceKitVariant {
    let sourceKitObject: SourceKitObject = [
        "key.request": UID.SourceRequest.editorOpenInterface,
        "key.name": NSUUID().uuidString,
        "key.compilerargs": compilerArguments,
        "key.modulename": "SourceKittenFramework.\(module)"
    ]
    return try Request.customRequest(request: sourceKitObject).failableSend()
}

internal func libraryWrapperForModule(_ module: String, loadPath: String, linuxPath: String?, spmModule: String, compilerArguments: [String]) throws -> String {
    let sourceKitVariant = try interfaceForModule(module, compilerArguments: compilerArguments)
    let substructure = sourceKitVariant.subStructure ?? []
    let source = sourceKitVariant.sourceText!
    let freeFunctions = substructure.filter({
        $0.kind == UID.SourceLangSwiftDecl.functionFree
    }).flatMap { function -> String? in
        let fullFunctionName = function.name!
        let name = fullFunctionName.substring(to: fullFunctionName.range(of: "(")!.lowerBound)
        let unsupportedFunctions = [
            "clang_executeOnThread",
            "sourcekitd_variant_dictionary_apply",
            "sourcekitd_variant_array_apply",
        ]
        guard !unsupportedFunctions.contains(name) else {
            return nil
        }

        var parameters = [String]()
        if let functionSubstructure = function.subStructure {
            for parameterStructure in functionSubstructure {
                parameters.append(parameterStructure.typeName!)
            }
        }
        var returnTypes = [String]()
        if let offset = function.offset, let length = function.length {
            let start = source.index(source.startIndex, offsetBy: Int(offset))
            let end = source.index(start, offsetBy: Int(length))
            let functionDeclaration = source.substring(with: start..<end)
            if let startOfReturnArrow = functionDeclaration.range(of: "->", options: .backwards)?.lowerBound {
                returnTypes.append(functionDeclaration.substring(from: functionDeclaration.index(startOfReturnArrow, offsetBy: 3)))
            }
        }

        return "internal let \(name): @convention(c) (\(parameters.map({ $0.replacingOccurrences(of: "!", with: "?") }).joined(separator: ", "))) -> (\(returnTypes.joined(separator: ", "))) = library.load(symbol: \"\(name)\")".replacingOccurrences(of: "SourceKittenFramework.", with: "")
    }
    let spmImport = "#if SWIFT_PACKAGE\nimport \(spmModule)\n#endif\n"
    let library: String
    if let linuxPath = linuxPath {
        library = "#if os(Linux)\n" +
            "private let path = \"\(linuxPath)\"\n" +
            "#else\n" +
            "private let path = \"\(loadPath)\"\n" +
            "#endif\n" +
            "private let library = toolchainLoader.load(path: path)\n"
    } else {
        library = "private let library = toolchainLoader.load(path: \"\(loadPath)\")\n"
    }
    let startPlatformCheck: String
    let endPlatformCheck: String
    if linuxPath == nil {
        startPlatformCheck = "#if !os(Linux)\n"
        endPlatformCheck = "\n#endif\n"
    } else {
        startPlatformCheck = ""
        endPlatformCheck = "\n"
    }
    return startPlatformCheck + spmImport + library + freeFunctions.joined(separator: "\n") + endPlatformCheck
}

// MARK: - migration support
extension Request {
    @available(*, unavailable, renamed: "editorOpen(file:)")
    public static func EditorOpen(_: File) -> Request { fatalError() }

    @available(*, unavailable, renamed: "cursorInfo(file:offset:arguments:)")
    public static func CursorInfo(file: String, offset: Int64, arguments: [String]) -> Request { fatalError() }

    @available(*, unavailable, renamed: "customRequest(request:)")
    public static func CustomRequest(_: SourceKitObject) -> Request { fatalError() }

    @available(*, unavailable, renamed: "codeCompletionRequest(file:contents:offset:arguments:)")
    public static func CodeCompletionRequest(file: String, contents: String, offset: Int64, arguments: [String]) -> Request { fatalError() }

    @available(*, unavailable, renamed: "interface(file:uuid:)")
    public static func Interface(file: String, uuid: String) -> Request { fatalError() }

    @available(*, unavailable, renamed: "findUSR(file:usr:)")
    public static func FindUSR(file: String, usr: String) -> Request { fatalError() }

    @available(*, unavailable, renamed: "index(file:arguments:)")
    public static func Index(file: String, arguments: [String]) -> Request { fatalError() }

    @available(*, unavailable, renamed: "format(file:line:useTabs:indentWith:)")
    public static func Format(file: String, line: Int64, useTabs: Bool, indentWidth: Int64) -> Request { fatalError() }

    @available(*, unavailable, renamed: "replaceText(file:offset:length:sourceText:)")
    public static func ReplaceText(file: String, offset: Int64, length: Int64, sourceText: String) -> Request { fatalError() }
}

extension Request.Error {
    @available(*, unavailable, renamed: "connectionInterrupted(_:)")
    public static func ConnectionInterrupted(_: String?) -> Request.Error { fatalError() }

    @available(*, unavailable, renamed: "invalid(_:)")
    public static func Invalid(_: String?) -> Request.Error { fatalError() }

    @available(*, unavailable, renamed: "failed(_:)")
    public static func Failed(_: String?) -> Request.Error { fatalError() }

    @available(*, unavailable, renamed: "cancelled(_:)")
    public static func Cancelled(_: String?) -> Request.Error { fatalError() }

    @available(*, unavailable, renamed: "unknown(_:)")
    public static func Unknown(_: String?) -> Request.Error { fatalError() }
}
