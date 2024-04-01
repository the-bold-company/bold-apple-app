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
            .mapToResponse(CurrencyConversionResponse.self)
            .map { $0.asCurrencyConverterEntity() }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }
}
