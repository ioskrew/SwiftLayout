// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "SwiftLayout",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "_SwiftLayoutUtil",
            targets: ["_SwiftLayoutUtil"]
        ),
        .library(
            name: "SwiftLayout",
            targets: ["SwiftLayout"]
        ),
        .library(
            name: "SwiftLayoutPrinter",
            targets: ["SwiftLayoutPrinter"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "_SwiftLayoutUtil",
            dependencies: []
        ),
        .target(
            name: "SwiftLayout",
            dependencies: [
                "_SwiftLayoutUtil"
            ]
        ),
        .target(
            name: "SwiftLayoutPrinter",
            dependencies: [
                "_SwiftLayoutUtil"
            ]
        ),
        .testTarget(
            name: "SwiftLayoutTests",
            dependencies: [
                "SwiftLayout",
                "SwiftLayoutPrinter"
            ]
        )
    ]
)
