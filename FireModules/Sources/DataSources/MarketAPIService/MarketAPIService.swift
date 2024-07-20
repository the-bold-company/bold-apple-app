import DomainEntities
import Foundation
import MarketAPIServiceInterface
import Networking

public struct MarketAPIService: MarketAPIServiceInterface {
    private let client = MoyaClient<MarketAPI>()

    public init() {}

    public func convertCurrency(amount: Decimal, from fromCurrency: String, to toCurrency: String) async throws -> CurrencyConversionEntity {
        return try await client
            .requestPublisher(.convertCurrency(amount: amount, fromCurrency: fromCurrency, toCurrency: toCurrency))
            .mapToResponse(CurrencyConversionResponse.self, apiVersion: .v0)
            .map { $0.asCurrencyConverterEntity() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }

    public func searchSymbol(_ searchedString: String) async throws -> [SymbolDisplayEntity] {
        return try await client
            .requestPublisher(.searchSymbol(searchedString))
            .mapToResponse(SymbolSearchResultResponse.self, apiVersion: .v0)
            .map { $0.asSymbolEntityList() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }

    public func getTrendingAssets() async throws -> [SymbolDisplayEntity] {
        return []
    }
}
