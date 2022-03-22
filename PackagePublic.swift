// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "SwiftLayout",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SwiftLayout",
            targets: ["SwiftLayout"]),
        .library(
            name: "SwiftLayoutFramework",
            targets: ["SwiftLayoutFramework"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftLayout",
            dependencies: []),
        .binaryTarget(name: "SwiftLayoutFramework",
                      path: "Binary/SwiftLayoutFramework.xcframework"),
        .testTarget(
            name: "SwiftLayoutTests",
            dependencies: ["SwiftLayout"],
            resources: [.process("Resources/XibView.xib")]),
    ]
)
