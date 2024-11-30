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

// MARK: - SourceKitObjectConvertible

public protocol SourceKitObjectConvertible {
    var sourceKitObject: SourceKitObject? { get }
}

extension Array: SourceKitObjectConvertible where Element: SourceKitObjectConvertible {
    public var sourceKitObject: SourceKitObject? {
        let children = map { $0.sourceKitObject }
        let objects = children.map { $0?.sourcekitdObject }
        return sourcekitd_request_array_create(objects, objects.count).map { SourceKitObject($0, children: children) }
    }
}

extension Dictionary: SourceKitObjectConvertible where Key: UIDRepresentable, Value: SourceKitObjectConvertible {
    public var sourceKitObject: SourceKitObject? {
        let keys: [sourcekitd_uid_t?] = self.keys.map { $0.uid.sourcekitdUID }
        let children = self.values.map { $0.sourceKitObject }
        let values = children.map { $0?.sourcekitdObject }
        return sourcekitd_request_dictionary_create(keys, values, count).map { SourceKitObject($0, children: children) }
    }
}

extension Int: SourceKitObjectConvertible {
    public var sourceKitObject: SourceKitObject? {
        return Int64(self).sourceKitObject
    }
}

extension Int64: SourceKitObjectConvertible {
    public var sourceKitObject: SourceKitObject? {
        return sourcekitd_request_int64_create(self).map { SourceKitObject($0) }
    }
}

extension String: SourceKitObjectConvertible {
    public var sourceKitObject: SourceKitObject? {
        return sourcekitd_request_string_create(self).map { SourceKitObject($0) }
    }
}

extension UID: SourceKitObjectConvertible {
    public var sourceKitObject: SourceKitObject? {
        return sourcekitd_request_uid_create(sourcekitdUID).map { SourceKitObject($0) }
    }
}

// MARK: - SourceKitObject

/// Swift representation of sourcekitd_object_t
public final class SourceKitObject {
    fileprivate let sourcekitdObject: sourcekitd_object_t

    /// Other SourceKitObjects whose lifetime is tied to this one (ex: array elements, dictionary values)
    private var children: [SourceKitObject?]

    init(yaml: String) {
        self.sourcekitdObject = sourcekitd_request_create_from_yaml(yaml, nil)!
        self.children = []
    }

    fileprivate init(_ sourcekitdObject: sourcekitd_object_t, children: [SourceKitObject?] = []) {
        self.sourcekitdObject = sourcekitdObject
        self.children = children
    }

    deinit {
        sourcekitd_request_release(sourcekitdObject)
    }

    /// Updates the value stored in the dictionary for the given key,
    /// or adds a new key-value pair if the key does not exist.
    ///
    /// - Parameters:
    ///   - value: The new value to add to the dictionary.
    ///   - key: The key to associate with value. If key already exists in the dictionary,
    ///     value replaces the existing associated value. If key isn't already a key of the dictionary
    public func updateValue(_ value: SourceKitObjectConvertible, forKey key: UID) {
        precondition(value.sourceKitObject != nil)
        let sourceKitObject = value.sourceKitObject
        children.append(sourceKitObject)
        sourcekitd_request_dictionary_set_value(sourcekitdObject, key.sourcekitdUID, sourceKitObject!.sourcekitdObject)
    }

    public func updateValue(_ value: SourceKitObjectConvertible, forKey key: String) {
        updateValue(value, forKey: UID(key))
    }

    public func updateValue<T>(_ value: SourceKitObjectConvertible, forKey key: T) where T: RawRepresentable, T.RawValue == String {
        updateValue(value, forKey: UID(key.rawValue))
    }

    /// Swift wrapper for sourcekitd_send_request_sync
    /// Must call sourcekitd_response_dispose on the resulting object.
    func sendSync() -> sourcekitd_response_t? {
        return sourcekitd_send_request_sync(sourcekitdObject)
    }

    func sendAsync() async throws -> sourcekitd_response_t {
        let handle = UncheckedSendable(UnsafeMutablePointer<sourcekitd_request_handle_t?>.allocate(capacity: 1))

        return try await withTaskCancellationHandler {
            try await withUnsafeThrowingContinuation { continuation in
                sourcekitd_send_request(sourcekitdObject, handle.value) { response in
                    enum SourceKitSendError: Error { case error, noResponse }

                    guard let response else {
                        continuation.resume(throwing: SourceKitSendError.noResponse)
                        return
                    }

                    if sourcekitd_response_is_error(response) {
                        continuation.resume(throwing: SourceKitSendError.error)
                    } else {
                        continuation.resume(returning: response)
                    }
                }
            }
        } onCancel: {
            sourcekitd_cancel_request(handle.value)
        }
    }
}

extension SourceKitObject: SourceKitObjectConvertible {
    public var sourceKitObject: SourceKitObject? {
        return self
    }
}

extension SourceKitObject: CustomStringConvertible {
    public var description: String {
        let bytes = sourcekitd_request_description_copy(sourcekitdObject)!
        defer { free(bytes) }
        return String(cString: bytes)
    }
}

extension SourceKitObject: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: SourceKitObject...) {
        let objects: [sourcekitd_object_t?] = elements.map { $0.sourcekitdObject }
        self.init(sourcekitd_request_array_create(objects, objects.count)!, children: elements)
    }
}

extension SourceKitObject: ExpressibleByDictionaryLiteral {
    public convenience init(dictionaryLiteral elements: (UID, SourceKitObjectConvertible)...) {
        let keys: [sourcekitd_uid_t?] = elements.map { $0.0.sourcekitdUID }
        let children = elements.map { $0.1.sourceKitObject }
        let values: [sourcekitd_object_t?] = children.map { $0?.sourcekitdObject }
        self.init(sourcekitd_request_dictionary_create(keys, values, elements.count)!, children: children)
    }
}

extension SourceKitObject: ExpressibleByIntegerLiteral {
    public convenience init(integerLiteral value: IntegerLiteralType) {
        self.init(sourcekitd_request_int64_create(Int64(value))!)
    }
}

extension SourceKitObject: ExpressibleByStringLiteral {
    public convenience init(stringLiteral value: StringLiteralType) {
        self.init(sourcekitd_request_string_create(value)!)
    }
}
