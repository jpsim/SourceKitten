import ArgumentParser
import Foundation
import SourceKittenFramework

extension SourceKitten {
    struct Format: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Format Swift file")

        @Option(help: "Relative or absolute path of Swift file to format")
        var file: String = ""
        @Flag(help: "Trim trailing whitespace")
        var trimWhitespace: Bool = false
        @Flag(help: "Use tabs to indent")
        var useTabs: Bool = false
        @Option(help: "Number of spaces to indent")
        var indentWidth: Int = 4

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
