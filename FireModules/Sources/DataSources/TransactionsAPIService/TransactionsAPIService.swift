import DomainEntities
import Foundation
import Networking
import TransactionsAPIServiceInterface

public struct TransactionsAPIService: TransactionsAPIServiceProtocol {
    let client = MoyaClient<TransactionsAPI>()

    public init() {}

    public func recordTransaction(
        sourceFundId: UUID,
        amount: Decimal,
        destinationFundId: UUID?,
        description: String?,
        type: TransactionType
    ) async throws -> TransactionEntity {
        return try await client
            .requestPublisher(.record(
                sourceFundId: sourceFundId.serverCompartibleUUID,
                amount: amount,
                destinationFundId: destinationFundId?.serverCompartibleUUID,
                description: description,
                type: type.rawValue
            ))
            .mapToResponse(TransactionRecordResponse.self, apiVersion: .v0)
            .mapError { DomainError(error: $0) }
            .map { $0.asTransactionEntity() }
            .eraseToAnyPublisher()
            .async()
    }

    public func getTransactionLists() async throws -> [TransactionEntity] {
        return try await client
            .requestPublisher(.transactionList)
            .mapToResponse(TransactionListResponse.self, apiVersion: .v0)
            .map(\.transactions)
            .mapError { DomainError(error: $0) }
            .map { transactions in
                transactions.map { $0.asTransactionEntity() }
            }
            .eraseToAnyPublisher()
            .async()
    }
}
