//
//  library_wrapper.swift
//  sourcekitten
//
//  Created by Norio Nomura on 2/20/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation

struct DynamicLinkLibrary {
    let path: String
    let handle: UnsafeMutablePointer<Void>
    
    func loadSymbol<T>(_ symbol: String) -> T {
        let sym = Darwin.dlsym(handle, symbol)
        if sym == nil {
            let errorString = String(validatingUTF8: dlerror())
            fatalError("Finding symbol \(symbol) failed: \(errorString)")
        }
        return unsafeBitCast(sym, to: T.self)
    }
}

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
        if let fullPath = path?.usrLibDir where fullPath.isFile {
            return fullPath
        }
        return nil
    })

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

/// Returns "XCODE_DEFAULT_TOOLCHAIN_OVERRIDE" environment variable
///
/// `launch-with-toolchain` sets the toolchain path to the
/// "XCODE_DEFAULT_TOOLCHAIN_OVERRIDE" environment variable.
private let xcodeDefaultToolchainOverride: String? =
    ProcessInfo.processInfo().environment["XCODE_DEFAULT_TOOLCHAIN_OVERRIDE"]

/// Returns "TOOLCHAIN_DIR" environment variable
///
/// `Xcode`/`xcodebuild` sets the toolchain path to the
/// "TOOLCHAIN_DIR" environment variable.
private let toolchainDir: String? =
    ProcessInfo.processInfo().environment["TOOLCHAIN_DIR"]

/// Returns toolchain directory that parsed from result of `xcrun -find swift`
///
/// This is affected by "DEVELOPER_DIR", "TOOLCHAINS" environment variables.
private let xcrunFindPath: String? = {
    let pathOfXcrun = "/usr/bin/xcrun"

    if !FileManager.default().isExecutableFile(atPath: pathOfXcrun) {
        return nil
    }

    let task = Task()
    task.launchPath = pathOfXcrun
    task.arguments = ["-find", "swift"]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch() // if xcode-select does not exist, crash with `NSInvalidArgumentException`.

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: String.Encoding.utf8) else {
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

private let applicationsDir: String? =
    NSSearchPathForDirectoriesInDomains(.applicationDirectory, .systemDomainMask, true).first

private let userApplicationsDir: String? =
    NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true).first

private extension String {
    private var toolchainDir: String {
        return stringByAppendingPathComponent(str: "Toolchains/XcodeDefault.xctoolchain")
    }

    private var xcodeDeveloperDir: String {
        return stringByAppendingPathComponent(str: "Xcode.app/Contents/Developer")
    }
    
    private var xcodeBetaDeveloperDir: String {
        return stringByAppendingPathComponent(str: "Xcode-beta.app/Contents/Developer")
    }

    private var usrLibDir: String {
        return stringByAppendingPathComponent(str: "/usr/lib")
    }

    private func stringByAppendingPathComponent(str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    private func deletingLastPathComponents(n: Int) -> String {
        let pathComponents = NSString(string: self).pathComponents.dropLast(n)
        return NSString.path(withComponents: Array(pathComponents))
    }
}
