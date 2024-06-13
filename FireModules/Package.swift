// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var package = Package(
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
        .singleTargetLibrary("SignUpFeature"),
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
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.10.4"),
        .package(url: "https://github.com/johnpatrickmorgan/TCACoordinators.git", exact: "0.8.0"),
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper.git", exact: "4.0.1"),
        .package(url: "https://github.com/krzysztofzablocki/AutomaticSettings", exact: "1.1.0"),
        .package(url: "https://github.com/realm/realm-swift.git", exact: "10.47.0"),
        .package(url: "https://github.com/krzysztofzablocki/Difference.git", exact: "1.0.2"),
        .package(url: "https://github.com/hmlongco/Factory.git", exact: "2.3.1"),
        .package(url: "https://github.com/pointfreeco/swift-overture", exact: "0.5.0"),
        .package(url: "https://github.com/krzysztofzablocki/KZFileWatchers.git", from: "1.2.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", exact: "1.3.0"),
    ],
    targets: [
        .app(
            .app,
            dependencies: [
                Module.Orchestrator.coordinator.asDependency,
                Module.Orchestrator.di.asDependency,
                .ThirdParty.tcaCoordinator.asDependency,
                .ThirdParty.composableArchitecture.asDependency,
            ]
        ),
        .app(
            .miniApp,
            dependencies: [
                Module.Orchestrator.di.asDependency,
                .ThirdParty.composableArchitecture.asDependency,
            ]
        ),
        .app(
            .appPlaybook,
            dependencies: [
                Module.Infra.coreUI.asDependency,
                Module.Feature.homeFeature.asDependency,
                Module.Feature.logInFeature.asDependency,
                Module.Feature.signUpFeature.asDependency,
                Module.Feature.onboardingFeature.asDependency,
                .ThirdParty.playbook.asDependency,
                .ThirdParty.playbookUI.asDependency,
                .ThirdParty.composableArchitecture.asDependency,
            ]
        ),
        .app(
            .intents,
            dependencies: [
                Module.DataSource.persistenceService.implementation,
                Module.DataSource.transactionsAPIService.implementation,
                Module.Domain.Core.domainEntities.asDependency,
            ]
        ),
    ]
)

// MARK: - Orchestrator - knows everything about everyone

package.targets.append(contentsOf: [
    .orchestrator(
        .di,
        features: [
            .logInFeature,
            .fundFeature,
            .homeFeature,
            .recordTransactionFeature,
            .signUpFeature,
            .onboardingFeature,
            .settingsFeature,
            .investmentFeature,
        ],
        useCases: [
            .authenticationUseCase,
            .fundDetailsUseCase,
            .fundCreationUseCase,
            // "LogInUseCase", // TODO: Replace this with `AuthenticationUseCase`
            .fundListUseCase,
            .transactionRecordUseCase,
            .transactionListUseCase,
            // .accountRegisterUseCase, // TODO: Replace this with `AuthenticationUseCase`
            .portfolioUseCase,
            .devSettingsUseCase,
            .investmentUseCase,
            .liveMarketUseCase,
        ],
        dataSources: [
            .authAPIService,
            .keychainService,
            .fundsAPIService,
            .transactionsAPIService,
            .portfolioAPIService,
            .temporaryPersistenceService,
            .persistenceService,
            .investmentAPIService,
            .marketAPIService,
        ],
        thirdParties: [
            .factory,
        ]
    ),
    .orchestrator(
        .coordinator,
        dataSources: [
            .keychainService,
        ],
        otherOrchestrators: [.di],
        thirdParties: [
            .tcaCoordinator,
//            .codextended
        ]
    ),
])

// MARK: - Features

