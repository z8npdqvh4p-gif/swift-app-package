// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppPackage",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "AppCore", targets: ["AppCore"]),
        .library(name: "AppUI", targets: ["AppUI"])
    ],
    dependencies: [
        // Добавляем библиотеку для неоморфизма
        .package(url: "https://github.com/costachung/neumorphic", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "AppCore",
            dependencies: []
        ),
        .target(
            name: "AppUI",
            dependencies: [
                "AppCore",
                .product(name: "Neumorphic", package: "neumorphic")
            ]
        ),
        .testTarget(
            name: "AppCoreTests",
            dependencies: ["AppCore"]
        ),
        .testTarget(
            name: "AppUITests",
            dependencies: ["AppUI"]
        )
    ]
)
