import DomainEntities

extension InvestmentPortfolioEntity {
    static func placeholder() -> InvestmentPortfolioEntity {
        return InvestmentPortfolioEntity(
            id: ID.generated(),
            totalInvestment: Money(100_000, codeString: "USD"),
            totalValue: Money(100_000, codeString: "USD"),
            name: "Lorem ipsum",
            timestamp: 0,
            lastModified: 0,
            balances: .empty,
            baseCurrency: Currency.current
        )
    }
}
