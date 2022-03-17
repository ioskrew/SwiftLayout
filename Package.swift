// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "SwiftLayout",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "SwiftLayout",
            targets: ["SwiftLayout"]),
        .library(
            name: "SwiftLayoutPrinter",
            targets: ["SwiftLayoutPrinter"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftLayout",
            dependencies: []),
        .target(
            name: "SwiftLayoutPrinter",
            dependencies: ["SwiftLayout"]),
        .testTarget(
            name: "SwiftLayoutTests",
            dependencies: ["SwiftLayout", "SwiftLayoutPrinter"]),
    ]
)
