import ArgumentParser
import Foundation
import SourceKittenFramework

extension SourceKitten {
    struct Index: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Index Swift file and print as JSON")

        @Option(help: "Relative or absolute path of Swift file to index")
        var file: String = ""
        @Argument(help: "Compiler arguments to pass to SourceKit")
        var compilerargs: [String]

        mutating func run() throws {
            guard !file.isEmpty else {
                throw SourceKittenError.invalidArgument(
                    description: "file must be set when calling \(Self._commandName)"
                )
            }
            let absoluteFile = file.bridge().absolutePathRepresentation()
            let request = SourceKittenFramework.Request.index(file: absoluteFile, arguments: compilerargs)
            print(toJSON(toNSDictionary(try request.send())))
        }
    }
}
