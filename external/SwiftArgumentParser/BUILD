load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "ArgumentParserToolInfo",
    module_name = "ArgumentParserToolInfo",
    srcs = glob([
      "Sources/ArgumentParserToolInfo/**/*.swift"
    ], allow_empty = False),
)

swift_library(
    name = "ArgumentParser",
    module_name = "ArgumentParser",
    srcs = glob([
      "Sources/ArgumentParser/**/*.swift"
    ], allow_empty = False),
    visibility = ["//visibility:public"],
    deps = [
      ":ArgumentParserToolInfo"
    ]
)
