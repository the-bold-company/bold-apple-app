import DomainEntities
import Networking
import PortfolioAPIServiceInterface

public struct PortfolioAPIService: PortfolioAPIServiceInterface {
    let client = MoyaClient<PortfolioAPI>()

    public init() {}

    public func getNetworth() async throws -> NetworthEntity {
        return try await client
            .requestPublisher(.networth)
            .mapToResponse(NetworthResponse.self, apiVersion: .v0)
            .map { $0.asNetworthEntity() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }
}
