// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-equatable-macro",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "Equatable",
            targets: ["Equatable"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "601.0.0-latest"),
        .package(url: "http://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.5.2")
    ],
    targets: [
        .target(
            name: "Equatable",
            dependencies: [
                "EquatableMacros"
            ]),
        .macro(
            name: "EquatableMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "IssueReporting", package: "xctest-dynamic-overlay"),
            ]
        ),
        .testTarget(
            name: "EquatableMacroTests",
            dependencies: [
                "Equatable",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
