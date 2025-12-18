// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SwiftLayout",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .visionOS(.v1)],
    products: [
        .library(
            name: "SwiftLayout",
            targets: ["SwiftLayout"]
        )
    ],
    targets: [
        .target(
            name: "SwiftLayoutPlatform",
            dependencies: []
        ),
        .target(
            name: "SwiftLayout",
            dependencies: ["SwiftLayoutPlatform"]
        ),
        .testTarget(
            name: "SwiftLayoutTests",
            dependencies: [
                "SwiftLayout"
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)

private let useSwiftLint = false

if useSwiftLint {
    package.dependencies += [
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            exact: "0.55.1"
        )
    ]
    for target in package.targets {
        target.plugins = [
            .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
        ]
    }
}
