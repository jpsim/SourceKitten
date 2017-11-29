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

public protocol SourceKitRepresentable {
    func isEqualTo(_ rhs: SourceKitRepresentable) -> Bool
}
extension Array: SourceKitRepresentable {}
extension Dictionary: SourceKitRepresentable {}
extension String: SourceKitRepresentable {}
extension Int64: SourceKitRepresentable {}
extension Bool: SourceKitRepresentable {}

extension SourceKitRepresentable {
    public func isEqualTo(_ rhs: SourceKitRepresentable) -> Bool {
        switch self {
        case let lhs as [SourceKitRepresentable]:
            for (idx, value) in lhs.enumerated() {
                if let rhs = rhs as? [SourceKitRepresentable], rhs[idx].isEqualTo(value) {
                    continue
                }
                return false
            }
            return true
        case let lhs as [String: SourceKitRepresentable]:
            for (key, value) in lhs {
                if let rhs = rhs as? [String: SourceKitRepresentable],
                   let rhsValue = rhs[key], rhsValue.isEqualTo(value) {
                    continue
                }
                return false
            }
            return true
        case let lhs as String:
            return lhs == rhs as? String
        case let lhs as Int64:
            return lhs == rhs as? Int64
        case let lhs as Bool:
            return lhs == rhs as? Bool
        default:
            fatalError("Should never happen because we've checked all SourceKitRepresentable types")
        }
    }
}

private func fromSourceKit(_ sourcekitObject: sourcekitd_variant_t) -> SourceKitRepresentable? {
    switch sourcekitd_variant_get_type(sourcekitObject) {
    case SOURCEKITD_VARIANT_TYPE_ARRAY:
        var array = [SourceKitRepresentable]()
        _ = withUnsafeMutablePointer(to: &array) { arrayPtr in
            sourcekitd_variant_array_apply_f(sourcekitObject, { index, value, context in
                if let value = fromSourceKit(value), let context = context {
                    let localArray = context.assumingMemoryBound(to: [SourceKitRepresentable].self)
                    localArray.pointee.insert(value, at: Int(index))
                }
                return true
            }, arrayPtr)
        }
        return array
    case SOURCEKITD_VARIANT_TYPE_DICTIONARY:
        var dict = [String: SourceKitRepresentable]()
        _ = withUnsafeMutablePointer(to: &dict) { dictPtr in
            sourcekitd_variant_dictionary_apply_f(sourcekitObject, { key, value, context in
                if let key = String(sourceKitUID: key!), let value = fromSourceKit(value), let context = context {
                    let localDict = context.assumingMemoryBound(to: [String: SourceKitRepresentable].self)
                    localDict.pointee[key] = value
                }
                return true
            }, dictPtr)
        }
        return dict
    case SOURCEKITD_VARIANT_TYPE_STRING:
        return String(bytes: sourcekitd_variant_string_get_ptr(sourcekitObject)!,
                      length: sourcekitd_variant_string_get_length(sourcekitObject))
    case SOURCEKITD_VARIANT_TYPE_INT64:
        return sourcekitd_variant_int64_get_value(sourcekitObject)
    case SOURCEKITD_VARIANT_TYPE_BOOL:
        return sourcekitd_variant_bool_get_value(sourcekitObject)
    case SOURCEKITD_VARIANT_TYPE_UID:
        return String(sourceKitUID: sourcekitd_variant_uid_get_value(sourcekitObject)!)
    case SOURCEKITD_VARIANT_TYPE_NULL:
        return nil
    default:
        fatalError("Should never happen because we've checked all SourceKitRepresentable types")
    }
}