package.targets.append(contentsOf: [
    .feature(
        .logInFeature,
        useCases: [
            .authenticationUseCase,
        ],
        enableDevDependenies: true
    ),
    .feature(.onboardingFeature),
    .feature(
        .signUpFeature,
        useCases: [
            .authenticationUseCase,
        ],
        infras: [
            .networking,
        ],
        thirdParties: [
            .codextended,
            .tcaCoordinator,
        ],
        enableDevDependenies: true
    ),
    .feature(
        .homeFeature,
        useCases: [
            .transactionListUseCase,
            .fundListUseCase,
            .fundDetailsUseCase,
            .portfolioUseCase,
        ],
        infras: [
            .currencyKit,
        ],
        features: [
            .fundFeature,
            .investmentFeature,
        ]
    ),
    .feature(
        .fundFeature,
        useCases: [
            .fundDetailsUseCase,
            .fundCreationUseCase,
        ],
        infras: [
            .currencyKit,
        ],
        features: [
            .recordTransactionFeature,
        ]
    ),
    .feature(
        .recordTransactionFeature,
        useCases: [
            .fundListUseCase,
            .transactionRecordUseCase,
        ],
        infras: [
            .currencyKit,
        ]
    ),
    .feature(
        .settingsFeature,
        useCases: [
            .devSettingsUseCase,
        ],
        thirdParties: [
            .automaticSettings,
        ]
    ),
    .feature(
        .investmentFeature,
        useCases: [
            .investmentUseCase,
            .liveMarketUseCase,
        ],
        infras: [
            .currencyKit,
        ]
    ),
])

// MARK: Domains/UseCases

package.targets.append(contentsOf: [
    .useCase(
        .authenticationUseCase,
        dataSourceInterfaces: [
            .authAPIService,
            .keychainService,
        ]
    ),
    .useCase(
        .fundDetailsUseCase,
        dataSourceInterfaces: [
            .fundsAPIService,
        ]
    ),
    .useCase(
        .fundCreationUseCase,
        dataSourceInterfaces: [
            .fundsAPIService,
        ]
    ),
    .useCase(
        .fundListUseCase,
        dataSourceInterfaces: [
            .fundsAPIService,
            .temporaryPersistenceService,
            .persistenceService,
        ]
    ),
    .useCase(
        .transactionListUseCase,
        dataSourceInterfaces: [
            .transactionsAPIService,
        ]
    ),
    .useCase(
        .transactionRecordUseCase,
        dataSourceInterfaces: [
            .transactionsAPIService,
        ]
    ),
    .useCase(
        .portfolioUseCase,
        dataSourceInterfaces: [
            .portfolioAPIService,
        ]
    ),
    .useCase(
        .investmentUseCase,
        dataSourceInterfaces: [
            .investmentAPIService,
        ]
    ),
    .useCase(
        .liveMarketUseCase,
        dataSourceInterfaces: [
            .marketAPIService,
        ]
    ),
])

package.targets.append(contentsOf: [
    .target(
        name: "DevSettingsUseCase",
        dependencies: [
            Module.Domain.Core.domainEntities.asDependency,
            .ThirdParty.swiftDependencies.asDependency,
            .ThirdParty.automaticSettings.asDependency,
            .ThirdParty.codextended.asDependency,
        ],
        path: "Sources/Domains/UseCases/DevSettingsUseCase"
    ),
])

// MARK: Domains/Entities

package.targets.append(contentsOf: [
    .domainEntity(
        .domainEntities,
        domainEntities: [
            .domainUtilities,
        ]
    ),
    .domainEntity(
        .domainUtilities,
        thirdParties: [
            .composableArchitecture,
        ]
    ),
])

// MARK: Domains/Data Source Interfaces

package.targets.append(contentsOf: [
    .dataSourceInterface(.authAPIService),
    .dataSourceInterface(.fundsAPIService),
    .dataSourceInterface(.transactionsAPIService),
    .dataSourceInterface(.keychainService),
    .dataSourceInterface(.portfolioAPIService),
    .dataSourceInterface(.temporaryPersistenceService),
    .dataSourceInterface(.persistenceService),
    .dataSourceInterface(.userAPIService),
    .dataSourceInterface(.investmentAPIService),
    .dataSourceInterface(.marketAPIService),
])

