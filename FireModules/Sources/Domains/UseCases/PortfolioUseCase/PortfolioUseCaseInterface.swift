// sourcery: AutoMockable
public protocol PortfolioUseCaseInterface {
    func getNetworth() async -> Result<NetworthEntity, DomainError>
}
