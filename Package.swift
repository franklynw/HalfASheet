// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HalfASheet",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "HalfASheet",
            targets: ["HalfASheet"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HalfASheet",
            dependencies: []),
        .testTarget(
            name: "HalfASheetTests",
            dependencies: ["HalfASheet"]),
    ]
)
