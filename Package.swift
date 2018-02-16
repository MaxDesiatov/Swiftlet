// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sparrow",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "sparrow", targets: ["Sparrow"]),
        .library(
            name: "Sparrow",
            targets: ["Sparrow"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/llvm-swift/LLVMSwift", .branch("master")),
        .package(url: "https://github.com/davedufresne/SwiftParsec", from: "3.0.0"),
        .package(url: "https://github.com/Zewo/Venice.git", from: "0.20.0"),
        .package(url: "https://github.com/SwiftStudies/OysterKit.git", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Sparrow",
            dependencies: ["Venice"]),
        .testTarget(
            name: "SparrowTests",
            dependencies: ["Sparrow"]),
    ]
)
