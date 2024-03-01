import Foundation

// sourcery: AutoMockable
public protocol TransactionRecordUseCaseProtocol {
    func recordInOutTransaction(
        sourceFundId: UUID,
        amount: Decimal,
        destinationFundId: UUID?,
        description: String?
    ) async -> Result<TransactionEntity, DomainError>
}
