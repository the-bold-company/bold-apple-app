import Foundation

// sourcery: AutoMockable
public protocol InvestmentUseCaseInterface {
    func createPortfolio(name: String) async -> DomainResult<InvestmentPortfolioEntity>
    func getPortfolioList() async -> DomainResult<[InvestmentPortfolioEntity]>
    func recordTransaction(
        amount: Decimal,
        portfolioId: ID,
        type: String,
        currency: String,
        notes: String?
    ) async -> DomainResult<InvestmentTransactionEntity>
    func getPortfolioDetails(id: String) async -> DomainResult<InvestmentPortfolioEntity>
    func getTransactionHistory(portfolioId: ID) async -> DomainResult<[InvestmentTransactionEntity]>
}
