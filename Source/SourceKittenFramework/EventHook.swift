import Foundation

/// Receives diagnostics from a SourceKitten framework operation.
///
/// Messages retain their original text, including any trailing newline. Handlers run
/// synchronously on the calling thread; dispatch to the appropriate queue before
/// updating a UI. A handler shared by concurrent operations must be thread-safe.
/// Process-wide SourceKit notifications and raw subprocess output are not routed here.
public struct EventHook {
    private let handler: (String) -> Void

    /// Creates a hook that sends diagnostics to the supplied handler instead of stderr.
    public init(_ handler: @escaping (String) -> Void) {
        self.handler = handler
    }

    /// The default diagnostic destination, preserving command-line behavior.
    public static var standardError: EventHook {
        EventHook { message in
            fputs(message, stderr)
        }
    }

    internal func emit(_ message: String) {
        handler(message)
    }
}
