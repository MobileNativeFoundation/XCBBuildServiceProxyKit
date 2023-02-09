load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "XCBProtocol",
    srcs = glob(["**/*.swift"]),
    module_name = "XCBProtocol",
    tags = ["manual"],
    visibility = ["//:__subpackages__"],
    deps = [
        "@com_github_apple_swift_collections//:OrderedCollections",
    ],
)
