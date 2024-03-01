import Foundation
import TransactionsAPIServiceInterface

public struct TransactionRecordUseCase: TransactionRecordUseCaseProtocol {
    let transactionsAPIService: TransactionsAPIServiceProtocol

    public init(transactionsAPIService: TransactionsAPIServiceProtocol) {
        self.transactionsAPIService = transactionsAPIService
    }

    public func recordInOutTransaction(
        sourceFundId: UUID,
        amount: Decimal,
        destinationFundId: UUID?,
        description: String?
    ) async -> Result<TransactionEntity, DomainError> {
        do {
            let recordedTransaction = try await transactionsAPIService.recordTransaction(
                sourceFundId: sourceFundId,
                amount: amount,
                destinationFundId: destinationFundId,
                description: description,
                type: .inout
            )
            return .success(recordedTransaction)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
