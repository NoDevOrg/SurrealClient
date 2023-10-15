// swift-tools-version: 5.8
import PackageDescription

let package = Package(name: "SurrealClient")

package.platforms = [
    .macOS(.v13),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
]

package.dependencies = [
    .package(url: "https://github.com/vapor/vapor", from: "4.0.0"),
]

package.targets = [
    .target(name: "SurrealClient", dependencies: [
        .product(name: "Vapor", package: "vapor"),
    ]),
]

package.products = [
    .library(name: "SurrealClient", targets: ["SurrealClient"]),
]
