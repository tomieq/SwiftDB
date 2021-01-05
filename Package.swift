// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwiftDB",
    products: [
        .library(
            name: "SwiftDB",
            targets: ["SwiftDB"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftDB",
            dependencies: []),
        .testTarget(
            name: "SwiftDBTests",
            dependencies: ["SwiftDB"],
            path: "Tests"
        )
    ]
)
