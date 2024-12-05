// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-sdk",
    platforms: [
        .iOS(.v17) // Minimum iOS version requirement
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "swift-sdk",
            type: .dynamic,
            targets: ["swift-sdk"]),
    ],
    targets: [
        .target(
            name: "swift-sdk"
        )
    ]
)
