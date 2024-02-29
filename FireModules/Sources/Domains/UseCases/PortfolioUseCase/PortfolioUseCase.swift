import PortfolioAPIServiceInterface

public struct PortfolioUseCase: PortfolioUseCaseInterface {
    let portfolioAPIService: PortfolioAPIServiceInterface

    public init(portfolioAPIService: PortfolioAPIServiceInterface) {
        self.portfolioAPIService = portfolioAPIService
    }

    public func getNetworth() async -> Result<NetworthEntity, DomainError> {
        do {
            let networth = try await portfolioAPIService.getNetworth()
            return .success(networth)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
