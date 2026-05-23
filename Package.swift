// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "HayBTechSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "HayBTechSDK",
            targets: ["HayBTechSDK"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HayBTechSDK",
            dependencies: [],
            path: "Sources/HayBTechSDK"),
        .testTarget(
            name: "HayBTechSDKTests",
            dependencies: ["HayBTechSDK"]),
    ]
)
