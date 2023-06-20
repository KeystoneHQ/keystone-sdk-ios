// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeystoneSDK",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KeystoneSDK",
            targets: ["KeystoneSDK"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/BlockchainCommons/URKit", from: "10.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "KeystoneSDK",
            dependencies: ["URRegistryFFI", "URKit"]
        ),
        .binaryTarget(
            name: "URRegistryFFI",
            url: "https://github.com/KeystoneHQ/keystone-sdk-rust/releases/download/sdk-0.1.1/URRegistryFFI.xcframework.zip",
            checksum: "96feb099f86b3d9d7dac13fb5db75bef70d7b3f774fc0dbd6feba952971d0c28"
        ),
        .testTarget(
            name: "KeystoneSDKTests",
            dependencies: ["KeystoneSDK"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
