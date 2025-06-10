// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "EstimoteSDK",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "EstimoteSDK",
            targets: ["EstimoteSDK"]),
    ],
    targets: [
        .binaryTarget(
            name: "EstimoteSDK",
            url: "https://github.com/Estimote/estimote-sdk-ios/releases/download/v1.0.0-beta2/EstimoteSDK.xcframework.zip",
            checksum: "e6b2c33f789b61b815bf38b6fe5bd8770139d91bf8383f1f148358e54f1a407c"
        )
    ],
    swiftLanguageVersions: [.v5]
)
