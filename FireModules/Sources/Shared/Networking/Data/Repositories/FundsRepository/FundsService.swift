//
//  FundsService.swift
//
//
//  Created by Hien Tran on 10/01/2024.
//

import CombineExt
import CombineMoya
import Foundation

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
}
