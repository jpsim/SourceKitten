import PackageDescription

let package = Package(
  name: "SourceKitten",
  targets: [
    Target(name: "SourceKittenFramework"),
    Target(name: "sourcekitten",
      dependencies: [.Target(name: "SourceKittenFramework")]),
  ],
  dependencies: [
    .Package(url: "https://github.com/jpsim/Commandant.git", Version(5, 0, 5)),
    .Package(url: "https://github.com/jpsim/SWXMLHash.git", Version(2, 4, 5)),
    .Package(url: "https://github.com/jpsim/YamlSwift.git", Version(1, 6, 2)),
    .Package(url: "https://github.com/norio-nomura/Clang_C.git", majorVersion: 1),
    .Package(url: "https://github.com/norio-nomura/SourceKit.git", majorVersion: 1),
  ],
  exclude: ["Tests/SourceKittenFrameworkTests/Fixtures"]
)
