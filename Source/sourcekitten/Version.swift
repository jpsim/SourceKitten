import ArgumentParser
import SourceKittenFramework

extension SourceKitten {
    struct Version: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Display the current version of SourceKitten")

        static var value: String { SourceKittenFramework.Version.current.value }

        mutating func run() throws {
            print(Self.value)
        }
    }
}
