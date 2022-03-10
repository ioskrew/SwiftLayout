// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "SwiftLayout",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwiftLayout",
            targets: ["SwiftLayout"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftLayout",
            dependencies: []),
        .testTarget(
            name: "SwiftLayoutTests",
            dependencies: ["SwiftLayout"]),
    ]
)
