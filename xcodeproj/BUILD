load(
    "@rules_xcodeproj//xcodeproj:defs.bzl",
    "xcode_schemes",
    "xcodeproj",
)

xcodeproj(
    name = "xcodeproj",
    install_directory = "",
    project_name = "XCBBuildServiceProxyKit",
    schemes = [
        xcode_schemes.scheme(
            name = "XCBBuildServiceProxyKit",
            build_action = xcode_schemes.build_action(
                targets = [
                    "//Sources/XCBBuildServiceProxyKit",
                ],
            ),
            test_action = xcode_schemes.test_action(
                [
                    "//Tests/XCBBuildServiceProxyKitTests",
                    "//Tests/XCBProtocolTests",
                ],
                diagnostics = xcode_schemes.diagnostics(
                    sanitizers = xcode_schemes.sanitizers(
                        thread = True,
                    ),
                ),
            ),
        ),
    ],
    tags = ["manual"],
    top_level_targets = [
        "//Tests/XCBBuildServiceProxyKitTests",
        "//Tests/XCBProtocolTests",
    ],
)
