import PackageDescription

let package = Package(
  name: "SourceKitten",
  targets: [
    Target(name: "SourceKittenFramework"),
    Target(name: "sourcekitten",
      dependencies: [.Target(name: "SourceKittenFramework")])
  ],
  dependencies: [
    .Package(url: "https://github.com/drmohundro/SWXMLHash.git", majorVersion: 2),
    .Package(url: "https://github.com/Carthage/Commandant.git", majorVersion: 0, minor: 8)
  ],
  exclude: ["Source/SourceKittenFrameworkTests"]
)
