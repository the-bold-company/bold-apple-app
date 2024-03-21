import Foundation

public struct Currency: Value, Equatable {
    let currencyValidator = CurrencyValidator()

    public let value: Result<String, CurrencyValidationError>
    public let validated: Validated<String, CurrencyValidationError>

    init(currency: String) {
        self.validated = currencyValidator.callAsFunction(currency)
        self.value = validated.asResult
    }

    public var symbol: String {
        guard isValid else { return "" }

        guard let symbol = CurrencyKit.shared.findSymbol(for: getOrCrash()) else {
            return ""
        }

        return symbol
    }
}

public enum CurrencyValidationError: LocalizedError {
    case symbolNotFound
}

public struct CurrencyValidator: Validator {
    public func validate(_ input: String) -> Validated<String, CurrencyValidationError> {
        guard let symbol = CurrencyKit.shared.findSymbol(for: input) else {
            return .invalid(input, .symbolNotFound)
        }

        return .valid(input)
    }
}
