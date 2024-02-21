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
        .singleTargetLibrary("Intents"),
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
        .package(url: "https://github.com/krzysztofzablocki/AutomaticSettings", exact: "1.1.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.2.0"),
        .package(url: "https://github.com/realm/realm-swift.git", exact: "10.47.0"),
        .package(url: "https://github.com/krzysztofzablocki/Difference.git", exact: "1.0.2"),
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
        .target(
            name: "Intents",
            dependencies: [
                "PersistentService",
                "TransactionsService",
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            path: "Sources/App/Intents"
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
                "SettingsFeature",
                .product(name: "TCACoordinators", package: "TCACoordinators"),
                .product(name: "Codextended", package: "codextended"),
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
                "DevSettingsUseCases",
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
                "CurrencyKit",
                "FundFeature",
                "LoggedInUserService",
                "TransactionsService",
                "FundsService",
                "PersistentService",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Features/HomeFeature"
        ),
        .target(
            name: "FundFeature",
            dependencies: [
                "CoreUI",
                "CurrencyKit",
                "RecordTransactionFeature",
                "FundsService",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Features/FundFeature"
        ),
        .target(
            name: "RecordTransactionFeature",
            dependencies: [
                "CoreUI",
                "CurrencyKit",
                "TransactionsService",
                "LoggedInUserService",
                "PersistentService",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/Features/RecordTransactionFeature"
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "CoreUI",
                "SharedModels",
                "DevSettingsUseCases",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "AutomaticSettings", package: "automaticsettings"),
            ],
            path: "Sources/Features/SettingsFeature"
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
                "SharedModels",
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
        .target(
            name: "TestHelpers",
            dependencies: [
                .product(name: "Difference", package: "difference"),
            ],
            path: "Sources/Shared/Kits/TestHelpers"
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                .product(name: "AutomaticSettings", package: "automaticsettings"),
            ],
            path: "Sources/Shared/SharedModels"
        ),

        // MARK: - Use cases

        .target(
            name: "KeychainStorageUseCases",
            dependencies: [
                .product(name: "SwiftKeychainWrapper", package: "swiftkeychainwrapper"),
            ],
            path: "Sources/UseCases/KeychainStorageUseCases"
        ),
        .target(
            name: "DevSettingsUseCases",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Codextended", package: "codextended"),
            ],
            path: "Sources/UseCases/DevSettingsUseCases"
        ),
        .target(
            name: "LoggedInUserService",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            path: "Sources/UseCases/LoggedInUserService"
        ),
        .target(
            name: "TransactionsService",
            dependencies: [
                "SharedModels",
                "Networking",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            path: "Sources/UseCases/TransactionsService"
        ),
        .target(
            name: "FundsService",
            dependencies: [
                "SharedModels",
                "Networking",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ],
            path: "Sources/UseCases/FundsService"
        ),
        .target(
            name: "PersistentService",
            dependencies: [
                "SharedModels",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "RealmSwift", package: "realm-swift"),
            ],
            path: "Sources/UseCases/PersistentService"
        ),

        // MARK: Test targets

        .testTarget(
            name: "LogInFeatureTests",
            dependencies: [
                "LogInFeature",
                "TestHelpers",
            ]
            // exclude: ["__Snapshots__"]
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
