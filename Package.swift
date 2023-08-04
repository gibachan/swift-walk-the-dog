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
              .copy("Resources/rhb.json"),
              .copy("Resources/BG.png"),
              .copy("Resources/Stone.png"),
              .copy("Resources/tiles.png"),
              .copy("Resources/tiles.json"),
            ]
        ),
        .target(
            name: "SwiftWalkTheDogLibrary",
            dependencies: [
              "Game",
              "Engine",
              .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]),
        .target(
            name: "Game",
            dependencies: [
              "Engine",
              .product(name: "JavaScriptKit", package: "JavaScriptKit"),
              .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ]),
        .target(
            name: "Engine",
            dependencies: [
              "Browser",
              .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]),
        .target(
            name: "Browser",
            dependencies: [
              .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]),
        .testTarget(
            name: "SwiftWalkTheDogLibraryTests",
            dependencies: [
              "SwiftWalkTheDogLibrary"
            ]),
    ]
)
