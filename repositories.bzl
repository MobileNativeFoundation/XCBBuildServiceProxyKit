"""Definitions for handling Bazel repositories used by the
XCBBuildServiceProxyKit rules."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

# Make sure to update the versions used in the `Package.swift` file if you
# change them here

def xcbbuildserviceproxykit_dependencies():
    "Fetches repositories that are dependencies of `XCBBuildServiceProxyKit`."
    maybe(
        http_archive,
        name = "build_bazel_rules_swift",
        sha256 = "a2fd565e527f83fb3f9eb07eb9737240e668c9242d3bc318712efa54a7deda97",
        url = "https://github.com/bazelbuild/rules_swift/releases/download/0.27.0/rules_swift.0.27.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "com_github_apple_swift_log",
        build_file_content = """\
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Logging",
    srcs = glob(["Sources/Logging/**/*.swift"]),
    visibility = ["//visibility:public"],
)
""",
        sha256 = "de51662b35f47764b6e12e9f1d43e7de28f6dd64f05bc30a318cf978cf3bc473",
        strip_prefix = "swift-log-1.4.2",
        urls = [
            "https://github.com/apple/swift-log/archive/1.4.2.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "com_github_apple_swift_nio",
        build_file_content = """\
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "NIO",
    srcs = glob(["Sources/NIO/**/*.swift"]),
    visibility = ["//visibility:public"],
    deps = [
        ":NIOCore",
        ":NIOEmbedded",
        ":NIOPosix",
    ],
)

swift_library(
    name = "NIOCore",
    srcs = glob(["Sources/NIOCore/**/*.swift"]),
    deps = [
        ":CNIOLinux",
        ":NIOConcurrencyHelpers",
    ],
)

swift_library(
    name = "NIOEmbedded",
    srcs = glob(["Sources/NIOEmbedded/**/*.swift"]),
    deps = [
        ":NIOCore",
        ":_NIODataStructures",
    ],
)

swift_library(
    name = "NIOPosix",
    srcs = glob(["Sources/NIOPosix/**/*.swift"]),
    visibility = ["//visibility:public"],
    deps = [
        ":CNIOLinux",
        ":CNIODarwin",
        ":NIOConcurrencyHelpers",
        ":NIOCore",
        ":_NIODataStructures",
    ],
)

swift_library(
    name = "NIOConcurrencyHelpers",
    srcs = glob(["Sources/NIOConcurrencyHelpers/**/*.swift"]),
    deps = [
        ":CNIOAtomics",
    ],
)

swift_library(
    name = "_NIODataStructures",
    srcs = glob(["Sources/_NIODataStructures/**/*.swift"]),
)

cc_library(
    name = "CNIOAtomics",
    srcs = glob([
        "Sources/CNIOAtomics/src/**/*.c",
        "Sources/CNIOAtomics/src/**/*.h",
    ]),
    hdrs = glob([
        "Sources/CNIOAtomics/include/**/*.h",
    ]),
    includes = ["Sources/CNIOAtomics/include"],
    tags = ["swift_module"],
)

cc_library(
    name = "CNIODarwin",
    local_defines = ["__APPLE_USE_RFC_3542"],
    srcs = glob([
        "Sources/CNIODarwin/**/*.c",
    ]),
    hdrs = glob([
        "Sources/CNIODarwin/include/**/*.h",
    ]),
    includes = ["Sources/CNIODarwin/include"],
    tags = ["swift_module"],
)

cc_library(
    name = "CNIOLinux",
    srcs = glob([
        "Sources/CNIOLinux/**/*.c",
    ]),
    hdrs = glob([
        "Sources/CNIOLinux/include/**/*.h",
    ]),
    includes = ["Sources/CNIOLinux/include"],
    tags = ["swift_module"],
)
""",
        sha256 = "fd0418e9cc64d5c05012b37147c819978ac162c5ec7aa874a488846f6b3a90e6",
        strip_prefix = "swift-nio-2.40.0",
        urls = [
            "https://github.com/apple/swift-nio/archive/2.40.0.tar.gz",
        ],
    )
