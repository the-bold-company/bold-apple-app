import DomainEntities

public protocol PortfolioAPIServiceInterface {
    func getNetworth() async throws -> NetworthEntity
}
