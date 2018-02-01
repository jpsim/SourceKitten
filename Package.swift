// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SourceKitten",
    products: [
        .executable(name: "sourcekitten", targets: ["sourcekitten"]),
        .library(name: "SourceKittenFramework", targets: ["SourceKittenFramework"])
    ],
    dependencies: [
        .package(url: "https://github.com/Carthage/Commandant.git", .revision("ab5f20d3e845dc3845eb4c79a4bd8d5ac8af5e1c")),
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.2.0"),
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMinor(from: "0.5.0") ),
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
