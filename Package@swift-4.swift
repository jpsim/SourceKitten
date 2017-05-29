// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "SourceKitten",
  dependencies: [
    .package(url: "https://github.com/Carthage/Commandant.git", from: "0.12.0"),
    .package(url: "https://github.com/drmohundro/SWXMLHash.git", .branch("version-4.0-changes")),
    .package(url: "https://github.com/jpsim/Yams.git", .branch("master")),
    .package(url: "https://github.com/norio-nomura/Clang_C.git", from: "1.0.0"),
    .package(url: "https://github.com/norio-nomura/SourceKit.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "sourcekitten",
      dependencies: [
        "Commandant",
        "SourceKittenFramework",
      ]
    ),
    .target(
      name: "SourceKittenFramework",
      dependencies: [
        "SWXMLHash",
        "Yams",
      ],
      exclude: [
        "clang-c",
        "sourcekitd.h",
      ]
    ),
    .testTarget(
      name: "SourceKittenFrameworkTests",
      dependencies: [
        "SourceKittenFramework"
      ],
      exclude: [
        "Fixtures",
      ]
    )
  ],
  swiftLanguageVersions: [3, 4]
)
