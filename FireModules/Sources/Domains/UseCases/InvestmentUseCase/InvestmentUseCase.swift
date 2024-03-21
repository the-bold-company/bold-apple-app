import InvestmentAPIServiceInterface

public struct InvestmentUseCase: InvestmentUseCaseInterface {
    let investmentAPIService: InvestmentAPIServiceInterface

    public init(investmentAPIService: InvestmentAPIServiceInterface) {
        self.investmentAPIService = investmentAPIService
    }

    public func createPortfolio(name: String) async -> Result<InvestmentPortfolioEntity, DomainError> {
        do {
            let portfolio = try await investmentAPIService.createPortfolio(name: name)
            return .success(portfolio)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }

    public func getPortfolioList() async -> Result<[InvestmentPortfolioEntity], DomainError> {
        do {
            let portfolios = try await investmentAPIService.getPortfolioList()
            return .success(portfolios)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
