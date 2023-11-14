// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Main",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .singleTargetLibrary("FireFeature"),
        .singleTargetLibrary("AppPlaybook")
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.3"),
        .package(url: "https://github.com/hmlongco/Resolver.git", exact: "1.5.0"),
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", exact: "1.8.1"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", exact: "1.2.3"),
        .package(url: "https://github.com/playbook-ui/playbook-ios", exact: "0.3.4"),
    ],
    targets: [
        .target(
            name: "FireFeature",
            dependencies: [
                "CoreUI",
                "Authentication",
//                .product(name: "Inject", package: "inject")
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
            dependencies: ["FireFeature"]),
        .target(
            name: "Authentication",
            dependencies: [
                "Networking",
                "CoreUI"
            ]),
        .target(
            name: "Networking",
            dependencies: [
                .product(name: "CombineMoya", package: "moya")
            ]),
//        .target(
//            name: "DI",
//            dependencies: [
//                .product(name: "Resolver", package: "resolver")
//            ]),
//        .target(
//            name: "Combine+Ext",
//            dependencies: [
//                .product(name: "CombineExt", package: "combineext")
//            ]),
        .target(
            name: "CoreUI",
            dependencies: [
                .product(name: "Inject", package: "inject")
            ]),
    ]
)

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}
