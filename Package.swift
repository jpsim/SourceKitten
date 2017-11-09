import PackageDescription

let package = Package(
  name: "SourceKitten",
  targets: [
    Target(name: "SourceKittenFramework"),
    Target(name: "sourcekitten",
      dependencies: [.Target(name: "SourceKittenFramework")]),
  ],
  dependencies: [
    .Package(url: "https://github.com/Carthage/Commandant.git", majorVersion: 0, minor: 12),
    .Package(url: "https://github.com/drmohundro/SWXMLHash.git", majorVersion: 4),
    .Package(url: "https://github.com/jpsim/Yams.git", majorVersion: 0, minor: 4),
    .Package(url: "https://github.com/norio-nomura/Clang_C.git", majorVersion: 1),
    .Package(url: "https://github.com/norio-nomura/SourceKit.git", majorVersion: 1),
  ],
  swiftLanguageVersions: [3, 4],
  exclude: [
    "Source/SourceKittenFramework/clang-c",
    "Source/SourceKittenFramework/sourcekitd.h",
    "Tests/SourceKittenFrameworkTests/Fixtures",
  ]
)
