load("@build_bazel_rules_swift//swift:swift.bzl", "swift_c_module")

exports_files(glob(["SourceKittenFramework/**/*.swift"]))

cc_library(
    name = "Clang_CLibrary",
    hdrs = glob(
        ["Clang_C/**/*.h"],
        allow_empty = False,
    ),
    visibility = ["//visibility:public"],
)

swift_c_module(
    name = "Clang_C",
    module_map = "Clang_C/Clang_C.modulemap",
    module_name = "Clang_C",
    visibility = ["//visibility:public"],
    deps = [":Clang_CLibrary"],
)

cc_library(
    name = "SourceKitLibrary",
    hdrs = glob(
        ["SourceKit/**/*.h"],
        allow_empty = False,
    ),
    visibility = ["//visibility:public"],
)

swift_c_module(
    name = "SourceKit",
    module_map = "SourceKit/SourceKit.modulemap",
    module_name = "SourceKit",
    visibility = ["//visibility:public"],
    deps = [":SourceKitLibrary"],
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
