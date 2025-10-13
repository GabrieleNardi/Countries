// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataModel",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DataModel",
            targets: ["DataModel"]
        )
    ],
    dependencies: [.package(name: "Commons", path: "../Commons")],
    targets: [
        .target(name: "DataModel", dependencies: [.product(name: "Commons", package: "Commons")]),
        .testTarget(
            name: "DataModelTests",
            dependencies: ["DataModel"],
            resources: [
                .copy("Resources/Country.json"),
                .copy("Resources/Flag.json"),
                .copy("Resources/Name.json"),
                .copy("Resources/PexelsImage.json")
            ]
        ),
    ]
)
