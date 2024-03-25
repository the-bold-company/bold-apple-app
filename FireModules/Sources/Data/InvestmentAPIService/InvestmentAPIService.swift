import DomainEntities
import Foundation
import InvestmentAPIServiceInterface
import Networking

public struct InvestmentService: InvestmentAPIServiceInterface {
    let client = MoyaClient<InvestmentAPI>()

    public init() {}

    public func createPortfolio(name: String) async throws -> InvestmentPortfolioEntity {
        return try await client
            .requestPublisher(.createPortfolio(name: name))
            .mapToResponse(GetPortfolioResponse.self)
            .map { $0.asPortfolioEntity() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }

    public func getPortfolioList() async throws -> [InvestmentPortfolioEntity] {
        return try await client
            .requestPublisher(.getPortfolioList)
            .mapToResponse(PortfolioListResponse.self)
            .map { $0.asPortfolioEntities() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }

    public func recordTransaction(
        amount: Decimal,
        portfolioId: String,
        type: String,
        currency: String,
        notes: String?
    ) async throws -> InvestmentTransactionEntity {
        return try await client
            .requestPublisher(.recordTransaction(
                portfolioId: portfolioId,
                type: type,
                amount: amount,
                currency: currency,
                notes: notes
            ))
            .mapToResponse(RecordTransactionRespose.self)
            .map { $0.asInvestmentTransactionEntity() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }
}
