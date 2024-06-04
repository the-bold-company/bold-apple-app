
import Foundation

public typealias ExchangeRate = Double

public struct CurrencyConverter {
    public init() {}

    /// Converts and returns a new `Money` in the given currency with a new amount.
    /// - Parameters:
    ///   - money: An amount to convert from.
    ///   - toCurrency: The currency to convert to
    ///   - rate: The conversion rate to use.
    /// - Returns: A new `Money` with the converted amount in the given currency.
    public func convert(_ money: Money, to toCurrency: Currency, at rate: ExchangeRate) -> Money {
        return Money(money.amount * Decimal(rate), currency: toCurrency)
    }
}
