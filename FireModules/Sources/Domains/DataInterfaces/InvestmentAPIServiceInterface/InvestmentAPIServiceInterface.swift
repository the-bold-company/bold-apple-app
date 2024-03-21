import DomainEntities

public protocol InvestmentAPIServiceInterface {
    func createPortfolio(name: String) async throws -> InvestmentPortfolioEntity
    func getPortfolioList() async throws -> [InvestmentPortfolioEntity]
}
