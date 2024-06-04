//
//  InvestmentPortfolioEntity+Mock.swift
//
//
//  Created by Hien Tran on 19/03/2024.
//

import DomainEntities

public extension InvestmentPortfolioEntity {
    static let emptyPortfolio = InvestmentPortfolioEntity(
        id: ID(uuidString: "0feef1d1-eea7-46ce-a70d-bd9406984311"),
        name: "My portfolio",
        timestamp: 0,
        lastModified: 0,
        baseCurrency: Currency(code: .unitedStatesDollar)
    )

    static let stockPortfolio = InvestmentPortfolioEntity(
        id: ID(uuidString: "fa1e8dd4-e10d-4d4c-a283-b9d00ccfd980"),
        name: "My stock portfolio",
        timestamp: 0,
        lastModified: 0,
        baseCurrency: Currency(code: .unitedStatesDollar)
    )

    static let stockPortfolio1 = InvestmentPortfolioEntity(
        id: ID(uuidString: "6166c96c-5fba-47dc-b1f5-d7659b0b62fb"),
        name: "My another stock portfolio",
        timestamp: 0,
        lastModified: 0,
        balances: [
            Money(1000, currency: Currency(code: .unitedStatesDollar)),
            Money(3000, currency: Currency(code: .australianDollar)),
        ],
        baseCurrency: Currency(code: .unitedStatesDollar)
    )

    static let invalidPortfolio = InvestmentPortfolioEntity(
        id: ID(uuidString: "509dccb9-c564-4a1e-8a37-11a8efe8312e"),
        name: "Invalid portfolio",
        timestamp: 0,
        lastModified: 0,
        balances: [
            Money(1000, currency: Currency(code: .none)),
        ],
        baseCurrency: Currency(code: .unitedStatesDollar)
    )

    static let invalidPortfolio1 = InvestmentPortfolioEntity(
        id: ID(uuidString: "166a1601-b39b-4a07-84e4-1e836f77b9ba"),
        name: "Invalid portfolio",
        timestamp: 0,
        lastModified: 0,
        balances: [
            Money(3000, currency: Currency(codeString: "QWERTY")),
        ],
        baseCurrency: Currency(code: .unitedStatesDollar)
    )

    static func emptyPortfolioWithName(_ name: String) -> InvestmentPortfolioEntity {
        return InvestmentPortfolioEntity(
            id: ID(uuidString: "0feef1d1-eea7-46ce-a70d-bd9406984311"),
            name: name,
            timestamp: 0,
            lastModified: 0,
            baseCurrency: Currency(code: .unitedStatesDollar)
        )
    }

    static let portfolioList: [InvestmentPortfolioEntity] = [
        emptyPortfolio,
        stockPortfolio,
    ]
}
