//
//  FundsService.swift
//
//
//  Created by Hien Tran on 10/01/2024.
//

import Dependencies
import Foundation
@_exported import Networking
@_exported import SharedModels

public extension DependencyValues {
    var fundsSerivce: FundsService {
        get { self[FundsService.self] }
        set { self[FundsService.self] = newValue }
    }
}

extension FundsService: DependencyKey {
    public static var liveValue = FundsService()
}

public struct FundsService {
    let client = MoyaClient<FundsAPI>()

    public init() {}

    public func createFund(
        name: String,
        balance: Decimal,
        fundType: FundType,
        currency: String,
        description: String?
    ) async throws -> CreateFundResponse {
        return try await client
            .requestPublisher(.createFund(
                name: name,
                balance: balance,
                fundType: fundType,
                currency: currency,
                description: description
            ))
            .mapToResponse(CreateFundResponse.self)
            .async()
    }

    public func listFunds() async throws -> FundListResponse {
        return try await client
            .requestPublisher(.listFunds)
            .mapToResponse(FundListResponse.self)
            .async()
    }

    public func getFundDetails(fundId: String) async throws -> CreateFundResponse {
        return try await client
            .requestPublisher(.fundDetail(id: fundId))
            .mapToResponse(CreateFundResponse.self)
            .async()
    }

    public func deleteFund(fundId: String) async throws -> DeleteFundResponse {
        return try await client
            .requestPublisher(.deleteFund(id: fundId))
            .mapToResponse(DeleteFundResponse.self)
            .async()
    }

    public func getTransactions(fundId: String, ascendingOrder: Bool = false) async throws -> PaginationEntity<TransactionEntity> {
        return try await client
            .requestPublisher(.transactions(fundId: fundId, ascendingOrder: ascendingOrder))
            .mapToResponse(TransactionListModel.self)
            .map { $0.asPaginationEntity() }
            .eraseToAnyPublisher()
            .async()
    }
}
