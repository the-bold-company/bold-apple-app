import DomainEntities

extension InvestmentPortfolioEntity {
    static func placeholder() -> InvestmentPortfolioEntity {
        return InvestmentPortfolioEntity(
            id: ID.generated(),
            totalInvestment: Money(amount: 100_000),
            totalValue: Money(amount: 100_000),
            name: "Lorem ipsum",
            timestamp: 0,
            lastModified: 0
        )
    }
}
