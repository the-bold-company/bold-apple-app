import DomainEntities
import Foundation
import FundsAPIServiceInterface
import Networking

public struct FundsAPIService: FundsAPIServiceProtocol {
    let client = MoyaClient<FundsAPI>()

    public init() {}

    public func createFund(
        name: String,
        balance: Decimal,
        fundType: FundType,
        currency: String,
        description: String?
    ) async throws -> FundEntity {
        return try await client
            .requestPublisher(.createFund(
                name: name,
                balance: balance,
                fundType: fundType.rawValue,
                currency: currency,
                description: description
            ))
            .mapToResponse(CreateFundResponse.self)
            .map { $0.asFundEntity() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }

    public func listFunds() async throws -> [FundEntity] {
        return try await client
            .requestPublisher(.listFunds)
            .mapToResponse(FundListResponse.self)
            .map { $0.asFundEntities() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }

    public func getFundDetails(fundId: String) async throws -> FundEntity {
        return try await client
            .requestPublisher(.fundDetail(id: fundId))
            .mapToResponse(CreateFundResponse.self)
            .map { $0.asFundEntity() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }

    public func deleteFund(fundId: String) async throws -> UUID {
        return try await client
            .requestPublisher(.deleteFund(id: fundId))
            .mapToResponse(DeleteFundResponse.self)
            .map { UUID(uuidString: $0.id)! } // TODO: Handle force cast by creating an entity for ID
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }

    public func getTransactions(fundId: String, ascendingOrder: Bool = false) async throws -> PaginationEntity<TransactionEntity> {
        return try await client
            .requestPublisher(.transactions(fundId: fundId, ascendingOrder: ascendingOrder))
            .mapToResponse(TransactionListResponse.self)
            .map { $0.asPaginationEntity() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }
}
