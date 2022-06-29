load(
    "@build_bazel_rules_apple//apple:macos.bzl",
    "macos_command_line_application",
)
load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "swift_library",
)
load(
    "@com_github_buildbuddy_io_rules_xcodeproj//xcodeproj:xcodeproj.bzl",
    "xcodeproj",
)

swift_library(
    name = "BazelXCBBuildService.library",
    module_name = "BazelXCBBuildService",
    srcs = glob(["Sources/**/*.swift"]),
    deps = [
        "//BazelXCBBuildService/BEP",
        "@com_github_apple_swift_log//:Logging",
        "@com_github_apple_swift_nio//:NIO",
        "@com_github_mobilenativefoundation_xcbbuildserviceproxykit//:XCBBuildServiceProxyKit",
        "@com_github_mobilenativefoundation_xcbbuildserviceproxykit//:XCBProtocol",
        "@com_github_mobilenativefoundation_xcbbuildserviceproxykit//:XCBProtocol_12_0",
    ],
)

macos_command_line_application(
    name = "BazelXCBBuildService",
    minimum_os_version = "11.0",
    deps = [":BazelXCBBuildService.library"],
)

xcodeproj(
    name = "xcodeproj",
    project_name = "BazelXCBuildService",
    targets = [
        ":BazelXCBBuildService",
    ],
    tags = ["manual"],
)

sh_test(
    name = "BazelXCBBuildServiceIntegrationTests",
    size = "small",
    srcs = ["integration_tests.sh"],
    data = [
        ":BazelXCBBuildService",
    ],
    deps = ["@bazel_tools//tools/bash/runfiles"],
)

sh_test(
    name = "write_shim_tests",
    size = "small",
    srcs = ["write_shim_tests.sh"],
    data = [
        "write_shim.sh",
    ],
    deps = ["@bazel_tools//tools/bash/runfiles"],
)
