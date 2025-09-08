// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CurlingKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14), .watchOS(.v10), .visionOS(.v1), .tvOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CurlingKit",
            targets: ["CurlingKit"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CurlingKit"//,
//            swiftSettings: [
//                .enableUpcomingFeature("StrictConcurrency")
//              ]
        ),
        .testTarget(
            name: "CurlingKitTests",
            dependencies: ["CurlingKit"]),
    ]
)
