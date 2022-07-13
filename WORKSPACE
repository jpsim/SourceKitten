load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "build_bazel_rules_apple",
    sha256 = "36072d4f3614d309d6a703da0dfe48684ec4c65a89611aeb9590b45af7a3e592",
    url = "https://github.com/bazelbuild/rules_apple/releases/download/1.0.1/rules_apple.1.0.1.tar.gz",
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

YAMS_VERSION = "5.0.1"
http_archive(
    name = "sourcekitten_com_github_jpsim_yams",
    url = "https://github.com/jpsim/Yams/archive/refs/tags/%s.tar.gz" % YAMS_VERSION,
    sha256 = "ec1ad699c30f0db45520006c63a88cc1c946a7d7b36dff32a96460388c0a4af2",
    strip_prefix = "Yams-%s" % YAMS_VERSION,
)

SWXMLHASH_VERSION = "7.0.1"
http_archive(
    name = "sourcekitten_com_github_drmohundro_SWXMLHash",
    url = "https://github.com/drmohundro/SWXMLHash/archive/%s.zip" % SWXMLHASH_VERSION,
    build_file = "SWXMLHash/BUILD",
    sha256 = "5f297bb105cd432cdf3f018cd733ea8be7b0fbd2dd7435aac5555cbafed4f7d1",
    strip_prefix = "SWXMLHash-%s" % SWXMLHASH_VERSION,
)

SWIFT_ARGUMENT_PARSER_VERSION = "1.1.3"
http_archive(
    name = "sourcekitten_com_github_apple_swift_argument_parser",
    url = "https://github.com/apple/swift-argument-parser/archive/refs/tags/%s.tar.gz" % SWIFT_ARGUMENT_PARSER_VERSION,
    sha256 = "e52c0ac4e17cfad9f13f87a63ddc850805695e17e98bf798cce85144764cdcaa",
    build_file = "SwiftArgumentParser/BUILD",
    strip_prefix = "swift-argument-parser-%s" % SWIFT_ARGUMENT_PARSER_VERSION
)
