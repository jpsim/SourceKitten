//
//  Loader.swift
//  sourcekitten
//
//  Created by Norio Nomura on 2/20/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation

struct DynamicLinkLibrary {
    let path: String
    let handle: UnsafeMutablePointer<Void>
    
    func loadSymbol<T>(symbol: String) -> T {
        let sym = Darwin.dlsym(handle, symbol)
        if sym == nil {
            let errorString = String(UTF8String: dlerror())
            fatalError("Finding symbol \(symbol) failed: \(errorString)")
        }
        return unsafeBitCast(sym, T.self)
    }
}

let toolchainLoader = Loader(paths: [
    xcodeDefaultToolchainOverride,
    toolchainDir,
    xcodeSelectPath?.toolchainDir,
    /*
    Followings are used when `xcode-select -p` points "Command Line Tools OS X for Xcode",
    but Xcode.app exists.
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
    let paths: [String]

    func load(path: String) -> DynamicLinkLibrary {
        let fullPaths = paths.map { $0.stringByAppendingPathComponent(path) }.filter { $0.isFile }

        // try all fullPaths that contains target file
        for fullPath in fullPaths {
            let handle = dlopen(fullPath, RTLD_LAZY)
            if handle != nil {
                return DynamicLinkLibrary(path: path, handle: handle)
            }
        }

        // try loading with simple path that depends resolving to DYLD
        let handle = dlopen(path, RTLD_LAZY)
        if handle != nil {
            return DynamicLinkLibrary(path: path, handle: handle)
        }

        fatalError("Loading \(path) failed")
    }
}

/// Returns "XCODE_DEFAULT_TOOLCHAIN_OVERRIDE" environment variable
///
/// `launch-with-toolchain` set toolchain path to "XCODE_DEFAULT_TOOLCHAIN_OVERRIDE" environment
/// variable.
private let xcodeDefaultToolchainOverride: String? =
    NSProcessInfo.processInfo().environment["XCODE_DEFAULT_TOOLCHAIN_OVERRIDE"]

/// Returns "TOOLCHAIN_DIR" environment variable
///
/// `Xcode`/`xcodebuild` set toolchain path to "TOOLCHAIN_DIR" environment variable.
private let toolchainDir: String? =
    NSProcessInfo.processInfo().environment["TOOLCHAIN_DIR"]

/// Returns result string of `xcode-select -p`
private let xcodeSelectPath: String? = {
    let pathOfXcodeSelect = "/usr/bin/xcode-select"

    if !NSFileManager.defaultManager().isExecutableFileAtPath(pathOfXcodeSelect) {
        return nil
    }

    let task = NSTask()
    task.launchPath = pathOfXcodeSelect
    task.arguments = ["-p"]

    let pipe = NSPipe()
    task.standardOutput = pipe
    task.standardError = pipe
    task.launch() // if xcode-select does not exist, crash with `NSInvalidArgumentException`.

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    guard let output = String(data: data, encoding: NSUTF8StringEncoding) else {
        return nil
    }

    var start = output.startIndex
    var contentsEnd = output.startIndex
    output.getLineStart(&start, end: nil, contentsEnd: &contentsEnd, forRange: start..<start)
    let xcodeSelectPath = output.substringWithRange(start..<contentsEnd)
    // If xcodeSelectPath is path of "Command Line Tools OS X for Xcode", return nil.
    // Because that does not contain `sourcekitd.framework`.
    if xcodeSelectPath == "/Library/Developer/CommandLineTools" {
        return nil
    }
    return xcodeSelectPath
}()

private let applicationsDir: String? =
    NSSearchPathForDirectoriesInDomains(.ApplicationDirectory, .SystemDomainMask, true).first

private let userApplicationsDir: String? =
    NSSearchPathForDirectoriesInDomains(.ApplicationDirectory, .UserDomainMask, true).first

private extension String {
    private var isFile: Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(self)
    }

    private var toolchainDir: String {
        return stringByAppendingPathComponent("Toolchains/XcodeDefault.xctoolchain")
    }

    private var xcodeDeveloperDir: String {
        return stringByAppendingPathComponent("Xcode.app/Contents/Developer")
    }
    
    private var xcodeBetaDeveloperDir: String {
        return stringByAppendingPathComponent("Xcode-beta.app/Contents/Developer")
    }

    private var usrLibDir: String {
        return stringByAppendingPathComponent("/usr/lib")
    }

    private func stringByAppendingPathComponent(str: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(str)
    }
}
