import DomainEntities

public extension InvestmentTransactionEntity {
    static let stockTransaction = InvestmentTransactionEntity(
        id: ID(uuidString: "aa141987-86b4-4234-a856-aba33b5b95e1"),
        portfolioId: InvestmentPortfolioEntity.stockPortfolio.id,
        type: .deposit,
        amount: Money(1000, currency: Currency(code: .unitedStatesDollar)),
        timestamp: 0,
        reason: ""
    )
}

public extension [InvestmentTransactionEntity] {
    static let mock: [InvestmentTransactionEntity] = [
        InvestmentTransactionEntity.stockTransaction,
        InvestmentTransactionEntity(
            id: ID(uuidString: "aa141987-86b4-4234-a856-aba33b5b1234"),
            portfolioId: InvestmentPortfolioEntity.stockPortfolio.id,
            type: .deposit,
            amount: Money(500, currency: Currency(code: .dong)),
            timestamp: 0,
            reason: ""
        ),
        InvestmentTransactionEntity(
            id: ID(uuidString: "aa141987-86b4-4234-a856-aba33b5b6789"),
            portfolioId: InvestmentPortfolioEntity.stockPortfolio.id,
            type: .deposit,
            amount: Money(1000, currency: Currency(code: .singaporeDollar)),
            timestamp: 0,
            reason: ""
        ),
    ]
}
