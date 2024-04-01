import DomainEntities
import Foundation

public protocol MarketAPIServiceInterface {
    func convertCurrency(amount: Decimal, from fromCurrency: String, to toCurrency: String) async throws -> CurrencyConversionEntity
}
