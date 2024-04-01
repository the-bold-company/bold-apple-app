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
