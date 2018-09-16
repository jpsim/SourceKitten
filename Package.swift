// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SourceKitten",
    products: [
        .executable(name: "sourcekitten", targets: ["sourcekitten"]),
        .library(name: "SourceKittenFramework", targets: ["SourceKittenFramework"])
    ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.15.0"),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.7.1"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "1.0.1"),
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
