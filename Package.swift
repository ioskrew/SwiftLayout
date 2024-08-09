// swift-tools-version:5.7

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
    targets: [
        .target(
            name: "SwiftLayout",
            dependencies: []
        ),
        .testTarget(
            name: "SwiftLayoutTests",
            dependencies: [
                "SwiftLayout"
            ]
        )
    ]
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
