import DomainEntities
import Foundation

struct GetPortfolioResponse: Decodable {
    let id: String
    let totalInvestment: Decimal
    let totalValue: Decimal
    let name: String
    let timestamp: Int
    let description: String?
    let lastModified: Int
    let balances: [String: Decimal]

    init(from decoder: Decoder) throws {
        self.id = try decoder.decode("portfolioId")
        self.totalInvestment = try decoder.decode("totalInvestment")
        self.totalValue = try decoder.decode("totalValue")
        self.name = try decoder.decode("portfolioName")
        self.timestamp = try decoder.decode("timestamp")
        self.description = try decoder.decodeIfPresent("description")
        self.lastModified = try decoder.decode("lastModified")
        self.balances = try decoder.decodeIfPresent("balances") ?? [:]
    }
}

extension GetPortfolioResponse {
    func asPortfolioEntity() -> InvestmentPortfolioEntity {
        return InvestmentPortfolioEntity(
            id: ID(uuidString: id),
            totalInvestment: Money(amount: totalInvestment),
            totalValue: Money(amount: totalValue),
            name: name,
            timestamp: timestamp,
            description: description,
            lastModified: lastModified
        )
    }
}
