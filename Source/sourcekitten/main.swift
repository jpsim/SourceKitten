import ArgumentParser
import Dispatch

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

// `sourcekitd_set_notification_handler()` sets the handler to be executed on main thread queue.
// So, we vacate main thread to `dispatchMain()`.
if #available(macOS 10.10, *) {
    DispatchQueue.global(qos: .default).async {
        SourceKitten.main()
        exit(0)
    }
    dispatchMain()
} else {
    SourceKitten.main()
}
