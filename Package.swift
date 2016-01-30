import PackageDescription

let package = Package(
  name: "SourceKitten",
  targets: [
    Target(name: "SourceKittenFramework"),
    Target(name: "sourcekitten",
      dependencies: [.Target(name: "SourceKittenFramework")])
  ],
  dependencies: [
    .Package(url: "https://github.com/jpsim/SWXMLHash.git", majorVersion: 1),
    .Package(url: "https://github.com/jpsim/Commandant.git", majorVersion: 1)
  ],
  exclude: ["Source/SourceKittenFrameworkTests"]
)
