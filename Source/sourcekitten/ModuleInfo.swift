import ArgumentParser
import SourceKittenFramework

extension SourceKitten {
    struct ModuleInfo: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Obtain information about a Swift module and print as JSON"
        )

        @Option(help: "Name of the Swift module")
        var module: String = ""

        @Argument(help: "Compiler arguments to pass to SourceKit")
        var compilerargs: [String]

        mutating func run() throws {
            guard !module.isEmpty else {
                throw SourceKittenError.invalidArgument(
                    description: "module must be set when calling \(Self._commandName)"
                )
            }
            let request = SourceKittenFramework.Request.moduleInfo(module: module, arguments: compilerargs)
            print(toJSON(toNSDictionary(try request.send())))
        }
    }
}
