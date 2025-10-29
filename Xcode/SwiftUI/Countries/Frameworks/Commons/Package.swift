// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Commons",
    platforms: [.iOS(.v26)],
    products: [
        .library(
            name: "Commons",
            targets: ["Commons"]
        ),
    ],
    targets: [
        .target(
            name: "Commons"
        ),
        .testTarget(
            name: "CommonsTests",
            dependencies: ["Commons"]
        ),
    ]
)