// MARK: Data Source Implementations

package.targets.append(contentsOf: [
    .dataSource(.authAPIService, infras: [.networking]),
    .dataSource(.fundsAPIService, infras: [.networking]),
    .dataSource(.transactionsAPIService, infras: [.networking]),
    .dataSource(.portfolioAPIService, infras: [.networking]),
    .dataSource(.temporaryPersistenceService),
    .dataSource(.persistenceService, thirdParties: [.realm]),
    .dataSource(.userAPIService, infras: [.networking]),
    .dataSource(.investmentAPIService, infras: [.networking]),
    .dataSource(.marketAPIService, infras: [.networking]),
])

// MARK: - Infrastructure

package.targets.append(contentsOf: [
    .infra(.utilities),
    .infra(
        .networking,
        infras: [
            .utilities,
            .keychainService,
        ],
        thirdParties: [
            .combineMoya,
            .codextended,
            .combineExt,
        ]
    ),
    .infra(.currencyKit),
    .infra(
        .tcaExtensions,
        thirdParties: [
            .composableArchitecture,
            .tcaCoordinator,
        ]
    ),
    .infra(
        .testHelpers,
        thirdParties: [
            .overture,
            .factory,
            .difference,
        ],
        otherDependencies: ["DI"]
    ),
    .infra(
        .keychainService,
        thirdParties: [.keychainWrapper],
        domainEntities: [.domainEntities],
        domainDataSources: [.keychainService]
    ),
])

// MARK: - CoreUI

package.targets.append(
    .designSystem(
        .coreUI,
        thirdParties: [
            .inject,
            .swiftUIIntrospect,
        ],
        resources: [
            .process("Assets"),
            .process("CodeGen/Templates"),
        ]
    )
)

// MARK: Test targets

package.targets.append(contentsOf: [
    .testFeature(.logInFeature),
    .testFeature(.homeFeature),
    .testFeature(.fundFeature),
    .testFeature(.recordTransactionFeature),
    .testFeature(.signUpFeature),
    .testFeature(.investmentFeature),
])
package.targets.append(contentsOf: [
    .testApp(.app),
])

// MARK: Helpers

extension Product {
    static func singleTargetLibrary(_ name: String) -> Product {
        .library(name: name, targets: [name])
    }
}

extension Target {
    static func app(
        _ module: Module.App,
        dependencies: [Dependency]
    ) -> Target {
        .target(
            name: module.id,
            dependencies: dependencies,
            path: "Sources/App/\(module.id)"
        )
    }

    static func orchestrator(
        _ module: Module.Orchestrator,
        features: [Module.Feature]? = nil,
        useCases: [Module.Domain.UseCase]? = nil,
        dataSources: [Module.DataSource]? = nil,
        infras: [Module.Infra]? = nil,
        otherOrchestrators: [Module.Orchestrator]? = nil,
        thirdParties: [Dependency.ThirdParty]? = nil
    ) -> Target {
        var dependencies = [Dependency]()

        if let features {
            dependencies.append(contentsOf: features.map(\.asDependency))
        }

        if let useCases {
            dependencies.append(contentsOf: useCases.map(\.asDependency))
        }

        if let dataSources {
            dependencies.append(contentsOf: dataSources.map(\.interface))
            dependencies.append(contentsOf: dataSources.map(\.implementation))
        }

        if let infras {
            dependencies.append(contentsOf: infras.map(\.asDependency))
        }

        if let otherOrchestrators {
            dependencies.append(contentsOf: otherOrchestrators.map(\.asDependency))
        }

        if let thirdParties {
            dependencies.append(contentsOf: thirdParties.map(\.asDependency))
        }

        return Target.target(
            name: module.id,
            dependencies: dependencies,
            path: "Sources/Orchestrator/\(module.id)"
        )
    }

