//
//  PortfolioListResponse.swift
//
//
//  Created by Hien Tran on 19/03/2024.
//

import Codextended
import DomainEntities

struct PortfolioListResponse: Decodable {
    public let portfolios: [GetPortfolioResponse]

    public init(from decoder: Decoder) throws {
        self.portfolios = try decoder.decode("portfolios")
    }
}

extension PortfolioListResponse {
    func asPortfolioEntities() -> [InvestmentPortfolioEntity] {
        return portfolios.map { $0.asPortfolioEntity() }
    }
}
