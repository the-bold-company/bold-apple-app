import Foundation
import FundsAPIServiceInterface

public struct FundCreationUseCase: FundCreationUseCaseProtocol {
    let fundsAPIService: FundsAPIServiceProtocol

    public init(fundsAPIService: FundsAPIServiceProtocol) {
        self.fundsAPIService = fundsAPIService
    }

    public func createFiatFund(
        name: String,
        balance: Decimal,
        currency: String,
        description: String?
    ) async -> Result<FundEntity, DomainError> {
        do {
            let createdFund = try await fundsAPIService.createFund(
                name: name,
                balance: balance,
                fundType: .fiat,
                currency: currency,
                description: description
            )
            return .success(createdFund)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
