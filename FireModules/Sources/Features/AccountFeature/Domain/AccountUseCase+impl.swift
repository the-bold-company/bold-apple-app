import ComposableArchitecture
import Dependencies

public extension AccountUseCase {
    static func live() -> Self { common }
    static func test() -> Self { common }
    static func preview() -> Self { common }

    private static var common: Self {
        @Dependency(\.accountsAPIService) var accountsAPIService

        return AccountUseCase(
            createAccount: { input in
                switch input {
                case let .bankAccount(accountName, icon, balance, currency):
                    guard accountName.isValid else {
                        return Effect.send(.failure(.invalidInputs(input)))
                    }

                    return accountsAPIService
                        .createAccount(
                            CreateAccountBody(
                                name: accountName.getOrCrash(),
                                type: .bank,
                                icon: icon,
                                currencyId: currency.currencyCodeString,
                                cells: [
                                    AccountBalanceCell(value: balance.getOrCrash()).eraseToAnyAccountCell,
                                ]
                            )
                        )
                        .mapToUseCaseLogic(
                            success: { .init(createdAccount: $0) },
                            failure: { .init(domainError: $0) }
                        )
                case let .creditCard(accountName, icon, balance, currency):
                    guard accountName.isValid else {
                        return Effect.send(.failure(.invalidInputs(input)))
                    }

                    return accountsAPIService
                        .createAccount(
                            CreateAccountBody(
                                name: accountName.getOrCrash(),
                                type: .credit,
                                icon: icon,
                                currencyId: currency.currencyCodeString,
                                cells: [
                                    AccountBalanceCell(value: balance.getOrCrash()).eraseToAnyAccountCell,
                                ]
                            )
                        )
                        .mapToUseCaseLogic(
                            success: { .init(createdAccount: $0) },
                            failure: { .init(domainError: $0) }
                        )
                }
            },
            getAccountList: { _ in
                return accountsAPIService
                    .getAccountList()
                    .mapToUseCaseLogic(
                        success: { .init(accounts: $0) },
                        failure: { .init(domainError: $0) }
                    )
            }
        )
    }
}
