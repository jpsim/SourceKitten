load("@build_bazel_rules_swift//swift:swift_interop_hint.bzl", "swift_interop_hint")
load("@rules_cc//cc:defs.bzl", "cc_library")

exports_files(glob(["SourceKittenFramework/**/*.swift"]))

cc_library(
    name = "Clang_CLibrary",
    hdrs = glob(
        ["Clang_C/**/*.h"],
        allow_empty = False,
    ),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "Clang_C",
    aspect_hints = [":Clang_C_SwiftInterop"],
    visibility = ["//visibility:public"],
    deps = [":Clang_CLibrary"],
)

swift_interop_hint(
    name = "Clang_C_SwiftInterop",
    module_map = "Clang_C/Clang_C.modulemap",
    module_name = "Clang_C",
)

cc_library(
    name = "SourceKitLibrary",
    hdrs = glob(
        ["SourceKit/**/*.h"],
        allow_empty = False,
    ),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "SourceKit",
    aspect_hints = [":SourceKit_SwiftInterop"],
    visibility = ["//visibility:public"],
    deps = [":SourceKitLibrary"],
)

swift_interop_hint(
    name = "SourceKit_SwiftInterop",
    module_map = "SourceKit/SourceKit.modulemap",
    module_name = "SourceKit",
)

filegroup(
    name = "SourceKittenFrameworkSources",
    srcs = glob(
        ["SourceKittenFramework/**/*.swift"],
        allow_empty = False,
    ),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "SourceKittenLibSources",
    srcs = glob(
        ["sourcekitten/**/*.swift"],
        allow_empty = False,
    ),
    visibility = ["//visibility:public"],
)
