import DomainEntities
import Foundation

public protocol TransactionsAPIServiceProtocol {
    func recordTransaction(
        sourceFundId: UUID,
        amount: Decimal,
        destinationFundId: UUID?,
        description: String?,
        type: TransactionEntityType
    ) async throws -> TransactionEntity

    func getTransactionLists() async throws -> [TransactionEntity]
}
