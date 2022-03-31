load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
    "swift_binary"
)

swift_library(
    name = "SourceKittenFramework",
    module_name = "SourceKittenFramework",
    srcs = ["//Source:SourceKittenFrameworkSources"],
    deps = [
        "@swiftsyntax_com_github_drmohundro_SWXMLHash//:SWXMLHash",
        "@swiftsyntax_com_github_jpsim_yams//:Yams",
        "//Source:SourceKit",
        "//Source:Clang_C"
    ],
    defines = ["SWIFT_PACKAGE"],
    visibility = ["//visibility:public"]
)

swift_binary(
    name = "sourcekitten",
    srcs = ["//Source:SourceKittenLibSources"],
    deps = [
        ":SourceKittenFramework",
        "@swiftsyntax_com_github_apple_swift_argument_parser//:ArgumentParser"
    ],
    defines = ["SWIFT_PACKAGE"],
    visibility = ["//visibility:public"]
)
