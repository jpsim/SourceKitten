import ArgumentParser
import SourceKittenFramework

extension SourceKitten {
    struct Syntax: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Print Swift syntax information as JSON")

        @Option(help: "Relative or absolute path of Swift file to parse")
        var file: String = ""
        @Option(help: "Swift code text to parse")
        var text: String = ""

        mutating func run() throws {
            if !file.isEmpty {
                if let file = File(path: file) {
                    print(try SyntaxMap(file: file))
                    return
                }
                throw SourceKittenError.readFailed(path: file)
            }
            print(try SyntaxMap(file: File(contents: text)))
        }
    }
}
