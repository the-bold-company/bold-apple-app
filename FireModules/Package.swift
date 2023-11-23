// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FireModules",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
    ],
    products: [
        .singleTargetLibrary("FireFeature"),
        .singleTargetLibrary("AppPlaybook"),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.3"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.53.0"),
//        .package(url: "https://github.com/hmlongco/Resolver.git", exact: "1.5.0"),
//        .package(url: "https://github.com/CombineCommunity/CombineExt.git", exact: "1.8.1"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", exact: "1.2.3"),
        .package(url: "https://github.com/playbook-ui/playbook-ios", exact: "0.3.4"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", exact: "0.52.10"),
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "FireFeature",
            dependencies: [
                "CoreUI",
                "Authentication",
//                "Combine+Ext",
//                .product(name: "Inject", package: "inject")
//                .product(name: "Resolver", package: "resolver")
            ]
        ),
        .target(
            name: "AppPlaybook",
            dependencies: [
                "Authentication",
                "CoreUI",
                .product(name: "Playbook", package: "playbook-ios"),
                .product(name: "PlaybookUI", package: "playbook-ios"),
            ]
        ),
        .testTarget(
            name: "FireFeatureTests",
            dependencies: ["FireFeature"]
        ),
        .target(
            name: "Authentication",
            dependencies: [
                "Home",
                // "Networking",
                "CoreUI",
            ]
        ),
        .target(
            name: "Home",
            dependencies: [
                "CoreUI",
            ]
        ),
//        .target(
//            name: "Networking",
//            dependencies: [
//                .product(name: "CombineMoya", package: "moya")
//            ]
//        ),
        .target(
            name: "CoreUI",
            dependencies: [
                .product(name: "Inject", package: "inject"),
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ],
            resources: [
                .process("Assets/Fonts"),
            ]
        ),
//        .target(
//            name: "DI",
//            dependencies: [
//                .product(name: "Resolver", package: "resolver"),
//            ]
//        ),
//        .target(
//            name: "Combine+Ext",
//            dependencies: [
//                .product(name: "CombineExt", package: "combineext"),
//            ]
//        ),
    ]
)

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}

package.targets = package.targets.map { target in
    var plugins = target.plugins ?? []
    plugins.append(.plugin(name: "SwiftLintPlugin", package: "SwiftLint"))
    target.plugins = plugins
    return target
}
