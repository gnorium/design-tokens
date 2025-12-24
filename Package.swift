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
        .package(url: "https://github.com/gnorium/web-builders", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "DesignTokens",
            dependencies: [
                .product(name: "WebBuilders", package: "web-builders")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
                .enableUpcomingFeature("ConciseMagicFile"),
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("ForwardTrailingClosures"),
                .enableUpcomingFeature("ImplicitOpenExistentials"),
                .enableUpcomingFeature("StrictConcurrency"),
                .unsafeFlags(["-warn-concurrency"], .when(configuration: .debug)),
            ]
        ),
        .testTarget(
            name: "DesignTokensTests",
            dependencies: ["DesignTokens"]
        ),
    ]
)
