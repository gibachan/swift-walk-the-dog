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
              .copy("Resources/styles.css"),
              .copy("Resources/Button.svg"),
              .copy("Resources/kenney_future_narrow-webfont.woff2"),
              .copy("Resources/Idle (1).png"),
              .copy("Resources/rhb.png"),
              .copy("Resources/rhb.json"),
              .copy("Resources/BG.png"),
              .copy("Resources/Stone.png"),
              .copy("Resources/tiles.png"),
              .copy("Resources/tiles.json"),
              .copy("Resources/background_song.mp3"),
              .copy("Resources/SFX_Jump_23.mp3"),
            ]
        ),
        .target(
            name: "SwiftWalkTheDogLibrary",
            dependencies: [
              "Game",
              "Engine",
              "Sound",
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
              "Sound",
              .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]),
        .target(
            name: "Browser",
            dependencies: [
              .product(name: "JavaScriptKit", package: "JavaScriptKit"),
              .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ]),
        .target(
            name: "Sound",
            dependencies: [
              .product(name: "JavaScriptKit", package: "JavaScriptKit"),
              .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ]),
        .testTarget(
            name: "SwiftWalkTheDogLibraryTests",
            dependencies: [
              "SwiftWalkTheDogLibrary"
            ]),
    ]
)
