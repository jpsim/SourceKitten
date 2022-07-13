// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "SourceKitten",
    products: [
        .executable(name: "sourcekitten", targets: ["sourcekitten"]),
        .library(name: "SourceKittenFramework", targets: ["SourceKittenFramework"])
    ],
    dependencies: [
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.3"),
        .package(name: "SWXMLHash", url: "https://github.com/drmohundro/SWXMLHash.git", .upToNextMinor(from: "7.0.1")),
        .package(name: "Yams", url: "https://github.com/jpsim/Yams.git", from: "5.0.1"),
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
                "SourceKittenFramework"
            ],
            exclude: [
                "Fixtures",
            ]
        )
    ]
)
