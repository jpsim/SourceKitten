import PackageDescription

let package = Package(
  name: "SourceKitten",
  targets: [
    Target(name: "SourceKittenFramework"),
    Target(name: "sourcekitten",
      dependencies: [.Target(name: "SourceKittenFramework")]),
    Target(name: "SourceKittenFrameworkTests",
      dependencies: [.Target(name: "SourceKittenFramework")]),
  ],
  dependencies: [
    .Package(url: "https://github.com/antitypical/Result.git", majorVersion: 1),
    .Package(url: "https://github.com/norio-nomura/SourceKit.git", majorVersion: 1),
    .Package(url: "https://github.com/drmohundro/SWXMLHash.git", majorVersion: 2),
    .Package(url: "https://github.com/Carthage/Commandant.git", majorVersion: 0, minor: 8),
    .Package(url: "https://github.com/norio-nomura/swift-corelibs-xctest.git", majorVersion: 0),
  ]
)
