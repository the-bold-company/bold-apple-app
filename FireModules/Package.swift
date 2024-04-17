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
        .singleTargetLibrary("MiniApp"),
        .singleTargetLibrary("Intents"),
        .singleTargetLibrary("AppPlaybook"),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.3"),
//        .package(url: "https://github.com/realm/SwiftLint.git", exact: "0.53.0"),
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
        .package(url: "https://github.com/realm/realm-swift.git", exact: "10.47.0"),
        .package(url: "https://github.com/krzysztofzablocki/Difference.git", exact: "1.0.2"),
        .package(url: "https://github.com/hmlongco/Factory.git", exact: "2.3.1"),
        .package(url: "https://github.com/pointfreeco/swift-overture", exact: "0.5.0"),
    ],
    targets: [
        // MARK: - App Layer: Where all modules come together

        .target(
            name: "App",
            dependencies: [
                "Coordinator",
                "DI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "TCACoordinators", package: "TCACoordinators"),
            ],
            path: "Sources/App/App"
        ),
        .target(
            name: "MiniApp",
            dependencies: [
                "DI",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "Sources/App/MiniApp"
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
                "PersistenceService",
                "TransactionsAPIService",
                "DomainEntities",
            ],
            path: "Sources/App/Intents"
        ),

        // MARK: - Coordinator Layer: This layer orchestrates navigation and rounting between features

        .target(
            name: "DI",
            dependencies: [
                "LogInFeature",
                "FundFeature",
                "HomeFeature",
                "RecordTransactionFeature",
                "SignUpFeature",
                "OnboardingFeature",
                "SettingsFeature",
                "InvestmentFeature",

                "LogInUseCase",
                "FundDetailsUseCase",
                "FundCreationUseCase",
                "FundListUseCase",
                "TransactionRecordUseCase",
                "TransactionListUseCase",
                "AccountRegisterUseCase",
                "PortfolioUseCase",
                "DevSettingsUseCase",
                "InvestmentUseCase",
                "LiveMarketUseCase",

                "AuthAPIServiceInterface",
                "AuthAPIService",
                "KeychainServiceInterface",
                "KeychainService",
                "FundsAPIServiceInterface",
                "FundsAPIService",
                "TransactionsAPIServiceInterface",
                "TransactionsAPIService",
                "PortfolioAPIServiceInterface",
                "PortfolioAPIService",
                "TemporaryPersistenceServiceInterface",
                "TemporaryPersistenceService",
                "PersistenceServiceInterface",
                "PersistenceService",
                "InvestmentAPIServiceInterface",
                "InvestmentAPIService",
                "MarketAPIServiceInterface",
                "MarketAPIService",
                .product(name: "Factory", package: "factory"),
            ],
            path: "Sources/App/DI"
        ),

        .target(
            name: "Coordinator",
            dependencies: [
                "DI",
                "KeychainServiceInterface",
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
                "DevSettingsUseCase",
                "LogInUseCase",
                "DomainEntities",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Factory", package: "factory"),
            ],
            path: "Sources/Features/LogInFeature"
        ),
        .target(
            name: "SignUpFeature",
            dependencies: [
                "CoreUI",
                "AccountRegisterUseCase",
                "Utilities",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Factory", package: "factory"),
            ],
            path: "Sources/Features/SignUpFeature"
        ),
        .target(
            name: "HomeFeature",
            dependencies: [
                "CoreUI",
                "CurrencyKit",
                "FundFeature",
                "InvestmentFeature",
                "TransactionListUseCase",
                "FundListUseCase",
                "FundDetailsUseCase",
                "PortfolioUseCase",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Factory", package: "factory"),
            ],
            path: "Sources/Features/HomeFeature"
        ),
        .target(
            name: "FundFeature",
            dependencies: [
                "CoreUI",
                "CurrencyKit",
                "RecordTransactionFeature",
                "FundDetailsUseCase",
                "FundCreationUseCase",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Factory", package: "factory"),
            ],
            path: "Sources/Features/FundFeature"
        ),
        .target(
            name: "RecordTransactionFeature",
            dependencies: [
                "CoreUI",
                "CurrencyKit",
                "FundListUseCase",
                "TransactionRecordUseCase",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Factory", package: "factory"),
            ],
            path: "Sources/Features/RecordTransactionFeature"
        ),
        .target(
            name: "SettingsFeature",
            dependencies: [
                "CoreUI",
                "DevSettingsUseCase",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "AutomaticSettings", package: "automaticsettings"),
                .product(name: "Factory", package: "factory"),
            ],
            path: "Sources/Features/SettingsFeature"
        ),
        .target(
            name: "InvestmentFeature",
            dependencies: [
                "CoreUI",
                "CurrencyKit",
                "Utilities",
                "InvestmentUseCase",
                "LiveMarketUseCase",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Factory", package: "factory"),
            ],
            path: "Sources/Features/InvestmentFeature"
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
                "KeychainService",
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
                "DI",
                .product(name: "Difference", package: "difference"),
                .product(name: "Factory", package: "factory"),
                .product(name: "Overture", package: "swift-overture"),
            ],
            path: "Sources/Shared/Kits/TestHelpers"
        ),

        // MARK: Domains/UseCases

        .target(
            name: "DevSettingsUseCase",
            dependencies: [
                "DomainEntities",
                .product(name: "Codextended", package: "codextended"),
                .product(name: "AutomaticSettings", package: "automaticsettings"),
            ],
            path: "Sources/Domains/UseCases/DevSettingsUseCase"
        ),
        .target(
            name: "LogInUseCase",
            dependencies: [
                "DomainEntities",
                "AuthAPIServiceInterface",
                "KeychainServiceInterface",
            ],
            path: "Sources/Domains/UseCases/LogInUseCase"
        ),
        .target(
            name: "AccountRegisterUseCase",
            dependencies: [
                "DomainEntities",
                "AuthAPIServiceInterface",
                "KeychainServiceInterface",
            ],
            path: "Sources/Domains/UseCases/AccountRegisterUseCase"
        ),
        .target(
            name: "FundDetailsUseCase",
            dependencies: [
                "DomainEntities",
                "FundsAPIServiceInterface",
            ],
            path: "Sources/Domains/UseCases/FundDetailsUseCase"
        ),
        .target(
            name: "FundCreationUseCase",
            dependencies: [
                "DomainEntities",
                "FundsAPIServiceInterface",
            ],
            path: "Sources/Domains/UseCases/FundCreationUseCase"
        ),
        .target(
            name: "FundListUseCase",
            dependencies: [
                "DomainEntities",
                "FundsAPIServiceInterface",
                "TemporaryPersistenceServiceInterface",
                "PersistenceServiceInterface",
            ],
            path: "Sources/Domains/UseCases/FundListUseCase"
        ),
        .target(
            name: "TransactionListUseCase",
            dependencies: [
                "DomainEntities",
                "TransactionsAPIServiceInterface",
            ],
            path: "Sources/Domains/UseCases/TransactionListUseCase"
        ),
        .target(
            name: "TransactionRecordUseCase",
            dependencies: [
                "DomainEntities",
                "TransactionsAPIServiceInterface",
            ],
            path: "Sources/Domains/UseCases/TransactionRecordUseCase"
        ),
        .target(
            name: "PortfolioUseCase",
            dependencies: [
                "DomainEntities",
                "PortfolioAPIServiceInterface",
            ],
            path: "Sources/Domains/UseCases/PortfolioUseCase"
        ),
        .target(
            name: "InvestmentUseCase",
            dependencies: [
                "DomainEntities",
                "InvestmentAPIServiceInterface",
            ],
            path: "Sources/Domains/UseCases/InvestmentUseCase"
        ),
        .target(
            name: "LiveMarketUseCase",
            dependencies: [
                "DomainEntities",
                "MarketAPIServiceInterface",
            ],
            path: "Sources/Domains/UseCases/LiveMarketUseCase"
        ),

        // MARK: Domains/DataInterfaces

        .target(
            name: "AuthAPIServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/AuthAPIServiceInterface"
        ),
        .target(
            name: "FundsAPIServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/FundsAPIServiceInterface"
        ),
        .target(
            name: "TransactionsAPIServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/TransactionsAPIServiceInterface"
        ),
        .target(
            name: "KeychainServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/KeychainServiceInterface"
        ),
        .target(
            name: "PortfolioAPIServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/PortfolioAPIServiceInterface"
        ),
        .target(
            name: "TemporaryPersistenceServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/TemporaryPersistenceServiceInterface"
        ),
        .target(
            name: "PersistenceServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/PersistenceServiceInterface"
        ),
        .target(
            name: "UserAPIServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/UserAPIServiceInterface"
        ),
        .target(
            name: "InvestmentAPIServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/InvestmentAPIServiceInterface"
        ),
        .target(
            name: "MarketAPIServiceInterface",
            dependencies: [
                "DomainEntities",
            ],
            path: "Sources/Domains/DataInterfaces/MarketAPIServiceInterface"
        ),

        // MARK: Domains/Entities

        .target(
            name: "DomainEntities",
            dependencies: [
                "DomainUtilities",
            ],
            path: "Sources/Domains/Entities"
        ),

        .target(
            name: "DomainUtilities",
            path: "Sources/Domains/DomainUtilities"
        ),

        // MARK: Data Layer

        .target(
            name: "AuthAPIService",
            dependencies: [
                "DomainEntities",
                "Networking",
                "AuthAPIServiceInterface",
            ],
            path: "Sources/Data/AuthAPIService"
        ),
        .target(
            name: "KeychainService",
            dependencies: [
                "DomainEntities",
                "KeychainServiceInterface",
                .product(name: "SwiftKeychainWrapper", package: "swiftkeychainwrapper"),
            ],
            path: "Sources/Data/KeychainService"
        ),
        .target(
            name: "FundsAPIService",
            dependencies: [
                "DomainEntities",
                "Networking",
                "FundsAPIServiceInterface",
            ],
            path: "Sources/Data/FundsAPIService"
        ),
        .target(
            name: "TransactionsAPIService",
            dependencies: [
                "DomainEntities",
                "Networking",
                "TransactionsAPIServiceInterface",
            ],
            path: "Sources/Data/TransactionsAPIService"
        ),
        .target(
            name: "PortfolioAPIService",
            dependencies: [
                "DomainEntities",
                "Networking",
                "PortfolioAPIServiceInterface",
            ],
            path: "Sources/Data/PortfolioAPIService"
        ),
        .target(
            name: "TemporaryPersistenceService",
            dependencies: [
                "DomainEntities",
                "TemporaryPersistenceServiceInterface",
            ],
            path: "Sources/Data/TemporaryPersistenceService"
        ),
        .target(
            name: "PersistenceService",
            dependencies: [
                "DomainEntities",
                "PersistenceServiceInterface",
                .product(name: "RealmSwift", package: "realm-swift"),
            ],
            path: "Sources/Data/PersistenceService"
        ),
        .target(
            name: "UserAPIService",
            dependencies: [
                "DomainEntities",
                "Networking",
                "UserAPIServiceInterface",
            ],
            path: "Sources/Data/UserAPIService"
        ),
        .target(
            name: "InvestmentAPIService",
            dependencies: [
                "DomainEntities",
                "Networking",
                "InvestmentAPIServiceInterface",
            ],
            path: "Sources/Data/InvestmentAPIService"
        ),
        .target(
            name: "MarketAPIService",
            dependencies: [
                "DomainEntities",
                "Networking",
                "MarketAPIServiceInterface",
            ],
            path: "Sources/Data/MarketAPIService"
        ),

        // MARK: Test targets

        .testTarget(
            name: "LogInFeatureTests",
            dependencies: [
                "LogInFeature",
                "TestHelpers",
                "DomainEntities",
            ]
            // exclude: ["__Snapshots__"]
        ),
        .testTarget(
            name: "HomeFeatureTests",
            dependencies: [
                "HomeFeature",
                "TestHelpers",
                "DomainEntities",
            ]
            // exclude: ["__Snapshots__"]
        ),
        .testTarget(
            name: "FundFeatureTests",
            dependencies: [
                "FundFeature",
                "TestHelpers",
                "DomainEntities",
            ]
        ),
        .testTarget(
            name: "RecordTransactionFeatureTests",
            dependencies: [
                "RecordTransactionFeature",
                "TestHelpers",
                "DomainEntities",
            ]
        ),
        .testTarget(
            name: "SignUpFeatureTests",
            dependencies: [
                "SignUpFeature",
                "TestHelpers",
                "DomainEntities",
            ]
        ),
        .testTarget(
            name: "InvestmentFeatureTests",
            dependencies: [
                "InvestmentFeature",
                "TestHelpers",
                "DomainEntities",
            ]
        ),
    ]
)

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}

// package.targets = package.targets.map { target in
//    var plugins = target.plugins ?? []
//    plugins.append(.plugin(name: "SwiftLintPlugin", package: "SwiftLint"))
//    target.plugins = plugins
//    return target
// }
