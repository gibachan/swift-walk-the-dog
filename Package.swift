// swift-tools-version:5.8
import PackageDescription
let package = Package(
    name: "swift-walk-the-dog",
    products: [
        .executable(name: "swift-walk-the-dog", targets: ["swift-walk-the-dog"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.15.0")
    ],
    targets: [
        .executableTarget(
            name: "swift-walk-the-dog",
            dependencies: [
                "swift-walk-the-dogLibrary",
                .product(name: "JavaScriptKit", package: "JavaScriptKit")
            ]),
        .target(
            name: "swift-walk-the-dogLibrary",
            dependencies: []),
        .testTarget(
            name: "swift-walk-the-dogLibraryTests",
            dependencies: ["swift-walk-the-dogLibrary"]),
    ]
)