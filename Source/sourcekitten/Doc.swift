import ArgumentParser
import Foundation
import SourceKittenFramework

extension SourceKitten {
    struct Doc: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Print Swift or Objective-C docs as JSON")

        @Option(help: "Only document one file")
        var singleFile: Bool = false
        @Option(help: "Name of Swift module to document (can't be used with `--single-file`)")
        var moduleName: String = ""
        @Option(help: "Document a Swift Package Manager module")
        var spm: Bool = false
        @Option(help: "Document Objective-C headers instead of Swift code")
        var objc: Bool = false
        @Option(help: "Equivalent to --spm --module-name (string)")
        var spmModule: String = ""
        @Argument(help: "Arguments passed to `xcodebuild` or `swift build`")
        var arguments: [String] = []

        mutating func run() throws {
            let moduleName = self.moduleName.isEmpty ?
                (self.spmModule.isEmpty ? nil : self.spmModule)
                : self.moduleName
            let spm = self.spm || !self.spmModule.isEmpty

            if spm {
                if let docs = Module(spmArguments: arguments, spmName: moduleName)?.docs {
                    print(docs)
                    return
                }
                throw SourceKittenError.docFailed
            } else if objc {
#if os(Linux)
                fatalError("unsupported")
#else
                if arguments.isEmpty {
                    throw SourceKittenError.invalidArgument(
                        description: "at least 5 arguments are required when using `--objc`"
                    )
                }
                let translationUnit = ClangTranslationUnit(headerFiles: [arguments[0]],
                                                           compilerArguments: Array(arguments.dropFirst(1)))
                print(translationUnit)
                return
#endif
            } else if singleFile {
                if arguments.isEmpty {
                    throw SourceKittenError.invalidArgument(
                        description: "at least 5 arguments are required when using `--single-file`"
                    )
                }
                let sourcekitdArguments = Array(arguments.dropFirst(1))
                if let file = File(path: arguments[0]),
                   let docs = SwiftDocs(file: file, arguments: sourcekitdArguments) {
                    print(docs)
                    return
                }
                throw SourceKittenError.readFailed(path: arguments[0])
            }

            let module = Module(xcodeBuildArguments: arguments, name: moduleName)
            if let docs = module?.docs {
                print(docs)
                return
            }
            throw SourceKittenError.docFailed
        }
    }
}
