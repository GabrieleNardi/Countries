// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataModel",
    platforms: [.iOS(.v26)],
    products: [
        .library(
            name: "DataModel",
            targets: ["DataModel"]
        )
    ],
    dependencies: [
        .package(
            name: "Commons",
            path: "../Commons"
        )
    ],
    targets: [
        .target(
            name: "DataModel",
            dependencies: ["Commons"]
        ),
        .testTarget(
            name: "DataModelTests",
            dependencies: ["DataModel"]
        )
    ]
)
