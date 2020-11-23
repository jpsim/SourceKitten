import ArgumentParser
import SourceKittenFramework

extension SourceKitten {
    struct Version: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Display the current version of SourceKitten")

        mutating func run() throws {
            print(SourceKittenFramework.Version.current.value)
        }
    }
}
