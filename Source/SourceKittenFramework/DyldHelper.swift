//
//  DyldHelper.swift
//  sourcekitten
//
//  Created by Norio Nomura on 2/11/16.
//  Copyright © 2016 SourceKitten. All rights reserved.
//

import Foundation

/// Environment Variable that indicates current process is launched through `execv()`
private let sourceKittenFrameworkLoadingkey = "SOURCEKITTEN_FRAMEWORK_LOADING"

private let libclangPath = "libclang.dylib"
private let sourcekitdPath = "sourcekitd.framework/Versions/A/sourcekitd"

/// Checks whether depending dynamic link libraries are loaded or not.
/// If not, coordinates `DYLD_*` environment variables, calls `execv()` and never returns.
public func checkDepndenciesOfSourceKittenFramework() {
    if libraryIsLoaded(libclangPath) && libraryIsLoaded(sourcekitdPath) {
        return
    }

    // following codes will be executed when dependencies will not be loaded.
    // On sourcekitten installation, LC_RPATH of SourceKittenFramework does not contain pathes
    // which can find libclang.dylib and sourcekitd.framework.

    coordinateEnvironmentVariablesForDYLD()
    setenv(sourceKittenFrameworkLoadingkey, "1", 1)

    let arguments = NSProcessInfo.processInfo().arguments
    let path = arguments[0]
    let argv = CStringArray(arguments)
    execv(path, argv.pointers) // never returns on normal flow
    let error = String(UTF8String: strerror(errno))! // swiftlint:disable:this force_unwrapping
    fatalError("execv failed: \(error)")
}

/// Returns true if library is not loaded.
/// - Parameter path: string of library's path
private func libraryIsLoaded(path: String) -> Bool {
    let library = dlopen(path, RTLD_LAZY)
    if library != nil {
        dlclose(library)
        return true
    } else  if let _ = NSProcessInfo.processInfo().environment
        .indexForKey(sourceKittenFrameworkLoadingkey) {
        fatalError("Can't load \(path)")
    }
    return false
}

/// Coordinates "DYLD_LIBRARY_PATH" and "DYLD_FRAMEWORK_PATH" for `execv`ed process.
private func coordinateEnvironmentVariablesForDYLD() {
    let fileManager = NSFileManager.defaultManager()
    let developerDirXcode = "/Applications/Xcode.app/Contents/Developer"
    let developerDirXcodeBeta = "/Applications/Xcode-beta.app/Contents/Developer"

    var pathes: [String] = [
        toolchainDir,
        xcodeSelectPath.map(toolchainDirFrom),
        /*
        Followings are used when `xcode-select -p` points "Command Line Tools OS X for Xcode",
        but Xcode.app exists.
        */
        toolchainDirFrom(developerDirXcode),
        toolchainDirFrom(developerDirXcodeBeta),
        toolchainDirFrom(homeDir.stringByAppendingPathComponent(developerDirXcode)),
        toolchainDirFrom(homeDir.stringByAppendingPathComponent(developerDirXcodeBeta)),
        ].flatMap { path in
            if let fullPath = path?.stringByAppendingPathComponent("/usr/lib")
                where fileManager.fileExistsAtPath(fullPath) {
                    return fullPath
            }
            return nil
        }

    #if SWIFT_PACKAGE
        pathes = ["/Library/Developer/Toolchains/swift-latest"] + pathes
    #endif

    if let dyldLibraryPath = NSProcessInfo.processInfo().environment["DYLD_LIBRARY_PATH"] {
        setenv("DYLD_LIBRARY_PATH", (pathes + [dyldLibraryPath]).joinWithSeparator(":"), 1)
    } else {
        setenv("DYLD_LIBRARY_PATH", pathes.joinWithSeparator(":"), 1)
    }
    if let dyldLibraryPath = NSProcessInfo.processInfo().environment["DYLD_FRAMEWORK_PATH"] {
        setenv("DYLD_FRAMEWORK_PATH", (pathes + [dyldLibraryPath]).joinWithSeparator(":"), 1)
    } else {
        setenv("DYLD_FRAMEWORK_PATH", pathes.joinWithSeparator(":"), 1)
    }
}

/// Returns "TOOLCHAIN_DIR" environment variable
///
/// Xcode/xcodebuild set toolchain path to "TOOLCHAIN_DIR" environment variable.
private let toolchainDir: String? = {
    return NSProcessInfo.processInfo().environment["TOOLCHAIN_DIR"]
}()

/// Returns path of toolchain from developerDir
/// - Parameter developerDir: string of developer directory
private func toolchainDirFrom(developerDir: String) -> String {
    return developerDir.stringByAppendingPathComponent("Toolchains/XcodeDefault.xctoolchain")
}

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
    var end = output.startIndex
    var contentsEnd = output.startIndex
    output.getLineStart(&start, end: &end, contentsEnd: &contentsEnd, forRange: start..<start)
    let xcodeSelectPath = output.substringWithRange(start..<contentsEnd)
    // If xcodeSelectPath is path of "Command Line Tools OS X for Xcode", return nil.
    // Because that does not contain `sourcekitd.framework`.
    if xcodeSelectPath == "/Library/Developer/CommandLineTools" {
        return nil
    }
    return xcodeSelectPath
}()

private let homeDir: String = {
    return NSProcessInfo.processInfo().environment["HOME"]!
}()

private extension String {
    private func stringByAppendingPathComponent(str: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(str)
    }
}

// https://gist.github.com/neilpa/b430d148d1c5f4ae5ddd

// Is this really the best way to extend the lifetime of C-style strings? The lifetime
// of those passed to the String.withCString closure are only guaranteed valid during
// that call. Tried cheating this by returning the same C string from the closure but it
// gets dealloc'd almost immediately after the closure returns. This isn't terrible when
// dealing with a small number of constant C strings since you can nest closures. But
// this breaks down when it's dynamic, e.g. creating the char** argv array for an exec
// call.
private class CString {
    let _len: Int
    let buffer: UnsafeMutablePointer<Int8>

    init(_ string: String) {
        (_len, buffer) = string.withCString {
            let len = Int(strlen($0) + 1)
            let dst = strcpy(UnsafeMutablePointer<Int8>.alloc(len), $0)
            return (len, dst)
        }
    }

    deinit {
        buffer.dealloc(_len)
    }
}

// An array of C-style strings (e.g. char**) for easier interop.
private class CStringArray {
    // Have to keep the owning CString's alive so that the pointers
    // in our buffer aren't dealloc'd out from under us.
    let _strings: [CString]
    var pointers: [UnsafeMutablePointer<Int8>]

    init(_ strings: [String]) {
        _strings = strings.map { CString($0) }
        pointers = _strings.map { $0.buffer }
        // NULL-terminate our string pointer buffer since things like
        // exec*() and posix_spawn() require this.
        pointers.append(nil)
    }
}
