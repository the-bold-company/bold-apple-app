import DomainEntities
import Foundation

public protocol MarketAPIServiceInterface {
    func convertCurrency(amount: Decimal, from fromCurrency: String, to toCurrency: String) async throws -> CurrencyConversionEntity
    func searchSymbol(_ searchedString: String) async throws -> [SymbolDisplayEntity]
    func getTrendingAssets() async throws -> [SymbolDisplayEntity]
}
