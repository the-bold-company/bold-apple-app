public struct CurrencyConversionEntity: Equatable {
    public let fromCurrency: Currency
    public let toCurrency: Currency
    public let convertedAmount: Money
    public let rate: ExchangeRate
    public let timestamp: Int

    public init(fromCurrency: Currency, toCurrency: Currency, convertedAmount: Money, rate: ExchangeRate, timestamp: Int) {
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.convertedAmount = convertedAmount
        self.rate = rate
        self.timestamp = timestamp
    }
}
