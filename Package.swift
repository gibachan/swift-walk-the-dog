// swift-tools-version:5.8
import PackageDescription
let package = Package(
    name: "swift-walk-the-dog",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "SwiftWalkTheDog", targets: ["SwiftWalkTheDog"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.18.0")
    ],
    targets: [
        .executableTarget(
            name: "SwiftWalkTheDog",
            dependencies: [
                "SwiftWalkTheDogLibrary",
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit")
            ],
            resources: [
              .copy("Resources/Idle (1).png"),
              .copy("Resources/rhb.png"),
              .copy("Resources/rhb.json")
            ]
        ),
        .target(
            name: "SwiftWalkTheDogLibrary",
            dependencies: [
              .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]),
        .testTarget(
            name: "SwiftWalkTheDogLibraryTests",
            dependencies: ["SwiftWalkTheDogLibrary"]),
    ]
)
