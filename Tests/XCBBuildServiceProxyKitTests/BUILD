load("@build_bazel_rules_apple//apple:macos.bzl", "macos_unit_test")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "XCBBuildServiceProxyKitTests.library",
    testonly = True,
    srcs = glob(["**/*.swift"]),
    module_name = "tests",
    tags = ["manual"],
    deps = [
        "//Sources/XCBBuildServiceProxyKit",
    ],
)

macos_unit_test(
    name = "XCBBuildServiceProxyKitTests",
    minimum_os_version = "12.0",
    visibility = ["@rules_xcodeproj//xcodeproj:generated"],
    deps = [
        ":XCBBuildServiceProxyKitTests.library",
    ],
)
