import DomainEntities

public extension CurrencyConversionEntity {
    static func convertMock(
        amount: Money,
        to targetCurrency: Currency,
        rate: Double
    ) -> CurrencyConversionEntity {
        CurrencyConversionEntity(
            fromCurrency: amount.currency,
            toCurrency: targetCurrency,
            convertedAmount: (amount * rate).changeCurrency(to: targetCurrency),
            rate: rate,
            timestamp: 0
        )
    }
}
