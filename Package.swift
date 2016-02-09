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
    .Package(url: "https://github.com/jpsim/SourceKit", majorVersion: 1),
    .Package(url: "https://github.com/drmohundro/SWXMLHash", majorVersion: 2),
    .Package(url: "https://github.com/Carthage/Commandant", majorVersion: 0, minor: 8),
    .Package(url: "https://github.com/norio-nomura/swift-corelibs-xctest", majorVersion: 0),
  ]
)
