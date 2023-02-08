// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "XCBBuildServiceProxyKit",
    products: [
        .library(
            name: "XCBProtocol",
            targets: ["XCBProtocol"]
        ),
        .library(
            name: "XCBBuildServiceProxyKit",
            targets: ["XCBBuildServiceProxyKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "XCBProtocol",
            dependencies: [],
            exclude: ["BUILD"]
        ),
        .testTarget(
            name: "XCBProtocolTests",
            dependencies: ["XCBProtocol"],
            exclude: ["BUILD"]
        ),
        .target(
            name: "XCBBuildServiceProxyKit",
            dependencies: ["XCBProtocol"],
            exclude: ["BUILD"]
        ),
        .testTarget(
            name: "XCBBuildServiceProxyKitTests",
            dependencies: ["XCBBuildServiceProxyKit"],
            exclude: ["BUILD"]
        ),
    ]
)
