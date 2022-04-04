exports_files(glob(["SourceKittenFramework/**/*.swift"]))

objc_library(
    name = "Clang_C",
    module_name = "Clang_C",
    srcs = glob(["Clang_C/**/*.m"], allow_empty = False),
    hdrs = glob(["Clang_C/**/*.h"], allow_empty = False),
    visibility = ["//visibility:public"]
)

objc_library(
    name = "SourceKit",
    module_name = "SourceKit",
    srcs = glob(["SourceKit/**/*.m"], allow_empty = False),
    hdrs = glob(["SourceKit/**/*.h"], allow_empty = False),
    visibility = ["//visibility:public"]
)

filegroup(
    name = "SourceKittenFrameworkSources",
    srcs = glob(["SourceKittenFramework/**/*.swift"], allow_empty = False),
    visibility = ["//visibility:public"]
)

filegroup(
    name = "SourceKittenLibSources",
    srcs = glob(["sourcekitten/**/*.swift"], allow_empty = False),
    visibility = ["//visibility:public"]
)
