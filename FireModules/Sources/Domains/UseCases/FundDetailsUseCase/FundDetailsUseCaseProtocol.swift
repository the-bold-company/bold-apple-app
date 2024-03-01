import Foundation

// sourcery: AutoMockable
public protocol FundDetailsUseCaseProtocol {
    func loadFundDetails(id: UUID) async -> Result<FundEntity, DomainError>
    func deleteFund(id: UUID) async -> Result<UUID, DomainError>
    func loadTransactionHistory(fundId: UUID, order: SortOrder) async -> Result<PaginationEntity<TransactionEntity>, DomainError>
}

public enum SortOrder {
    case ascending
    case descending
}
