import Foundation

public typealias MoneyComposition = (amount: Decimal, currencyCode: String, symbol: String)

public struct Money: Value {
    public let value: Result<MoneyComposition, CurrencyValidationError>

    public let amount: Decimal
    public let currency: Currency

    public var compositions: MoneyComposition {
        return (amount: amount, currencyCode: currency.code.rawValue, symbol: currency.symbol)
    }

    public init(_ amount: Decimal, codeString: String) {
        self.init(amount, currency: Currency(codeString: codeString))
    }

    public init(_ amount: Decimal, currency: Currency) {
        self.currency = currency
        self.amount = amount
        switch currency.value {
        case let .success(currencyCode):
            self.value = .success((amount: amount, currencyCode: currencyCode.rawValue, symbol: currency.symbol))
        case let .failure(error):
            self.value = .failure(error)
        }
    }

    /// - returns: Formatted rounded amount with currency symbol.
    public var formattedString: String {
        let formatter = NumberFormatter.currency
        formatter.locale = currency.currencyLocale
        formatter.currencySymbol = currency.symbol
        return formatter.string(from: amount.asDecimalNumber) ?? ""
    }

    /// Converts and returns a new `Money` in the given currency with a new amount.
    /// - Parameter to: The currency the money should be in.
    /// - Parameter at: The conversion rate to use.
    /// - Returns: A new `Money` with the converted amount in the given currency.
    public func convert(to targetCurrency: Currency, at rate: ExchangeRate) -> Self {
        let converter = CurrencyConverter()
        return converter.convert(self, to: targetCurrency, at: rate)
    }

    public func changeCurrency(to currency: Currency) -> Money {
        guard self.currency != currency else { return self }
        return Money(amount, currency: currency)
    }
}

extension Money: Equatable {
    public static func == (lhs: Money, rhs: Money) -> Bool {
        return lhs.currency == rhs.currency && lhs.amount == rhs.amount
    }
}

extension Money: Comparable {
    public static func < (lhs: Money, rhs: Money) -> Bool {
        guard lhs.currency == rhs.currency else {
            fatalError("Cannot compare `Money` with different currency")
        }
        return lhs.amount < rhs.amount
    }
}

public extension Money {
    /// Add two monetary amounts. This function will throw a fatal error if performed on `Money` types with different `Currency`s.
    static func + (lhs: Money, rhs: Money) -> Money {
        guard lhs.currency == rhs.currency else {
            fatalError("Cannot perform operation on `Money` data types with different currencies")
        }
        return Money(lhs.amount + rhs.amount, currency: lhs.currency)
    }

    /// Adds one monetary amount to another. This function will throw a fatal error if performed on `Money` types with different `Currency`s.
    static func += (lhs: inout Money, rhs: Money) {
        lhs = lhs + rhs
    }

    /// Subtract two monetary amounts. This function will throw a fatal error if performed on `Money` types with different `Currency`s.
    static func - (lhs: Money, rhs: Money) -> Money {
        guard lhs.currency.code == rhs.currency.code else {
            fatalError("Cannot perform operation on `Money` data types with different currencies")
        }
        return Money(lhs.amount - rhs.amount, currency: lhs.currency)
    }

    /// Subtracts one monetary amount from another. This function will throw a fatal error if performed on `Money` types with different `Currency`s.
    static func -= (lhs: inout Money, rhs: Money) {
        lhs = lhs - rhs
    }
}

public extension Money {
    /// Negates the monetary amount.
    static prefix func - (money: Money) -> Money {
        return Money(-money.amount, currency: money.currency)
    }
}

public extension Money {
    /// The product of a monetary amount and a scalar value.
    static func * (lhs: Money, rhs: Decimal) -> Money {
        return Money(lhs.amount * rhs, currency: lhs.currency)
    }

    /// The product of a monetary amount and a scalar value.
    static func * (lhs: Money, rhs: Double) -> Money {
        return Money(lhs.amount * Decimal(rhs), currency: lhs.currency)
    }

    /// The product of a monetary amount and a scalar value.
    static func * (lhs: Money, rhs: Int) -> Money {
        return lhs * Decimal(rhs)
    }

    /// The product of a monetary amount and a scalar value.
    static func * (lhs: Decimal, rhs: Money) -> Money {
        return rhs * lhs
    }

    /// The product of a monetary amount and a scalar value.
    static func * (lhs: Int, rhs: Money) -> Money {
        return rhs * lhs
    }

    /// Multiplies a monetary amount by a scalar value.
    static func *= (lhs: inout Money, rhs: Decimal) {
        lhs = lhs * rhs
    }

    /// Multiplies a monetary amount by a scalar value.
    static func *= (lhs: inout Money, rhs: Double) {
        lhs = lhs * rhs
    }

    /// Multiplies a monetary amount by a scalar value.
    static func *= (lhs: inout Money, rhs: Int) {
        lhs = lhs * Decimal(rhs)
    }
}

public extension Money {
    static let zero = Money(0, currency: .current)
    static func zero(currency: Currency) -> Money {
        return Money(0, currency: currency)
    }
}

public extension Money {
    /// - returns: True if the amount is exactly zero.
    var isZero: Bool {
        amount == 0
    }

    /// - returns: True if the rounded amount is positive, i.e. zero or more.
    var isPositive: Bool {
        isZero || isGreaterThanZero
    }

    /// - returns: True if the rounded amount is less than zero, or false if the amount is zero or more.
    var isNegative: Bool {
        amount < 0.0
    }

    /// - returns: True if the rounded amount is greater than zero, or false if the amount is zero or less.
    var isGreaterThanZero: Bool {
        amount > 0.0
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Money) {
        appendInterpolation(value.formattedString)
    }
}

// fileprivate extension Decimal {
//    func rounded(for currency: Currency) -> Decimal {
//        var approximate = self
//        var rounded = Decimal()
//        NSDecimalRound(&rounded, &approximate, currency.minorUnit, .bankers)
//
//        return rounded
//    }
// }

public extension Decimal {
    /// Convert a decimal number to `Money` in a given currency.
    /// - Parameter currency: A currency the money is in.
    /// - Returns: A new `Money` with the current amount in the given currency.
    func `in`(_ currency: Currency) -> Money {
        Money(self, currency: currency)
    }
}

extension Money: CustomStringConvertible {
    public var description: String {
        "\(amount)"
    }
}