/// Lazily and singly computed Void constants to initialize SourceKit once per session.
private let initializeSourceKit: Void = {
    sourcekitd_initialize()
}()
private let initializeSourceKitFailable: Void = {
    initializeSourceKit
    sourcekitd_set_notification_handler { response in
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

private extension String {
    /**
    Cache SourceKit requests for strings from UIDs

    - returns: Cached UID string if available, nil otherwise.
    */
    init?(sourceKitUID: sourcekitd_uid_t) {
        let length = sourcekitd_uid_get_length(sourceKitUID)
        let bytes = sourcekitd_uid_get_string_ptr(sourceKitUID)
        if let uidString = String(bytes: bytes!, length: length) {
            /*
            `String` created by `String(UTF8String:)` is based on `NSString`.
            `NSString` base `String` has performance penalty on getting `hashValue`.
            Everytime on getting `hashValue`, it calls `decomposedStringWithCanonicalMapping` for
            "Unicode Normalization Form D" and creates autoreleased `CFString (mutable)` and
            `CFString (store)`. Those `CFString` are created every time on using `hashValue`, such as
            using `String` for Dictionary's key or adding to Set.

            For avoiding those penalty, replaces with enum's rawValue String if defined in SourceKitten.
            That does not cause calling `decomposedStringWithCanonicalMapping`.
            */

            self = String(uidString: uidString)
            return
        }
        return nil
    }

    /**
     Assigns SourceKitten defined enum's rawValue String from string.
     rawValue String if defined in SourceKitten, nil otherwise.

     - parameter uidString: String created from sourcekitd_uid_get_string_ptr().
     */
    init(uidString: String) {
        if let rawValue = SwiftDocKey(rawValue: uidString)?.rawValue {
            self = rawValue
        } else if let rawValue = SwiftDeclarationKind(rawValue: uidString)?.rawValue {
            self = rawValue
        } else if let rawValue = SyntaxKind(rawValue: uidString)?.rawValue {
            self = rawValue
        } else {
            self = "\(uidString)"
        }
    }

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

public protocol RequestType {
    func sourcekitObject() -> sourcekitd_object_t
}

/// Represents a SourceKit request.
public struct Request {

    public let type: RequestType

    fileprivate var sourcekitObject: sourcekitd_object_t {
        return type.sourcekitObject()
    }

    /**
    Sends the request to SourceKit and return the response as an [String: SourceKitRepresentable].

    - returns: SourceKit output as a dictionary.
    */
    public func send() -> [String: SourceKitRepresentable] {
        initializeSourceKit
        let response = sourcekitd_send_request_sync(sourcekitObject)
        defer { sourcekitd_response_dispose(response!) }
        return fromSourceKit(sourcekitd_response_get_value(response!)) as! [String: SourceKitRepresentable]
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
    Sends the request to SourceKit and return the response as an [String: SourceKitRepresentable].

    - returns: SourceKit output as a dictionary.
    - throws: Request.Error on fail ()
    */
    public func failableSend() throws -> [String: SourceKitRepresentable] {
        initializeSourceKitFailable
        let response = sourcekitd_send_request_sync(sourcekitObject)
        defer { sourcekitd_response_dispose(response!) }
        if sourcekitd_response_is_error(response!) {
            let error = Request.Error(response: response!)
            if case .connectionInterrupted = error {
                _ = sourceKitWaitingRestoredSemaphore.wait(timeout: DispatchTime.now() + 10)
            }
            throw error
        }
        return fromSourceKit(sourcekitd_response_get_value(response!)) as! [String: SourceKitRepresentable]
    }
}

// MARK: - CustomStringConvertible

extension Request: CustomStringConvertible {
    /// A textual representation of `Request`.
    public var description: String { return String(validatingUTF8: sourcekitd_request_description_copy(sourcekitObject)!)! }
}

private func interfaceForModule(_ module: String, compilerArguments: [String]) -> [String: SourceKitRepresentable] {
    var compilerargs = compilerArguments.map { sourcekitd_request_string_create($0) }
    let dict = [
        sourcekitd_uid_get_from_cstr("key.request")!: sourcekitd_request_uid_create(sourcekitd_uid_get_from_cstr("source.request.editor.open.interface")!),
        sourcekitd_uid_get_from_cstr("key.name")!: sourcekitd_request_string_create(NSUUID().uuidString),
        sourcekitd_uid_get_from_cstr("key.compilerargs")!: sourcekitd_request_array_create(&compilerargs, compilerargs.count),
        sourcekitd_uid_get_from_cstr("key.modulename")!: sourcekitd_request_string_create("SourceKittenFramework.\(module)")
    ]
    var keys = Array(dict.keys.map({ $0 as sourcekitd_uid_t? }))
    var values = Array(dict.values)
    return Request.customRequest(request: sourcekitd_request_dictionary_create(&keys, &values, dict.count)!).send()
}

extension String {
    private func nameFromFullFunctionName() -> String {
        return String(self[..<range(of: "(")!.lowerBound])
    }

    fileprivate func extractFreeFunctions(inSubstructure substructure: [[String: SourceKitRepresentable]]) -> [String] {
        return substructure.filter({
            SwiftDeclarationKind(rawValue: SwiftDocKey.getKind($0)!) == .functionFree
        }).flatMap { function -> String? in
            let name = (function["key.name"] as! String).nameFromFullFunctionName()
            let unsupportedFunctions = [
                "clang_executeOnThread",
                "sourcekitd_variant_dictionary_apply",
                "sourcekitd_variant_array_apply"
            ]
            guard !unsupportedFunctions.contains(name) else {
                return nil
            }

            let parameters = SwiftDocKey.getSubstructure(function)?.map { parameterStructure in
                return (parameterStructure as! [String: SourceKitRepresentable])["key.typename"] as! String
            } ?? []
            var returnTypes = [String]()
            if let offset = SwiftDocKey.getOffset(function), let length = SwiftDocKey.getLength(function) {
                let start = index(startIndex, offsetBy: Int(offset))
                let end = index(start, offsetBy: Int(length))
#if swift(>=4.0)
                let functionDeclaration = String(self[start..<end])
#else
                let functionDeclaration = self[start..<end]
#endif
                if let startOfReturnArrow = functionDeclaration.range(of: "->", options: .backwards)?.lowerBound {
                    let adjustedDistance = distance(from: startIndex, to: startOfReturnArrow)
                    let adjustedReturnTypeStartIndex = functionDeclaration.index(functionDeclaration.startIndex,
                                                                                 offsetBy: adjustedDistance + 3)
                    returnTypes.append(String(functionDeclaration[adjustedReturnTypeStartIndex...]))
                }
            }

            let joinedParameters = parameters.map({ $0.replacingOccurrences(of: "!", with: "?") }).joined(separator: ", ")
            let joinedReturnTypes = returnTypes.map({ $0.replacingOccurrences(of: "!", with: "?") }).joined(separator: ", ")
            let lhs = "internal let \(name): @convention(c) (\(joinedParameters)) -> (\(joinedReturnTypes))"
            let rhs = "library.load(symbol: \"\(name)\")"
            return "\(lhs) = \(rhs)".replacingOccurrences(of: "SourceKittenFramework.", with: "")
        }
    }
}

internal func libraryWrapperForModule(_ module: String, loadPath: String, linuxPath: String?, spmModule: String, compilerArguments: [String]) -> String {
    let sourceKitResponse = interfaceForModule(module, compilerArguments: compilerArguments)
    let substructure = SwiftDocKey.getSubstructure(Structure(sourceKitResponse: sourceKitResponse).dictionary)!.map({ $0 as! [String: SourceKitRepresentable] })
    let source = sourceKitResponse["key.sourcetext"] as! String
    let freeFunctions = source.extractFreeFunctions(inSubstructure: substructure)
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
