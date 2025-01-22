// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeystoneSDK",
    platforms: [.iOS(.v15), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KeystoneSDK",
            targets: ["KeystoneSDK"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/BlockchainCommons/URKit", from: "15.0.0")
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
            url: "https://github.com/KeystoneHQ/keystone-sdk-rust/releases/download/sdk-0.2.3/URRegistryFFI.xcframework.zip",
            checksum: "5cfeb76962d2727824e65ebc4829a0e5e96013d1c71b5c49b8025a1634f8d442"
        ),
        .testTarget(
            name: "KeystoneSDKTests",
            dependencies: ["KeystoneSDK"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
