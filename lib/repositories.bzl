"""Definitions for handling Bazel repositories used by XCBBuildServiceProxyKit."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//lib/internal:logging.bzl", "green", "warn", "yellow")

def _maybe(repo_rule, name, ignore_version_differences, **kwargs):
    """Executes the given repository rule if it hasn't been executed already.

    Args:
        repo_rule: The repository rule to be executed (e.g., `http_archive`.)
        name: The name of the repository to be defined by the rule.
        ignore_version_differences: If `True`, warnings about potentially
            incompatible versions of depended-upon repositories will be
            silenced.
        **kwargs: Additional arguments passed directly to the repository rule.
    """
    if native.existing_rule(name):
        if not ignore_version_differences:
            # Verify that the repository is being loaded from the same URL and
            # tag that we asked for, and warn if they differ.
            # This isn't perfect, because the user could load from the same
            # commit SHA as the tag, or load from an HTTP archive instead of a
            # Git repository, but this is a good first step toward validating.
            # Bzlmod will remove the need for all of this in the longer term.
            existing_repo = native.existing_rule(name)
            if (existing_repo.get("remote") != kwargs.get("remote") or
                existing_repo.get("tag") != kwargs.get("tag")):
                expected = "{url} (tag {tag})".format(
                    tag = kwargs.get("tag"),
                    url = kwargs.get("remote"),
                )
                existing = "{url} (tag {tag})".format(
                    tag = existing_repo.get("tag"),
                    url = existing_repo.get("remote"),
                )

                warn("""\
`xcbbuildserviceproxy` depends on `{repo}` loaded from {expected}, but we have \
detected it already loaded into your workspace from {existing}. You may run \
into compatibility issues. To silence this warning, pass \
`ignore_version_differences = True` to \
`xcbbuildserviceproxy_rules_dependencies()`.
""".format(
                    existing = yellow(existing),
                    expected = green(expected),
                    repo = name,
                ))
        return

    repo_rule(name = name, **kwargs)

# buildifier: disable=unnamed-macro
def xcbbuildserviceproxy_rules_dependencies(
        ignore_version_differences = False,
        include_bzlmod_ready_dependencies = True):
    """Fetches repositories that are dependencies of XCBBuildServiceProxyKit.

    Users should call this macro in their `WORKSPACE` to ensure that all of the
    dependencies of XCBBuildServiceProxyKit are downloaded and that they are
    isolated from changes to those dependencies.

    Args:
        ignore_version_differences: If `True`, warnings about potentially
            incompatible versions of dependency repositories will be silenced.
        include_bzlmod_ready_dependencies: Whether or not bzlmod-ready
            dependencies should be included.
    """
    if include_bzlmod_ready_dependencies:
        _maybe(
            http_archive,
            name = "build_bazel_rules_swift",
            sha256 = "84e2cc1c9e3593ae2c0aa4c773bceeb63c2d04c02a74a6e30c1961684d235593",
            url = "https://github.com/bazelbuild/rules_swift/releases/download/1.5.1/rules_swift.1.5.1.tar.gz",
            ignore_version_differences = ignore_version_differences,
        )

        is_bazel_6 = hasattr(apple_common, "link_multi_arch_static_library")
        if is_bazel_6:
            rules_apple_sha256 = "43737f28a578d8d8d7ab7df2fb80225a6b23b9af9655fcdc66ae38eb2abcf2ed"
            rules_apple_version = "2.0.0"
        else:
            rules_apple_sha256 = "f94e6dddf74739ef5cb30f000e13a2a613f6ebfa5e63588305a71fce8a8a9911"
            rules_apple_version = "1.1.3"

        _maybe(
            http_archive,
            name = "build_bazel_rules_apple",
            sha256 = rules_apple_sha256,
            url = "https://github.com/bazelbuild/rules_apple/releases/download/{version}/rules_apple.{version}.tar.gz".format(version = rules_apple_version),
            ignore_version_differences = ignore_version_differences,
        )

        _maybe(
            http_archive,
            name = "com_github_buildbuddy_io_rules_xcodeproj",
            sha256 = "1e2f40eaee520093343528ac9a4a9180b0500cdd83b1e5e2a95abc8c541686e2",
            url = "https://github.com/buildbuddy-io/rules_xcodeproj/releases/download/1.1.0/release.tar.gz",
            ignore_version_differences = ignore_version_differences,
        )

    _maybe(
        http_archive,
        name = "com_github_apple_swift_collections",
        build_file_content = """\
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Collections",
    srcs = glob(["Sources/Collections/**/*.swift"]),
    visibility = ["//visibility:public"],
)

swift_library(
    name = "DequeModule",
    srcs = glob(["Sources/DequeModule/**/*.swift"]),
    visibility = ["//visibility:public"],
)

swift_library(
    name = "OrderedCollections",
    srcs = glob(["Sources/OrderedCollections/**/*.swift"]),
    visibility = ["//visibility:public"],
)
""",
        sha256 = "b18c522aff4241160f60bcd0695702657c7862512c994c260a7d63f15a8450d8",
        strip_prefix = "swift-collections-1.0.2",
        url = "https://github.com/apple/swift-collections/archive/refs/tags/1.0.2.tar.gz",
        ignore_version_differences = ignore_version_differences,
    )
