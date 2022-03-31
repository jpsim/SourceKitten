load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "build_bazel_rules_apple",
    sha256 = "a5f00fd89eff67291f6cd3efdc8fad30f4727e6ebb90718f3f05bbf3c3dd5ed7",
    url = "https://github.com/bazelbuild/rules_apple/releases/download/0.33.0/rules_apple.0.33.0.tar.gz",
)

load(
    "@build_bazel_rules_apple//apple:repositories.bzl",
    "apple_rules_dependencies",
)

apple_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()

YAMS_GIT_SHA = "64f37c1adc741c6422e58ada688f999f48fc936f"
http_archive(
    name = "swiftsyntax_com_github_jpsim_yams",
    urls = [
        "https://github.com/jpsim/Yams/archive/%s.zip" % YAMS_GIT_SHA,
    ],
    sha256 = "aff42b7d9bcbbb7ee90dd5bef6fc302231b895635f575b23ddc9b0a11d77ec0a",
    strip_prefix = "Yams-%s" % YAMS_GIT_SHA,
)

SWXMLHASH_SHA = "6469881a3f30417c5bb02404ea4b69207f297592"
http_archive(
    name = "swiftsyntax_com_github_drmohundro_SWXMLHash",
    urls = [
        "https://github.com/drmohundro/SWXMLHash/archive/%s.zip" % SWXMLHASH_SHA,
    ],
    build_file = "SWXMLHash/BUILD",
    sha256 = "c31b0a5869bbe8844a19a29b8507ddfe95e5d8f7563e526ea698b69dfb85ca74",
    strip_prefix = "SWXMLHash-%s" % SWXMLHASH_SHA,
)

SWIFT_ARGUMENT_PARSER_VERSION = "1.0.2"
http_archive(
    name = "swiftsyntax_com_github_apple_swift_argument_parser",
    url = "https://github.com/apple/swift-argument-parser/archive/refs/tags/%s.tar.gz" % SWIFT_ARGUMENT_PARSER_VERSION,
    sha256 = "2f7f9ca756b43ea5b8c2d5efb9059294a6bbd5483055842a54d67976ef7c75df",
    build_file = "SwiftArgumentParser/BUILD",
    strip_prefix = "swift-argument-parser-%s" % SWIFT_ARGUMENT_PARSER_VERSION
)
