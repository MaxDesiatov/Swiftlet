// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

import PackageDescription

let package = Package(
  name: "Swiftlet",
  products: [
    // Products define the executables and libraries produced by a package, and
    // make them visible to other packages.
    .executable(name: "swiftlet", targets: ["Swiftlet"]),
    .library(name: "SwiftletKit", targets: ["SwiftletKit"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(
      url: "https://github.com/JohnSundell/Splash", .branch("master")
    ),
    .package(
      url: "https://github.com/apple/swift-syntax.git", .branch("0.40200.0")
    ),
    .package(
      url: "https://github.com/MaxDesiatov/SwiftParsec", .branch("fix-products")
    ),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define
    // a module or a test suite.
    // Targets can depend on other targets in this package, and on products in
    // packages which this package depends on.
    .target(
      name: "SwiftletKit",
      dependencies: ["Splash", "SwiftSyntax", "SwiftParsec"],
      path: "Sources/SwiftletKit"
    ),
    .target(
      name: "Swiftlet",
      dependencies: ["SwiftletKit"],
      path: "Sources/Swiftlet"
    ),
    .testTarget(
      name: "SwiftletTests",
      dependencies: ["SwiftletKit"],
      path: "Tests"
    ),
  ]
)
