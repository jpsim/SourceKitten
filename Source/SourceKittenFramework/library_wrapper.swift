//
//  library_wrapper.swift
//  sourcekitten
//
//  Created by Norio Nomura on 2/20/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation
#if os(Linux)
typealias Process = Task
#endif
internal let defaultFileManager = FileManager.default

struct DynamicLinkLibrary {
    let path: String
    let handle: UnsafeMutableRawPointer
    
    func loadSymbol<T>(_ symbol: String) -> T {
        let sym = dlsym(handle, symbol)
        if sym == nil {
            let errorString = String(validatingUTF8: dlerror())
            fatalError("Finding symbol \(symbol) failed: \(errorString)")
        }
        return unsafeBitCast(sym, to: T.self)
    }
}

#if os(Linux)
let toolchainLoader = Loader(searchPaths: [linuxSourceKitLibPath!])
#else
let toolchainLoader = Loader(searchPaths: [
    xcodeDefaultToolchainOverride,
    toolchainDir,
    xcrunFindPath,
    /*
    These search paths are used when `xcode-select -p` points to
    "Command Line Tools OS X for Xcode", but Xcode.app exists.
    */
    applicationsDir?.xcodeDeveloperDir.toolchainDir,
    applicationsDir?.xcodeBetaDeveloperDir.toolchainDir,
    userApplicationsDir?.xcodeDeveloperDir.toolchainDir,
    userApplicationsDir?.xcodeBetaDeveloperDir.toolchainDir,
].flatMap { path in
    if let fullPath = path?.usrLibDir, fullPath.isFile {
        return fullPath
    }
    return nil
})
#endif

struct Loader {
    let searchPaths: [String]

    func load(_ path: String) -> DynamicLinkLibrary {
        let fullPaths = searchPaths.map { $0.stringByAppendingPathComponent(str: path) }.filter { $0.isFile }

        // try all fullPaths that contains target file,
        // then try loading with simple path that depends resolving to DYLD
        for fullPath in fullPaths + [path] {
            if let handle = dlopen(fullPath, RTLD_LAZY) {
                return DynamicLinkLibrary(path: path, handle: handle)
            }
        }

        fatalError("Loading \(path) failed")
    }
}

private func env(_ name: String) -> String? {
    return ProcessInfo.processInfo.environment[name]
}

/// Returns "LINUX_SOURCEKIT_LIB_PATH" environment variable
private let linuxSourceKitLibPath = env("LINUX_SOURCEKIT_LIB_PATH")

/// Returns "XCODE_DEFAULT_TOOLCHAIN_OVERRIDE" environment variable
///
/// `launch-with-toolchain` sets the toolchain path to the
/// "XCODE_DEFAULT_TOOLCHAIN_OVERRIDE" environment variable.
private let xcodeDefaultToolchainOverride = env("XCODE_DEFAULT_TOOLCHAIN_OVERRIDE")

/// Returns "TOOLCHAIN_DIR" environment variable
///
/// `Xcode`/`xcodebuild` sets the toolchain path to the
/// "TOOLCHAIN_DIR" environment variable.
private let toolchainDir = env("TOOLCHAIN_DIR")

/// Returns toolchain directory that parsed from result of `xcrun -find swift`
///
/// This is affected by "DEVELOPER_DIR", "TOOLCHAINS" environment variables.
private let xcrunFindPath: String? = {
    let pathOfXcrun = "/usr/bin/xcrun"

    if !defaultFileManager.isExecutableFile(atPath: pathOfXcrun) {
        return nil
    }

    let task = Process()
    task.launchPath = pathOfXcrun
    task.arguments = ["-find", "swift"]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch() // if xcode-select does not exist, crash with `NSInvalidArgumentException`.

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: .utf8) else {
        return nil
    }

    var start = output.startIndex
    var end = output.startIndex
    var contentsEnd = output.startIndex
    output.getLineStart(&start, end: &end, contentsEnd: &contentsEnd, for: start..<start)
    let xcrunFindSwiftPath = output.substring(with: start..<contentsEnd)
    guard xcrunFindSwiftPath.hasSuffix("/usr/bin/swift") else {
        return nil
    }
    let xcrunFindPath = xcrunFindSwiftPath.deletingLastPathComponents(n: 3)
    // Return nil if xcrunFindPath points to "Command Line Tools OS X for Xcode"
    // because it doesn't contain `sourcekitd.framework`.
    if xcrunFindPath == "/Library/Developer/CommandLineTools" {
        return nil
    }
    return xcrunFindPath
}()

#if !os(Linux)
private let applicationsDir: String? =
    NSSearchPathForDirectoriesInDomains(.applicationDirectory, .systemDomainMask, true).first

private let userApplicationsDir: String? =
    NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true).first
#endif

private extension String {
    var toolchainDir: String {
        return stringByAppendingPathComponent(str: "Toolchains/XcodeDefault.xctoolchain")
    }

    var xcodeDeveloperDir: String {
        return stringByAppendingPathComponent(str: "Xcode.app/Contents/Developer")
    }
    
    var xcodeBetaDeveloperDir: String {
        return stringByAppendingPathComponent(str: "Xcode-beta.app/Contents/Developer")
    }

    var usrLibDir: String {
        return stringByAppendingPathComponent(str: "/usr/lib")
    }

    func stringByAppendingPathComponent(str: String) -> String {
        #if os(Linux)
        return try! URL(fileURLWithPath: self).appendingPathComponent(str).path!
        #else
        return URL(fileURLWithPath: self).appendingPathComponent(str).path
        #endif
    }

    func deletingLastPathComponents(n: Int) -> String {
        var url = URL(fileURLWithPath: self)
        for _ in 0..<n {
            #if os(Linux)
            url = try! url.deletingLastPathComponent()
            #else
            url = url.deletingLastPathComponent()
            #endif
        }
        #if os(Linux)
        return url.path!
        #else
        return url.path
        #endif
    }
}
