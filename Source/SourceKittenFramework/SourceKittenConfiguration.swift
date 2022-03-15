import Foundation

/// Options for configuring SourceKitten.
public enum SourceKittenConfiguration {
    /// On macOS, prefer using the in-process version of sourcekitd. This avoids the use of XPC, which is
    /// prohibited in some sandboxed environments, such as in Swift Package Manager plugins.
    ///
    /// - note: Setting this value has no effect if SourceKit requests have already been sent from this process.
    public static var preferInProcessSourceKit = envBool("IN_PROCESS_SOURCEKIT")
}

private func envBool(_ name: String) -> Bool {
    guard let value = ProcessInfo.processInfo.environment[name] else {
        return false
    }

    return ["1", "YES", "TRUE"].contains(value.uppercased())
}
