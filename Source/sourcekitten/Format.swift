import ArgumentParser
import Foundation
import SourceKittenFramework

extension SourceKitten {
    struct Format: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Format Swift file")

        @Option(help: "Relative or absolute path of Swift file to format")
        var file = ""
        @Flag(help: "Trim trailing whitespace")
        var trimWhitespace = false
        @Flag(help: "Use tabs to indent")
        var useTabs = false
        @Option(help: "Number of spaces to indent")
        var indentWidth = 4

        mutating func run() throws {
            guard !file.isEmpty else {
                throw SourceKittenError.invalidArgument(
                    description: "file must be set when calling \(Self._commandName)"
                )
            }
            try File(path: file)?
                .format(trimmingTrailingWhitespace: trimWhitespace,
                        useTabs: useTabs,
                        indentWidth: indentWidth)
                .data(using: .utf8)?
                .write(to: URL(fileURLWithPath: file), options: [])
        }
    }
}
