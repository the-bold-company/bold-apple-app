// sourcery: AutoMockable
public protocol InvestmentUseCaseInterface {
    func createPortfolio(name: String) async -> Result<InvestmentPortfolioEntity, DomainError>
    func getPortfolioList() async -> Result<[InvestmentPortfolioEntity], DomainError>
}
