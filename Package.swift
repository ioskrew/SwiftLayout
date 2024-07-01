// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SwiftLayout",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwiftLayout",
            targets: ["SwiftLayout"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftLayout",
            dependencies: [],
            swiftSettings: [.swiftLanguageVersion(.v6)]
        ),
        .testTarget(
            name: "SwiftLayoutTests",
            dependencies: [
                "SwiftLayout"
            ]
            swiftSettings: [.swiftLanguageVersion(.v6)]
        )
    ]
)
