import ComposableArchitecture
import Dependencies
import Foundation

public extension CategoryUseCase {
    static func live() -> Self { common }
    static func test() -> Self { common }
    static func preview() -> Self { common }

    private static var common: Self {
        @Dependency(\.categoriesAPIService) var categoriesAPIService

        return CategoryUseCase(
            getCategories: { input in
                switch input {
                case .moneyIn:
                    return categoriesAPIService
                        .getCategories(input.rawValue)
                        .mapToUseCaseLogic(
                            success: {
                                .moneyIn(.init(uniqueElements: $0.compactMap(\.asMoneyInCategoryEntity)))
                            },
                            failure: { .init(domainError: $0) }
                        )
                case .moneyOut:
                    return categoriesAPIService
                        .getCategories(input.rawValue)
                        .mapToUseCaseLogic(
                            success: {
                                .moneyOut(IdentifiedArrayOf<MoneyOutCategory>(uniqueElements: $0.compactMap(\.asMoneyOutCategoryEntity)))
                            },
                            failure: { .init(domainError: $0) }
                        )
                }
            }
        )
    }
}
