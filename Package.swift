// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SwiftLayout",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwiftLayout",
            targets: ["SwiftLayout"]
        ),
        .library(
            name: "SwiftLayoutUtil",
            targets: ["SwiftLayoutUtil"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftLayout",
            dependencies: [],
            swiftSettings: [.swiftLanguageVersion(.v6)]
        ),
        .target(
            name: "SwiftLayoutUtil",
            dependencies: [
                "SwiftLayout"
            ],
            swiftSettings: [.swiftLanguageVersion(.v5)]
        ),
        .testTarget(
            name: "SwiftLayoutTests",
            dependencies: [
                "SwiftLayout"
            ],
            swiftSettings: [.swiftLanguageVersion(.v6)]
        ),
        .testTarget(
            name: "SwiftLayoutUtilTests",
            dependencies: [
                "SwiftLayout",
                "SwiftLayoutUtil"
            ],
            swiftSettings: [.swiftLanguageVersion(.v5)]
        )
    ]
)
