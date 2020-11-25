import ArgumentParser
import SourceKittenFramework

extension SourceKitten {
    struct Request: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Run a raw SourceKit request")

        @Option(help: "A path to a yaml file, or yaml text to execute")
        var yaml: String = ""

        mutating func run() throws {
            if self.yaml.isEmpty {
                throw SourceKittenError.invalidArgument(description: "yaml file or text must be provided")
            }

            let yaml: String
            if let file = File(path: self.yaml) {
                yaml = file.contents
            } else {
                yaml = self.yaml
            }

            let request = SourceKittenFramework.Request.yamlRequest(yaml: yaml)
            print(toJSON(toNSDictionary(try request.send())))
        }
    }
}
