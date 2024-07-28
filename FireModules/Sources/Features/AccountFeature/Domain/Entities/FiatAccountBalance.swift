import CasePaths
import DomainUtilities
import Foundation

public struct FiatAccountBalance: Value, Equatable {
    public var value: Result<Decimal, MoneyBalanceValidationError> {
        validation.asResult
    }

    public var validation: Validated<Decimal, MoneyBalanceValidationError> {
        validator.validate(balanceValue)
    }

    let validator = PositiveNumberValidator()

    public private(set) var balanceValue: Decimal

    public init(_ initialValue: Decimal) {
        self.balanceValue = initialValue
    }

    public mutating func update(_ newBalance: Decimal) {
        balanceValue = newBalance
    }
}

@CasePathable
public enum MoneyBalanceValidationError: LocalizedError, Equatable {
    case nagativeNumber
}

public struct PositiveNumberValidator: Validator {
    public func validate(_ input: Decimal) -> Validated<Decimal, MoneyBalanceValidationError> {
        guard input >= 0 else {
            return .invalid(input, .nagativeNumber)
        }

        return .valid(input)
    }
}
