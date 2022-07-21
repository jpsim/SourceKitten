load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def sourcekitten_repos():
    """Fetches SourceKitten repositories"""
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
        url = "https://github.com/drmohundro/SWXMLHash/archive/refs/tags/%s.tar.gz" % SWXMLHASH_VERSION,
        build_file = "@com_github_jpsim_sourcekitten//bazel:SWXMLHash.BUILD",
        sha256 = "bafa037a09aa296f180e5613206748db5053b79aa09258c78d093ae9f8102a18",
        strip_prefix = "SWXMLHash-%s" % SWXMLHASH_VERSION,
    )

    SWIFT_ARGUMENT_PARSER_VERSION = "1.1.3"
    http_archive(
        name = "sourcekitten_com_github_apple_swift_argument_parser",
        url = "https://github.com/apple/swift-argument-parser/archive/refs/tags/%s.tar.gz" % SWIFT_ARGUMENT_PARSER_VERSION,
        sha256 = "e52c0ac4e17cfad9f13f87a63ddc850805695e17e98bf798cce85144764cdcaa",
        build_file = "@com_github_jpsim_sourcekitten//bazel:SwiftArgumentParser.BUILD",
        strip_prefix = "swift-argument-parser-%s" % SWIFT_ARGUMENT_PARSER_VERSION,
    )
