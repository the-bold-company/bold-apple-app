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
    let currency: String

    init(from decoder: Decoder) throws {
        self.id = try decoder.decode("portfolioId")
        self.totalInvestment = try decoder.decode("totalInvestment")
        self.totalValue = try decoder.decode("totalValue")
        self.name = try decoder.decode("portfolioName")
        self.timestamp = try decoder.decode("timestamp")
        self.description = try decoder.decodeIfPresent("description")
        self.lastModified = try decoder.decode("lastModified")
        self.balances = try decoder.decodeIfPresent("balances") ?? [:]
        self.currency = try decoder.decode("currency")
    }
}

extension GetPortfolioResponse {
    func asPortfolioEntity() -> InvestmentPortfolioEntity {
        return InvestmentPortfolioEntity(
            id: ID(uuidString: id),
            totalInvestment: Money(totalInvestment, codeString: currency),
            totalValue: Money(totalValue, codeString: currency),
            name: name,
            timestamp: timestamp,
            description: description,
            lastModified: lastModified,
            balances: balances.map {
                Money($1, codeString: $0)
            },
            baseCurrency: Currency(codeString: currency)
        )
    }
}

extension Dictionary {
    func mapKeysAndValues<K, V>(_ transform: (Key, Value) -> (K, V)) -> [K: V] {
        var result = [K: V]()
        for (key, value) in self {
            let (newKey, newValue) = transform(key, value)
            result[newKey] = newValue
        }
        return result
    }
}
