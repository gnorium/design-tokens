// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DesignTokens",
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
        .package(url: "https://github.com/gnorium/web-formats", branch: "main")
    ],
    targets: [
        .target(
            name: "DesignTokens",
            dependencies: [
                .product(name: "CSSBuilder", package: "web-builders"),
                .product(name: "JSONFormat", package: "web-formats")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImplicitOpenExistentials"),
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "DesignTokensTests",
            dependencies: ["DesignTokens"]
        ),
    ]
)
