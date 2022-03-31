import ArgumentParser
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#else
#error("Unsupported platform")
#endif
import Dispatch

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
