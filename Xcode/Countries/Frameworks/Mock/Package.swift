// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mock",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Mock",
            targets: ["Mock"]),
    ],
    dependencies: [
        .package(name: "Commons", path: "../Commons"),
        .package(name: "Core", path: "../Core"),
        .package(name: "DataModel", path: "../DataModel")
    ],
    targets: [
        .target(
            name: "Mock",
            dependencies: [
                .product(name: "Commons", package: "Commons"),
                .product(name: "Core", package: "Core"),
                .product(name: "DataModel", package: "DataModel")
            ],
            resources: [
                .copy("Resources/AllCountries.json"),
                .copy("Resources/AllPexelsImages.json")
            ]
        ),
        .testTarget(
            name: "MockTests",
            dependencies: ["Mock"]
        )
    ]
)
