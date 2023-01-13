load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_test",
)

swift_test(
    name = "UnitTests",
    size = "large",
    srcs = glob(
        ["SourceKittenFrameworkTests/**/*.swift"],
        [
            "SourceKittenFrameworkTests/Fixtures/**/*.*",
        ],
        allow_empty = False,
    ),
    data = glob(
        ["SourceKittenFrameworkTests/Fixtures/**/*.*"],
        allow_empty = False,
    ),
    module_name = "SourceKittenFrameworkTests",
    target_compatible_with = ["@platforms//os:macos"],
    deps = [
        "//:SourceKittenFramework",
    ],
)
