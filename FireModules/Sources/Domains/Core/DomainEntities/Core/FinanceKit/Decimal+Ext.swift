import Foundation

public extension Decimal {
    var asDecimalNumber: NSDecimalNumber {
        NSDecimalNumber(decimal: self)
    }
}
