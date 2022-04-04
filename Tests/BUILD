load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_test"
)

config_setting(
    name = "linux",
    constraint_values = ["@platforms//os:linux"],
)

genrule(
    name = "LinuxMain",
    srcs = ["LinuxMain.swift"],
    outs = ["main.swift"],
    cmd = "cp $< $@",
)

swift_test(
    name = "UnitTests",
    module_name = "SourceKittenFrameworkTests",
    srcs = glob(["SourceKittenFrameworkTests/**/*.swift"], [
        "SourceKittenFrameworkTests/Fixtures/**/*.*"
    ], allow_empty = False) + select({
        ":linux": ["main.swift"],
        "//conditions:default": [],
    }),
    deps = [
        "//:SourceKittenFramework"
    ],
    size = "large",
    data = glob(["SourceKittenFrameworkTests/Fixtures/**/*.*"], allow_empty = False)
)