    static func feature(
        _ module: Module.Feature,
        useCases: [Module.Domain.UseCase]? = nil,
        infras: [Module.Infra]? = nil,
        thirdParties: [Dependency.ThirdParty]? = nil,
        features: [Module.Feature]? = nil,
        enableDevDependenies: Bool = false
    ) -> Target {
        var dependencies = [Dependency]()
        dependencies.append(contentsOf: [
            Module.Infra.coreUI.asDependency,
            Module.Infra.utilities.asDependency,
            Module.Infra.tcaExtensions.asDependency,
            Module.Domain.Core.domainEntities.asDependency,
            Dependency.ThirdParty.composableArchitecture.asDependency,
            Dependency.ThirdParty.factory.asDependency,
            Dependency.ThirdParty.swiftDependencies.asDependency,
        ])

        if let useCases {
            dependencies.append(contentsOf: useCases.map(\.asDependency))
        }

        if let infras {
            dependencies.append(contentsOf: infras.map(\.asDependency))
        }

        if let features {
            dependencies.append(contentsOf: features.map(\.asDependency))
        }

        if enableDevDependenies {
            dependencies.append(Module.Domain.UseCase.Dev.devSettingsUseCase.asDependency)
        }

        if let thirdParties {
            dependencies.append(contentsOf: thirdParties.map(\.asDependency))
        }

        return Target.target(
            name: module.id,
            dependencies: dependencies,
            path: "Sources/Features/\(module.id)"
        )
    }

    static func useCase(
        _ module: Module.Domain.UseCase,
        dataSourceInterfaces: [Module.DataSource] = []
    ) -> Target {
        var dependencies = [Dependency]()
        dependencies.append(contentsOf: [
            .ThirdParty.swiftDependencies.asDependency,
        ])
        dependencies.append(contentsOf: Module.Domain.Core.allCases.map(\.asDependency))
        dependencies.append(contentsOf: dataSourceInterfaces.map(\.interface))

        return Target.target(
            name: module.id,
            dependencies: dependencies,
            path: "Sources/Domains/UseCases/\(module.id)"
        )
    }

    static func domainEntity(
        _ module: Module.Domain.Core,
        thirdParties: [Dependency.ThirdParty]? = nil,
        domainEntities: [Module.Domain.Core]? = nil
    ) -> Target {
        var dependencies = [Dependency]()

        if let thirdParties {
            dependencies.append(contentsOf: thirdParties.map(\.asDependency))
        }

        if let domainEntities {
            dependencies.append(contentsOf: domainEntities.map(\.asDependency))
        }

        return Target.target(
            name: module.id,
            dependencies: dependencies,
            path: "Sources/Domains/Core/\(module.id)"
        )
    }

    static func dataSourceInterface(_ module: Module.DataSource) -> Target {
        var dependencies = [Dependency]()
        dependencies.append(contentsOf: Module.Domain.Core.allCases.map(\.asDependency))

        return Target.target(
            name: module.interfaceId,
            dependencies: dependencies,
            path: "Sources/Domains/DataSourceInterfaces/\(module.interfaceId)"
        )
    }

    static func dataSource(
        _ module: Module.DataSource,
        infras: [Module.Infra]? = nil,
        thirdParties: [Dependency.ThirdParty]? = nil
    ) -> Target {
        var dependencies = [Dependency]()
        dependencies.append(contentsOf: Module.Domain.Core.allCases.map(\.asDependency))
        dependencies.append(module.interface)
        dependencies.append(contentsOf: [
            .ThirdParty.swiftDependencies.asDependency,
        ])

        if let infras {
            dependencies.append(contentsOf: infras.map(\.asDependency))
        }

        if let thirdParties {
            dependencies.append(contentsOf: thirdParties.map(\.asDependency))
        }

        return Target.target(
            name: module.implementationId,
            dependencies: dependencies,
            path: "Sources/DataSources/\(module.implementationId)"
        )
    }

