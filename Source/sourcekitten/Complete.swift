import ArgumentParser
import Foundation
import SourceKittenFramework

extension SourceKitten {
    struct Complete: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generate code completion options")

        @Option(help: "Relative or absolute path of Swift file to parse")
        var file: String = ""
        @Option(help: "Swift code text to parse")
        var text: String = ""
        @Option(help: "Offset for which to generate code completion options")
        var offset: Int = 0
        @Option(help: "Read compiler flags from a Swift Package Manager module")
        var spmModule: String = ""
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
            print(CodeCompletionItem.parse(response: try request.send()))
        }
    }
}
