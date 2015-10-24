//
//  ClangTranslationUnit.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-12.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

extension SequenceType where Generator.Element: Hashable {
    func distinct() -> [Generator.Element] {
        return Array(Set(self))
    }
}

extension SequenceType {
    func groupBy<T: Hashable>(keyFn: (Generator.Element) -> T) -> [T: [Generator.Element]] {
        var ret = Dictionary<T, [Generator.Element]>()
        for val in self {
            let key = keyFn(val)
            var d = ret[key] ?? []
            d.append(val)
            ret[key] = d
        }
        return ret
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
        let cStringCompilerArguments = compilerArguments.map { ($0 as NSString).UTF8String }
        let clangIndex = ClangIndex()
        clangTranslationUnits = headerFiles.map { clangIndex.open(file: $0, args: cStringCompilerArguments) }
        declarations = clangTranslationUnits
            .flatMap { $0.cursor().flatMap(SourceDeclaration.init) }
            .distinct()
            .sort()
            .groupBy { $0.location.file }
    }

    /**
    Failable initializer to create a ClangTranslationUnit by passing Objective-C header files and
    `xcodebuild` arguments. Optionally pass in a `path`.

    - parameter headerFiles:         Objective-C header files to document.
    - parameter xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to link these header files.
    - parameter path:                Path to run `xcodebuild` from. Uses current path by default.
    */
    public init?(headerFiles: [String], xcodeBuildArguments: [String], inPath path: String = NSFileManager.defaultManager().currentDirectoryPath) {
        let xcodeBuildOutput = runXcodeBuild(xcodeBuildArguments + ["-dry-run"], inPath: path) ?? ""
        guard let clangArguments = parseCompilerArguments(xcodeBuildOutput, language: .ObjC, moduleName: nil) else {
            fputs("could not parse compiler arguments\n", stderr)
            fputs("\(xcodeBuildOutput)\n", stderr)
            return nil
        }
        self.init(headerFiles: headerFiles, compilerArguments: clangArguments)
    }
}

// MARK: CustomStringConvertible

extension ClangTranslationUnit: CustomStringConvertible {
    /// A textual JSON representation of `ClangTranslationUnit`.
    public var description: String {
        return declarationsToJSON(declarations)
    }
}