    static func infra(
        _ module: Module.Infra,
        infras: [Module.Infra]? = nil,
        thirdParties: [Dependency.ThirdParty]? = nil,
        domainEntities: [Module.Domain.Core]? = nil,
        domainDataSources: [Module.DataSource]? = nil,
        otherDependencies: [Dependency]? = nil
    ) -> Target {
        var dependencies = [Dependency]()
        if let infras {
            dependencies.append(contentsOf: infras.map(\.asDependency))
        }

        if let thirdParties {
            dependencies.append(contentsOf: thirdParties.map(\.asDependency))
        }

        if let domainEntities {
            dependencies.append(contentsOf: domainEntities.map(\.asDependency))
        }

        if let domainDataSources {
            dependencies.append(contentsOf: domainDataSources.map(\.interface))
        }

        if let otherDependencies {
            dependencies.append(contentsOf: otherDependencies)
        }

        return Target.target(
            name: module.id,
            dependencies: dependencies,
            path: "Sources/Shared/\(module.id)"
        )
    }

    static func designSystem(
        _ module: Module.Infra,
        thirdParties: [Dependency.ThirdParty]? = nil,
        resources: [Resource]?
    ) -> Target {
        var dependencies = [Dependency]()
        if let thirdParties {
            dependencies.append(contentsOf: thirdParties.map(\.asDependency))
        }

        return Target.target(
            name: module.id,
            dependencies: dependencies,
            path: "Sources/Shared/\(module.id)",
            resources: resources
        )
    }

    static func testFeature(_ feature: Module.Feature) -> Target {
        var dependencies = [Dependency]()
        dependencies.append(Module.Infra.testHelpers.asDependency)
        dependencies.append(feature.asDependency)
        return Target.testTarget(
            name: "\(feature.id)Tests",
            dependencies: dependencies
            // exclude: ["__Snapshots__"]
        )
    }

    static func testApp(_ module: Module.App) -> Target {
        var dependencies = [Dependency]()
        dependencies.append(module.asDependency)
        return .testTarget(
            name: "\(module.id)Tests",
            dependencies: dependencies
            // exclude: ["__Snapshots__"]
        )
    }
}

extension Target.Dependency {
    enum ThirdParty {
        case tcaCoordinator
        case composableArchitecture
        case factory
        case inject
        case swiftUIIntrospect
        case combineMoya
        case codextended
        case combineExt
        case overture
        case difference
        case keychainWrapper
        case realm
        case automaticSettings
        case playbook
        case playbookUI
        case swiftDependencies

        var asDependency: Target.Dependency {
            switch self {
            case .tcaCoordinator:
                return Target.Dependency.product(name: "TCACoordinators", package: "TCACoordinators")
            case .composableArchitecture:
                return Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            case .factory:
                return Target.Dependency.product(name: "Factory", package: "factory")
            case .inject:
                return Target.Dependency.product(name: "Inject", package: "inject")
            case .swiftUIIntrospect:
                return Target.Dependency.product(name: "SwiftUIIntrospect", package: "swiftui-introspect")
            case .combineMoya:
                return Target.Dependency.product(name: "CombineMoya", package: "moya")
            case .codextended:
                return Target.Dependency.product(name: "Codextended", package: "codextended")
            case .combineExt:
                return Target.Dependency.product(name: "CombineExt", package: "combineext")
            case .overture:
                return Target.Dependency.product(name: "Overture", package: "swift-overture")
            case .difference:
                return Target.Dependency.product(name: "Difference", package: "difference")
            case .keychainWrapper:
                return Target.Dependency.product(name: "SwiftKeychainWrapper", package: "swiftkeychainwrapper")
            case .realm:
                return Target.Dependency.product(name: "RealmSwift", package: "realm-swift")
            case .automaticSettings:
                return Target.Dependency.product(name: "AutomaticSettings", package: "automaticsettings")
            case .playbook:
                return Target.Dependency.product(name: "Playbook", package: "playbook-ios")
            case .playbookUI:
                return Target.Dependency.product(name: "PlaybookUI", package: "playbook-ios")
            case .swiftDependencies:
                return Target.Dependency.product(name: "Dependencies", package: "swift-dependencies")
            }
        }
    }
}

