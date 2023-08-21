// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeystoneSDK",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KeystoneSDK",
            targets: ["KeystoneSDK"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/KeystoneHQ/URKit.git", from: "10.1.0")
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
            url: "https://github.com/KeystoneHQ/keystone-sdk-rust/releases/download/sdk-0.1.2/URRegistryFFI.xcframework.zip",
            checksum: "b47c33541e28de32ba8d3fd6c4115157f94ae38f29ad1ed1c4d0d66eb2578b77"
        ),
        .testTarget(
            name: "KeystoneSDKTests",
            dependencies: ["KeystoneSDK"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
