//
//  PortfolioRepository.swift
//
//
//  Created by Hien Tran on 07/01/2024.
//

import Combine
import CombineExt
import Moya

public struct PortfolioAPIService {
    let client = MoyaClient<PortfolioAPI>()

    public init() {}

    public func getNetworth() async throws -> NetworthResponse {
        return try await client
            .requestPublisher(.networth)
            .mapToResponse(NetworthResponse.self)
            .async()
    }
}
