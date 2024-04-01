import Foundation

/// `CurrencyFormatter` lets you format a number of monetary amounts with a currency symbol or code.
public struct CurrencyFormatter {
    /// The users locale.
    public let locale: Locale

    /// The currency to use when formatting.
    public let currency: Currency

    private let formatter = NumberFormatter.currency

    /// Initialize a new formatter with a specified currency and locale.
    /// Locale is an optional parameter and defaults to `.autoupdatingCurrent`.
    public init(currency: Currency, locale: Locale = .autoupdatingCurrent) {
        self.currency = currency
        self.locale = locale

        formatter.locale = locale
        formatter.currencySymbol = currency.symbol

        if currency.code == .none {
            formatter.numberStyle = .decimal
        }
    }

    /// Returns a formatted string from a `Money`-value, or nil if formatting fails.
    public func string(from money: Money) -> String {
        return formatter.string(from: money.amount.asDecimalNumber) ?? ""
    }
}

public extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.alwaysShowsDecimalSeparator = true
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        return formatter
    }

    static var monetary: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = true
        formatter.numberStyle = .decimal
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        return formatter
    }
}
