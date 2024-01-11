// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FireModules",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .singleTargetLibrary("App"),
        .singleTargetLibrary("AppPlaybook"),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.3"),
        .package(url: "https://github.com/realm/SwiftLint.git", exact: "0.53.0"),
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", exact: "1.8.1"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", exact: "1.2.3"),
        .package(url: "https://github.com/playbook-ui/playbook-ios", exact: "0.3.4"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", exact: "0.52.10"),
        .package(url: "https://github.com/siteline/swiftui-introspect", exact: "1.0.0"),
        .package(url: "https://github.com/JohnSundell/Codextended.git", exact: "0.3.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.5.0"),
        .package(url: "https://github.com/johnpatrickmorgan/TCACoordinators.git", exact: "0.8.0"),
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper.git", exact: "4.0.1"),
    ],
    targets: [
        // MARK: - App Layer: Where all modules come together

        .target(
            name: "App",
            dependencies: [
                "Coordinator",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "TCACoordinators", package: "TCACoordinators"),
            ],
            path: "Sources/App/App"
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["App"]
        ),
        .target(
            name: "AppPlaybook",
            dependencies: [
                "CoreUI",
                "HomeFeature",
                "LogInFeature",
                "SignUpFeature",
                "OnboardingFeature",
                .product(name: "Playbook", package: "playbook-ios"),
                .product(name: "PlaybookUI", package: "playbook-ios"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/App/AppPlaybook"
        ),

        // MARK: - Coordinator Layer: This layer orchestrates navigation and rounting between features

        .target(
            name: "Coordinator",
            dependencies: [
                "HomeFeature",
                "LogInFeature",
                "SignUpFeature",
                "OnboardingFeature",
                "KeychainStorageUseCases",
                .product(name: "TCACoordinators", package: "TCACoordinators"),
            ]
        ),

        // MARK: - Features Layer: Each feature is independent from each other

        .target(
            name: "OnboardingFeature",
            dependencies: [
                "CoreUI",
                "Utilities",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Features/OnboardingFeature"
        ),
        .target(
            name: "LogInFeature",
            dependencies: [
                "CoreUI",
                "Utilities",
                "Networking",
                "KeychainStorageUseCases",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Features/LogInFeature"
        ),
        .target(
            name: "SignUpFeature",
            dependencies: [
                "CoreUI",
                "Networking",
                "Utilities",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Features/SignUpFeature"
        ),
        .target(
            name: "HomeFeature",
            dependencies: [
                "CoreUI",
                "Networking",
                "CurrencyKit",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Features/HomeFeature"
        ),

        // MARK: - Shared Layer: Everything that is shared between feature modules

        .target(
            name: "Utilities",
            path: "Sources/Shared/Utilities"
        ),
        .target(
            name: "CoreUI",
            dependencies: [
                .product(name: "Inject", package: "inject"),
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect"),
            ],
            path: "Sources/Shared/CoreUI",
            resources: [
                .process("Assets"),
                .process("CodeGen/Templates"),
            ]
        ),
        .target(
            name: "Networking",
            dependencies: [
                "Utilities",
                "KeychainStorageUseCases",
                .product(name: "CombineMoya", package: "moya"),
                .product(name: "Codextended", package: "codextended"),
                .product(name: "CombineExt", package: "combineext"),
            ],
            path: "Sources/Shared/Networking"
        ),
        .target(
            name: "CurrencyKit",
            path: "Sources/Shared/Kits/CurrencyKit"
        ),

        // MARK: - Use cases

        .target(
            name: "KeychainStorageUseCases",
            dependencies: [
                .product(name: "SwiftKeychainWrapper", package: "swiftkeychainwrapper"),
            ],
            path: "Sources/UseCases/KeychainStorageUseCases"
        ),
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
