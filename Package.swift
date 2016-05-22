import PackageDescription

let package = Package(
  name: "SourceKitten",
  targets: [
    Target(name: "SourceKittenFramework"),
    Target(name: "sourcekitten",
      dependencies: [.Target(name: "SourceKittenFramework")]),
  ],
  dependencies: [
    .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 1),
    .Package(url: "https://github.com/norio-nomura/SourceKit.git", majorVersion: 1),
    .Package(url: "https://github.com/norio-nomura/Clang_C.git", majorVersion: 1),
    .Package(url: "https://github.com/drmohundro/SWXMLHash.git", majorVersion: 2, minor: 3),
    .Package(url: "https://github.com/Carthage/Commandant.git", majorVersion: 0, minor: 9),
    .Package(url: "https://github.com/behrang/YamlSwift.git", majorVersion: 1, minor: 4),
  ],
  exclude: ["Tests/SourceKittenFramework/Fixtures"]
)
