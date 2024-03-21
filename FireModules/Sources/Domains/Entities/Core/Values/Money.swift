import Foundation

public struct Money: Value, Equatable {
    public let value: Result<Decimal, NeverFail>

    public init(amount: Decimal) {
        self.value = .success(amount)
    }

    public func formatUsingLocale(locale: Locale = Locale(identifier: "en_US")) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.locale = locale
        return formatter.string(from: NSDecimalNumber(decimal: getOrCrash()))!
    }

    public static let zero = Money(amount: 0)
}
