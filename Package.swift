// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "tetrominos",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/michaelj103/TetrominoCore.git", from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "tetrominos",
            dependencies: [.product(name: "TetrominoCore", package: "TetrominoCore")]),
        .testTarget(
            name: "tetrominosTests",
            dependencies: ["tetrominos"]),
    ]
)
