import DomainEntities
import Foundation

public protocol InvestmentAPIServiceInterface {
    func createPortfolio(name: String) async throws -> InvestmentPortfolioEntity
    func getPortfolioList() async throws -> [InvestmentPortfolioEntity]
    func recordTransaction(
        amount: Decimal,
        portfolioId: String,
        type: String,
        currency: String,
        notes: String?
    ) async throws -> InvestmentTransactionEntity
    func getPortfolioDetails(id: String) async throws -> InvestmentPortfolioEntity
    func getTransactionHistory(portfolioId: String) async throws -> [InvestmentTransactionEntity]
}
