// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "SourceKitten",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "sourcekitten", targets: ["sourcekitten"]),
        .library(name: "SourceKittenFramework", targets: ["SourceKittenFramework"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.1"),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "8.1.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.5"),
    ],
    targets: [
        .executableTarget(
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
