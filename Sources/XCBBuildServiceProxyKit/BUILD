load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "XCBBuildServiceProxyKit",
    srcs = glob(["**/*.swift"]),
    module_name = "XCBBuildServiceProxyKit",
    deps = [
        "//Sources/XCBProtocol",
        "@com_github_apple_swift_log//:Logging",
        "@com_github_apple_swift_nio//:NIO",
    ],
    visibility = ["//visibility:public"],
)
