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
            url: "https://github.com/Estimote/estimote-sdk-ios/releases/download/v1.0.0-beta/EstimoteSDK.xcframework.zip",
            checksum: "8dabf0cef406b39f42397c61b4200e47adfa92b0f7e1bfd8be699e2a462429cd"
        )
    ],
    swiftLanguageVersions: [.v5]
)
