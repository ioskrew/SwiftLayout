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
    dependencies: [
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            exact: "0.55.1"
        )
    ],
    targets: [
        .target(
            name: "SwiftLayout",
            dependencies: [],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(
            name: "SwiftLayoutTests",
            dependencies: [
                "SwiftLayout"
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        )
    ],
    swiftLanguageVersions: [.v6]
)
