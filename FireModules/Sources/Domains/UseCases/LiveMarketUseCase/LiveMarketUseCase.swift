import MarketAPIServiceInterface

public struct LiveMarketUseCase: LiveMarketUseCaseInterface {
    private let marketAPIService: MarketAPIServiceInterface

    public init(marketAPIService: MarketAPIServiceInterface) {
        self.marketAPIService = marketAPIService
    }

    public func convertCurrency(money: Money, to toCurrency: Currency) async -> DomainResult<CurrencyConversionEntity> {
        return await autoCatch {
            let conversion = try await marketAPIService.convertCurrency(amount: money.amount, from: money.currency.currencyCodeString, to: toCurrency.currencyCodeString)
            return conversion
        }
    }

    public func searchSymbol(_ searchedString: String) async -> DomainResult<[SymbolDisplayEntity]> {
        return await autoCatch {
            try await marketAPIService.searchSymbol(searchedString)
        }
    }
}
