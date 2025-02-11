#if os(Windows)
import WinSDK

#if !os(Windows)
// Shims for !windows SourceKit - see LibraryWrapperGeneratorTests.testLibraryWrappersAreUpToDate
private typealias WORD = UInt
private typealias DWORD = WORD
private typealias WCHAR = WORD
private let FORMAT_MESSAGE_ALLOCATE_BUFFER = 0
private let FORMAT_MESSAGE_FROM_SYSTEM = 0
private let FORMAT_MESSAGE_IGNORE_INSERTS = 0

// swiftlint:disable:next function_parameter_count
private func FormatMessageW(_ a: DWORD, _ b: Int?, _ c: DWORD, _ d: DWORD, _ e: Any?, _ f: Int, _ g: Int?) -> DWORD { 0 }
#endif

@_transparent
internal func MAKELANGID(_ p: WORD, _ s: WORD) -> DWORD {
    return DWORD((s << 10) | p)
}

struct WindowsError {
    let code: DWORD
}

extension WindowsError: Error {
    var localizedDescription: String {
        let dwFlags = DWORD(FORMAT_MESSAGE_ALLOCATE_BUFFER)
                    | DWORD(FORMAT_MESSAGE_FROM_SYSTEM)
                    | DWORD(FORMAT_MESSAGE_IGNORE_INSERTS)
        let dwLanguageId: DWORD =
            MAKELANGID(WORD(LANG_NEUTRAL), WORD(SUBLANG_DEFAULT))

        var buffer: UnsafeMutablePointer<WCHAR>?
        let dwResult = withUnsafeMutablePointer(to: &buffer) {
            $0.withMemoryRebound(to: WCHAR.self, capacity: 2) {
                FormatMessageW(dwFlags, nil, code, dwLanguageId, $0, 0, nil)
            }
        }
        guard dwResult > 0, let message = buffer else { return "Unknown error" }
        defer { LocalFree(message) }
        return String(decodingCString: message, as: UTF16.self)
    }
}
#endif
