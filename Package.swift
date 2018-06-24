// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SourceKitten",
    products: [
        .executable(name: "sourcekitten", targets: ["sourcekitten"]),
        .library(name: "SourceKittenFramework", targets: ["SourceKittenFramework"])
    ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.13.0"),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.7.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.0"),
        .package(url: "https://github.com/norio-nomura/Clang_C.git", from: "1.0.3"),
        .package(url: "https://github.com/norio-nomura/SourceKit.git", from: "1.0.1"),
        .package(url: "https://github.com/norio-nomura/SwiftBacktrace", .branch("master"))
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
                "SourceKittenFramework",
                "SwiftBacktrace"
            ],
            exclude: [
                "Fixtures",
            ]
        )
    ]
)
