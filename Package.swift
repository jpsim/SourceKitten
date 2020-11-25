// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SourceKitten",
    products: [
        .executable(name: "sourcekitten", targets: ["sourcekitten"]),
        .library(name: "SourceKittenFramework", targets: ["SourceKittenFramework"])
    ],
    dependencies: [
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.2"),
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.3.1")),
        .package(name: "SWXMLHash", url: "https://github.com/drmohundro/SWXMLHash.git", .upToNextMinor(from: "5.0.1")),
        .package(name: "Yams", url: "https://github.com/jpsim/Yams.git", from: "4.0.1"),
    ],
    targets: [
        .target(
            name: "sourcekitten",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "SourceKittenFramework",
            ]
        ),
        .target(
            name: "Clang_C"
        ),
        .target(
            name: "SourceKit"
        ),
        .target(
            name: "SourceKittenFramework",
            dependencies: [
                "Clang_C",
                "SourceKit",
                "SWXMLHash",
                "Yams",
            ]
        ),
        .testTarget(
            name: "SourceKittenFrameworkTests",
            dependencies: [
                "SnapshotTesting",
                "SourceKittenFramework"
            ],
            exclude: [
                "Fixtures",
            ]
        )
    ]
)
