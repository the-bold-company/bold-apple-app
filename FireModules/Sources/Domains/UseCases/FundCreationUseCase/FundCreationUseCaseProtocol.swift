import Foundation

// sourcery: AutoMockable
public protocol FundCreationUseCaseProtocol {
    func createFiatFund(
        name: String,
        balance: Decimal,
        currency: String,
        description: String?
    ) async -> Result<FundEntity, DomainError>
}
