import DomainEntities
import Foundation

struct CurrencyConversionResponse: Decodable {
    let symbol: String
    let rate: Double
    let amount: Decimal
    let timestamp: Int

    init(from decoder: Decoder) throws {
        self.symbol = try decoder.decode("symbol")
        self.rate = try decoder.decode("rate")
        self.amount = try decoder.decode("amount")
        self.timestamp = try decoder.decode("timestamp")
    }

    var pairs: (from: String, to: String) {
        let currencies = symbol.split(separator: "/").map { String($0) }
        return (from: currencies[0], to: currencies[1])
    }

    var fromCurrency: String {
        return pairs.from
    }

    var toCurrency: String {
        return pairs.to
    }
}

extension CurrencyConversionResponse {
    func asCurrencyConverterEntity() -> CurrencyConversionEntity {
        return CurrencyConversionEntity(
            fromCurrency: Currency(codeString: fromCurrency),
            toCurrency: Currency(codeString: toCurrency),
            convertedAmount: Money(amount, codeString: toCurrency),
            rate: rate,
            timestamp: timestamp
        )
    }
}
