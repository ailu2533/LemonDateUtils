// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LemonDateUtils",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LemonDateUtils",
            targets: ["LemonDateUtils"])
    ],
    dependencies: [
        .package(url: "https://github.com/melvitax/DateHelper", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.55.1")

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LemonDateUtils",
            dependencies: [
                .product(name: "DateHelper", package: "DateHelper")
            ], plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]

        ),
        .testTarget(
            name: "LemonDateUtilsTests",
            dependencies: ["LemonDateUtils"])
    ]
)
