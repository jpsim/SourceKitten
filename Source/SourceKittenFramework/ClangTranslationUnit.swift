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
        for (key, value) in pairs {
            self[key] = value
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
        self.init(headerFiles: headerFiles, compilerArguments: compilerArguments, eventHook: .standardError)
    }

    /// Creates translation units, routing nested header-read diagnostics to `eventHook`.
    public init(headerFiles: [String], compilerArguments: [String], eventHook: EventHook) {
        let cStringCompilerArguments = compilerArguments.map { ($0 as NSString).utf8String }
        let clangIndex = ClangIndex()
        clangTranslationUnits = headerFiles.map { clangIndex.open(file: $0, args: cStringCompilerArguments) }
        declarations = clangTranslationUnits
            .flatMap { $0.cursor().compactMap({ SourceDeclaration(cursor: $0, compilerArguments: compilerArguments) }) }
            .rejectEmptyDuplicateEnums()
            .distinct()
            .sorted()
            .grouped { $0.location.file }
            .map { insertMarks(declarations: $0, eventHook: eventHook) }
    }

    /**
    Failable initializer to create a ClangTranslationUnit by passing Objective-C header files and
    `xcodebuild` arguments. Optionally pass in a `path`.

    - parameter headerFiles:         Objective-C header files to document.
    - parameter xcodeBuildArguments: The arguments necessary pass in to `xcodebuild` to link these header files.
    - parameter path:                Path to run `xcodebuild` from. Uses current path by default.
    */
    public init?(headerFiles: [String], xcodeBuildArguments: [String], inPath path: String = FileManager.default.currentDirectoryPath) {
        self.init(headerFiles: headerFiles, xcodeBuildArguments: xcodeBuildArguments, inPath: path, eventHook: .standardError)
    }

    /// Creates a translation unit, routing framework diagnostics to `eventHook`.
    public init?(headerFiles: [String], xcodeBuildArguments: [String],
                 inPath path: String = FileManager.default.currentDirectoryPath, eventHook: EventHook) {
        let xcodeBuildOutput = XcodeBuild.cleanBuild(arguments: xcodeBuildArguments + ["-dry-run"],
                                                    inPath: path, eventHook: eventHook).string ?? ""
        guard let clangArguments = parseCompilerArguments(xcodebuildOutput: xcodeBuildOutput, language: .objc, moduleName: nil) else {
            eventHook.emit("could not parse compiler arguments\n\(xcodeBuildOutput)\n")
            return nil
        }
        self.init(headerFiles: headerFiles, compilerArguments: clangArguments, eventHook: eventHook)
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
