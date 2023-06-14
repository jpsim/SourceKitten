import Foundation

// MARK: - LibraryWrapperGenerator

/// Generator for SourceKitten's library wrappers.
enum LibraryWrapperGenerator: CaseIterable {
    case clang
    case sourcekit

    /// The relative file path for this library wrapper's generated source file.
    var filePath: String {
        return "Source/SourceKittenFramework/library_wrapper_\(moduleName).swift"
    }

    /// Generate the Swift source code for this library wrapper.
    ///
    /// - parameter compilerArguments: The compiler arguments to SourceKittenFramework.
    ///
    /// - returns: The generated Swift source code for this library wrapper.
    func generate(compilerArguments: [String]) throws -> String {
        let freeFunctions = try extractFreeFunctions(compilerArguments: compilerArguments)
            .joined(separator: "\n")
        return [
            fileHeader,
            "// swiftlint:disable unused_declaration - We don't care if some of these are unused.",
            freeFunctions,
            self == .clang ? "#endif" : nil
        ]
        .compactMap { $0 }
        .joined(separator: "\n\n") + "\n"
    }
}

// MARK: - Private

private extension LibraryWrapperGenerator {
    /// The wrapped module name.
    var moduleName: String {
        switch self {
        case .clang:
            return "Clang_C"
        case .sourcekit:
            return "SourceKit"
        }
    }

    /// The top section of the generated library wrapper.
    var fileHeader: String {
        switch self {
        case .clang:
            return """
                #if !os(Linux)

                #if os(Windows)
                import WinSDK
                #else
                import Darwin
                #endif

                #if SWIFT_PACKAGE
                import Clang_C
                #endif

                #if os(Windows)
                private let library = toolchainLoader.load(path: "libclang.dll")
                #else
                private let library = toolchainLoader.load(path: "libclang.dylib")
                #endif
                """
        case .sourcekit:
            return """
                #if SWIFT_PACKAGE
                import SourceKit
                #endif

                #if os(Linux)
                private let library = toolchainLoader.load(path: "libsourcekitdInProc.so")
                #elseif os(Windows)
                private let library = toolchainLoader.load(path: "sourcekitdInProc.dll")
                #else
                private let library = toolchainLoader.load(path: "sourcekitdInProc.framework/Versions/A/sourcekitdInProc")
                #endif
                """
        }
    }

    func extractFreeFunctions(compilerArguments: [String]) throws -> [String] {
        let sourceKitResponse = try interfaceForModule(moduleName, compilerArguments: compilerArguments)
        let substructure = SwiftDocKey.getSubstructure(Structure(sourceKitResponse: sourceKitResponse).dictionary)!
        let source = sourceKitResponse["key.sourcetext"] as! String
        return source.extractFreeFunctions(inSubstructure: substructure)
    }
}

private func interfaceForModule(_ module: String, compilerArguments: [String]) throws -> [String: SourceKitRepresentable] {
    return try Request.customRequest(request: [
        "key.request": UID("source.request.editor.open.interface"),
        "key.name": UUID().uuidString,
        "key.compilerargs": compilerArguments,
        "key.modulename": module
    ]).send()
}

private extension String {
    func nameFromFullFunctionName() -> String {
        return String(self[..<range(of: "(")!.lowerBound])
    }

    func extractFreeFunctions(inSubstructure substructure: [[String: SourceKitRepresentable]]) -> [String] {
        substructure
            .filter { SwiftDeclarationKind(rawValue: SwiftDocKey.getKind($0)!) == .functionFree }
            .compactMap { function -> String? in
                let name = (function["key.name"] as! String).nameFromFullFunctionName()
                let unsupportedFunctions = [
                    "clang_executeOnThread",
                    "sourcekitd_variant_dictionary_apply",
                    "sourcekitd_variant_array_apply"
                ]
                guard !unsupportedFunctions.contains(name) else {
                    return nil
                }

                let parameters = SwiftDocKey.getSubstructure(function)?.map { parameterStructure in
                    return parameterStructure["key.typename"] as! String
                } ?? []
                var returnTypes = [String]()
                if let offset = SwiftDocKey.getOffset(function), let length = SwiftDocKey.getLength(function) {
                    let stringView = StringView(self)
                    if let functionDeclaration = stringView.substringWithByteRange(ByteRange(location: offset, length: length)),
                       let startOfReturnArrow = functionDeclaration.range(of: "->", options: .backwards)?.lowerBound {
                        let adjustedDistance = distance(from: startIndex, to: startOfReturnArrow)
                        let adjustedReturnTypeStartIndex = functionDeclaration.index(functionDeclaration.startIndex,
                                                                                     offsetBy: adjustedDistance + 3)
                        returnTypes.append(String(functionDeclaration[adjustedReturnTypeStartIndex...]))
                    }
                }

                let joinedParameters = parameters.map({ $0.replacingOccurrences(of: "!", with: "?") }).joined(separator: ", ")
                let joinedReturnTypes = returnTypes.map({ $0.replacingOccurrences(of: "!", with: "?") }).joined(separator: ", ")
                let lhs = "internal let \(name): @convention(c) (\(joinedParameters)) -> (\(joinedReturnTypes))"
                let rhs = "library.load(symbol: \"\(name)\")"
                return "\(lhs) = \(rhs)".replacingOccurrences(of: "SourceKittenFramework.", with: "")
            }
    }
}
