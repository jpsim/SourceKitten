//
//  ClangTranslationUnit.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-12.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

#if !os(Linux)

#if SWIFT_PACKAGE
import Clang_C
#endif
import Foundation

extension Sequence where Iterator.Element: Hashable {
    fileprivate func distinct() -> [Iterator.Element] {
        return Array(Set(self))
    }
}

extension Sequence {
    fileprivate func grouped<U>(by transform: (Iterator.Element) -> U) -> [U: [Iterator.Element]] {
        return reduce([:]) { dictionary, element in
            var dictionary = dictionary
            let key = transform(element)
            dictionary[key] = (dictionary[key] ?? []) + [element]
            return dictionary
        }
    }
}

extension Dictionary {
    fileprivate init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }

    fileprivate func map<OutValue>(transform: (Value) throws -> (OutValue)) rethrows -> [Key: OutValue] {
        return [Key: OutValue](try map { ($0.key, try transform($0.value)) })
    }
}

/// Represents a group of CXTranslationUnits.
public struct ClangTranslationUnit {
    /// Array of CXTranslationUnits.
    private let clangTranslationUnits: [CXTranslationUnit]

    public let declarations: [String: [SourceDeclaration]]

    /**
    Create a ClangTranslationUnit by passing Objective-C header files and clang compiler arguments.

    - parameter headerFiles:       Objective-C header files to document.
    - parameter compilerArguments: Clang compiler arguments.
    */
    public init(headerFiles: [String], compilerArguments: [String]) {
        let cStringCompilerArguments = compilerArguments.map { ($0 as NSString).utf8String }
        let clangIndex = ClangIndex()
        clangTranslationUnits = headerFiles.map { clangIndex.open(file: $0, args: cStringCompilerArguments) }
        declarations = clangTranslationUnits
            .flatMap { $0.cursor().flatMap({ SourceDeclaration(cursor: $0, compilerArguments: compilerArguments) }) }
            .rejectEmptyDuplicateEnums()
            .distinct()
            .sorted()
            .grouped { $0.location.file }
            .map { insertMarks(declarations: $0) }
    }

    /**
    Failable initializer to create a ClangTranslationUnit for a module by passing the root (umbrella)
    Objective-C header file and using xcodebuild to guess the clang arguments.

    - parameter umbrellaHeader:      Objective-C header files containing declarations for the module.
    - parameter xcodeBuildArguments: Additional arguments for `xcodebuild` to build the module.
    - parameter moduleName:          Name of the module to build. If not set, uses the first one built by `xcodebuild`.
    - parameter path:                Path to run `xcodebuild` from. Uses current path by default.
    */
    public init?(umbrellaHeader: String, xcodeBuildArguments: [String], moduleName: String?, inPath path: String = FileManager.default.currentDirectoryPath) {
        let xcodeBuildOutput = runXcodeBuild(arguments: xcodeBuildArguments + ["-dry-run"], inPath: path) ?? ""
        guard let clangArguments = parseCompilerArguments(xcodebuildOutput: xcodeBuildOutput as NSString, language: .objc, moduleName: moduleName) else {
            reportXcodeBuildError(xcodeBuildOutput: xcodeBuildOutput, language: .objc)
            return nil
        }
        // add current dir to include path as last place to look - eases transition from raw clang objc mode
        self.init(headerFiles: [umbrellaHeader], compilerArguments: clangArguments + ["-I", path])
    }
}

// MARK: CustomStringConvertible

extension ClangTranslationUnit: CustomStringConvertible {
    /// A textual JSON representation of `ClangTranslationUnit`.
    public var description: String {
        return declarationsToJSON(declarations) + "\n"
    }
}

#endif
