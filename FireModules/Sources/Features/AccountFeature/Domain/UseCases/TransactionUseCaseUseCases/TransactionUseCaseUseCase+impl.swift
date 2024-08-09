import ComposableArchitecture
import Dependencies
import Foundation

public extension TransactionUseCase {
    static func live() -> Self { common }
    static func test() -> Self { common }
    static func preview() -> Self { common }

    private static var common: Self {
        @Dependency(\.transactionsAPIService) var transactionsAPIService

        @Sendable func unexpectedError(_ description: String) -> NSError {
            NSError(
                domain: "TransactionUseCaseError",
                code: -99999,
                userInfo: [NSLocalizedDescriptionKey: description]
            )
        }

        return TransactionUseCase(
            createTransaction: { input in
                switch input {
                case let .moneyIn(data):
                    guard let money = data.amount.getOrNil(),
                          let accountId = data.accountId.getOrNil()
                    else { return Effect.send(.failure(.invalidInputs(input))) }

                    if let categoryId = data.categoryId, !categoryId.isValid {
                        return Effect.send(.failure(.invalidInputs(input)))
                    }

                    if let name = data.name, !name.isValid {
                        return Effect.send(.failure(.invalidInputs(input)))
                    }

                    if let note = data.note, !note.isValid {
                        return Effect.send(.failure(.invalidInputs(input)))
                    }

                    return transactionsAPIService
                        .createTransaction(
                            .moneyIn,
                            money.amount,
                            accountId,
                            data.timestamp.unix,
                            data.categoryId?.getOrNil(),
                            data.name?.getOrNil(),
                            data.note?.getOrNil()
                        )
                        .mapToUseCaseLogic(
                            success: { .moneyIn($0.asTransactionEntity) },
                            failure: { .init(domainError: $0) }
                        )
                case .moneyOut:
                    fatalError()
                case .internalTransfer:
                    fatalError()
                }
            }
        )
    }
}
