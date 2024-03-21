//
//  InvestmentPortfolioEntity+Mock.swift
//
//
//  Created by Hien Tran on 19/03/2024.
//

import DomainEntities

public extension InvestmentPortfolioEntity {
    static let emptyPortfolio = InvestmentPortfolioEntity(
        id: "0feef1d1-eea7-46ce-a70d-bd9406984311",
        name: "My portfolio",
        timestamp: 0,
        lastModified: 0
    )

    static let stockPortfolio = InvestmentPortfolioEntity(
        id: "fa1e8dd4-e10d-4d4c-a283-b9d00ccfd980",
        name: "My stock portfolio",
        timestamp: 0,
        lastModified: 0
    )

    static func emptyPortfolioWithName(_ name: String) -> InvestmentPortfolioEntity {
        return InvestmentPortfolioEntity(
            id: "0feef1d1-eea7-46ce-a70d-bd9406984311",
            name: name,
            timestamp: 0,
            lastModified: 0
        )
    }

    static let portfolioList: [InvestmentPortfolioEntity] = [
        emptyPortfolio,
        stockPortfolio,
    ]
}
