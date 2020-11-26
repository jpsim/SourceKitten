import ArgumentParser

struct SourceKitten: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sourcekitten",
        abstract: "An adorable little command line tool for interacting with SourceKit",
        version: Version.value,
        subcommands: [
            Complete.self,
            Doc.self,
            Format.self,
            Index.self,
            ModuleInfo.self,
            Request.self,
            Structure.self,
            Syntax.self,
            Version.self
        ]
    )
}
