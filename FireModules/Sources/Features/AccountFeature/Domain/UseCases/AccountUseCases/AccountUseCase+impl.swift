import ComposableArchitecture
import Dependencies
import Foundation

public extension AccountUseCase {
    static func live() -> Self { common }
    static func test() -> Self { common }
    static func preview() -> Self { common }

    private static var common: Self {
        @Dependency(\.accountsAPIService) var accountsAPIService

        @Sendable func unexpectedError(_ description: String) -> NSError {
            NSError(
                domain: "AccountUseCaseError",
                code: -99999,
                userInfo: [NSLocalizedDescriptionKey: description]
            )
        }

        return AccountUseCase(
            createAccount: { input in
                switch input {
                case let .bankAccount(accountName, icon, balance):
                    guard accountName.isValid, balance.isValid else {
                        return Effect.send(.failure(.invalidInputs(input)))
                    }

                    return accountsAPIService
                        .createAccount(
                            CreateAccountBody(
                                name: accountName.getOrCrash(),
                                type: .bank,
                                icon: icon,
                                currencyId: balance.getOrCrash().currencyCode,
                                cells: [
                                    .init(BankAccountBalanceCell(value: balance.getOrCrash().amount)),
                                ]
                            )
                        )
                        .mapResult(
                            success: { res -> CreateAccountOutput in
                                guard let createdAccount = res.asBankAccountEntity else {
                                    return .failure(.genericError(
                                        unexpectedError("Failed to convert to `BankAccount` entity due to unknow issue. Check the json response").eraseToDomainError()
                                    ))
                                }

                                return .success(.bankAccount(createdAccount))
                            },
                            failure: { .failure(.init(domainError: $0)) }
                        )
                case let .creditCard(data):
                    guard data.accountName.isValid, data.balance.isValid else {
                        return Effect.send(.failure(.invalidInputs(input)))
                    }

                    var cells: [CreateAccountBody.Cell] = [
                        .init(CreditAccountBalanceCell(value: data.balance.getOrCrash().amount)),
                        .init(CreditAccountLimitCell(value: data.limit.getOrCrash().amount)),
                    ]

                    if let statementDate = data.statementDate {
                        cells.append(.init(CreditAccountStatementClosingDateCell(value: statementDate)))
                    }

                    if let paymentDueDate = data.paymentDueDate {
                        cells.append(.init(CreditAccountPaymentDueDateCell(value: paymentDueDate)))
                    }

                    return accountsAPIService
                        .createAccount(
                            CreateAccountBody(
                                name: data.accountName.getOrCrash(),
                                type: .credit,
                                icon: data.icon,
                                currencyId: data.balance.getOrCrash().currencyCode,
                                cells: cells
                            )
                        )
                        .mapResult(
                            success: { res -> CreateAccountOutput in
                                guard let createdAccount = res.asCreditAccountEntity else {
                                    return .failure(.genericError(
                                        unexpectedError("Failed to convert to `BankAccount` entity due to unknow issue. Check the json response").eraseToDomainError()
                                    ))
                                }

                                return .success(.creditAccount(createdAccount))
                            },
                            failure: { .failure(.init(domainError: $0)) }
                        )
                }
            },
            getAccountList: { _ in
                return accountsAPIService
                    .getAccountList()
                    .mapToUseCaseLogic(
                        success: { .init(accounts: $0.compactMap { acc in acc.asAnyAccount }) },
                        failure: { .init(domainError: $0) }
                    )
            }
        )
    }
}
