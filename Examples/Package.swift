// swift-tools-version: 5.9
import PackageDescription

let package = Package(name: "Examples")

package.platforms = [
    .macOS(.v13),
]

package.dependencies = [
    .package(name: "SurrealClient", path: "../")
]

package.targets = [
    .executableTarget(name: "ExampleServerWithSurreal", dependencies: [
        .product(name: "SurrealClient", package: "SurrealClient"),
    ])
]

package.products = [
    .executable(name: "ExampleServerWithSurreal", targets: ["ExampleServerWithSurreal"]),
]
