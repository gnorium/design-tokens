// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "design-tokens",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .watchOS(.v10),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "DesignTokens",
            targets: ["DesignTokens"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/gnorium/web-builders", branch: "main"),
        .package(url: "https://github.com/gnorium/web-types", branch: "main")
    ],
    targets: [
        .target(
            name: "DesignTokens",
            dependencies: [
                .product(name: "CSSBuilder", package: "web-builders"),
                .product(name: "WebTypes", package: "web-types")
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded", .when(platforms: [.wasi])),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("StrictConcurrency"),
                .define("CLIENT", .when(platforms: [.wasi])),
                .define("SERVER", .when(platforms: [.macOS, .linux, .windows]))
            ]
        )
    ]
)
