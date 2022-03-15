import ArgumentParser
import Foundation
import SourceKittenFramework

extension SourceKitten {
    struct Complete: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generate code completion options")

        @Option(help: "Relative or absolute path of Swift file to parse")
        var file = ""
        @Option(help: "Swift code text to parse")
        var text = ""
        @Option(help: "Offset for which to generate code completion options")
        var offset = 0
        @Option(help: "Read compiler flags from a Swift Package Manager module")
        var spmModule = ""
        @Flag(help: "Prettify output")
        var prettify = false
        @available(macOS 10.13, *)
        @Flag(help: "Sort keys in output")
        var sortKeys = false
        @Argument(help: "Compiler arguments to pass to SourceKit")
        var compilerargs: [String]

        mutating func run() throws {
            let path: String
            let contents: String
            if !file.isEmpty {
                path = file.bridge().absolutePathRepresentation()
                guard let file = File(path: path) else {
                    throw SourceKittenError.readFailed(path: path)
                }
                contents = file.contents
            } else {
                path = "\(NSUUID().uuidString).swift"
                contents = text
            }

            var args: [String]
            if spmModule.isEmpty {
                args = ["-c", path] + compilerargs
                if args.contains("-sdk") {
                    args.append(contentsOf: ["-sdk", sdkPath()])
                }
            } else {
                guard let module = Module(spmName: spmModule) else {
                    throw SourceKittenError.invalidArgument(description: "Bad module name")
                }
                args = module.compilerArguments
            }

            let request = SourceKittenFramework.Request.codeCompletionRequest(file: path, contents: contents,
                                                                              offset: ByteCount(offset),
                                                                              arguments: args)
            let completionItems = CodeCompletionItem.parse(response: try request.send())

            var outputOptions: JSONSerialization.WritingOptions = []
            outputOptions.insert(prettify ? .prettyPrinted : [])
            if #available(macOS 10.13, *) {
                outputOptions.insert(sortKeys ? .sortedKeys : [])
            }
            print(toJSON(completionItems.map { $0.dictionaryValue.bridge() }, options: outputOptions))
        }
    }
}
