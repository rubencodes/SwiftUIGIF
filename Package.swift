// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIGIF",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "SwiftUIGIF",
            targets: ["SwiftUIGIF"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftUIGIF",
            dependencies: [],
            path: "Sources",
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
