import PackageDescription

let package = Package(
  name: "SourceKitten",
  targets: [
    Target(name: "SourceKittenFramework"),
    Target(name: "sourcekitten",
      dependencies: [.Target(name: "SourceKittenFramework")]),
  ],
  dependencies: [
    .Package(url: "https://github.com/norio-nomura/SourceKit.git", majorVersion: 1),
    .Package(url: "https://github.com/jpsim/Commandant.git", majorVersion: 5),
  ],
  exclude: ["Tests/SourceKittenFramework/Fixtures"]
)
