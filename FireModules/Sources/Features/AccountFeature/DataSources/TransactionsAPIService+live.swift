import ComposableArchitecture
import DomainUtilities
import Networking

public extension TransactionsAPIService {
    static var live: Self {
        let networkClient = MoyaClient<TransactionsAPI.v1>()
        return .init { type, amount, accountId, date, categoryId, name, note in
            Effect.publisher {
                networkClient
                    .requestPublisher(
                        .createTransaction(
                            type: type,
                            amount: amount,
                            accountId: accountId,
                            date: date,
                            categoryId: categoryId,
                            name: name,
                            note: note
                        )
                    )
                    .mapToResponse(TransactionAPIResponse.self, apiVersion: .v1_1)
                    .mapErrorToDomainError()
                    .mapToResult()
            }
        }
    }
}