protocol DependencyRepresentable: RawRepresentable<String> {
    var id: String { get }
    var asDependency: Target.Dependency { get }
}

extension DependencyRepresentable {
    var id: String { rawValue }
    var asDependency: Target.Dependency {
        return Target.Dependency(stringLiteral: id)
    }
}

protocol DependencyInterfacePair: RawRepresentable<String> {
    var implementationId: String { get }
    var interfaceId: String { get }
    var implementation: Target.Dependency { get }
    var interface: Target.Dependency { get }
}

extension DependencyInterfacePair {
    var implementationId: String { rawValue }
    var interfaceId: String { "\(rawValue)Interface" }

    var implementation: Target.Dependency {
        return Target.Dependency(stringLiteral: implementationId)
    }

    var interface: Target.Dependency {
        return Target.Dependency(stringLiteral: interfaceId)
    }
}

enum Module {
    enum App: String, DependencyRepresentable {
        case app = "App"
        case miniApp = "MiniApp"
        case appPlaybook = "AppPlaybook"
        case intents = "Intents"
    }

    enum Orchestrator: String, DependencyRepresentable {
        case di = "DI"
        case coordinator = "Coordinator"
    }

    enum Feature: String, DependencyRepresentable {
        case onboardingFeature = "OnboardingFeature"
        case logInFeature = "LogInFeature"
        case signUpFeature = "SignUpFeature"
        case homeFeature = "HomeFeature"
        case fundFeature = "FundFeature"
        case investmentFeature = "InvestmentFeature"
        case recordTransactionFeature = "RecordTransactionFeature"
        case settingsFeature = "SettingsFeature"
    }

    enum DataSource: String, DependencyInterfacePair {
        case marketAPIService = "MarketAPIService"
        case authAPIService = "AuthAPIService"
        case keychainService = "KeychainService"
        case fundsAPIService = "FundsAPIService"
        case temporaryPersistenceService = "TemporaryPersistenceService"
        case persistenceService = "PersistenceService"
        case transactionsAPIService = "TransactionsAPIService"
        case portfolioAPIService = "PortfolioAPIService"
        case investmentAPIService = "InvestmentAPIService"
        case userAPIService = "UserAPIService"
    }

    enum Infra: String, DependencyRepresentable {
        case coreUI = "CoreUI"
        case currencyKit = "CurrencyKit"
        case utilities = "Utilities"
        case networking = "Networking"
        case tcaExtensions = "TCAExtensions"
        case keychainService = "KeychainService"
        case testHelpers = "TestHelpers"
    }

    enum Domain {
        enum Core: String, DependencyRepresentable, CaseIterable {
            case domainEntities = "DomainEntities"
            case domainUtilities = "DomainUtilities"
        }

        enum UseCase: String, DependencyRepresentable {
            case authenticationUseCase = "AuthenticationUseCase"
            case fundDetailsUseCase = "FundDetailsUseCase"
            case fundCreationUseCase = "FundCreationUseCase"
            case fundListUseCase = "FundListUseCase"
            case transactionListUseCase = "TransactionListUseCase"
            case transactionRecordUseCase = "TransactionRecordUseCase"
            case portfolioUseCase = "PortfolioUseCase"
            case investmentUseCase = "InvestmentUseCase"
            case liveMarketUseCase = "LiveMarketUseCase"
            case devSettingsUseCase = "DevSettingsUseCase"

            enum Dev: String, DependencyRepresentable {
                case devSettingsUseCase = "DevSettingsUseCase"
            }
        }
    }
}
