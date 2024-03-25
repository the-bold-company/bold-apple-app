import Foundation

public struct Currency: Value, Equatable {
    private let currencyValidator = CurrencyValidator()

    public let value: Result<String, CurrencyValidationError>
    public let validated: Validated<String, CurrencyValidationError>
    public let currencyCode: String

    public init(currencyCode: String) {
        self.currencyCode = currencyCode
        self.validated = currencyValidator.callAsFunction(currencyCode)
        self.value = validated.asResult
    }

    public var symbol: String {
        guard isValid else { return "" }

        guard let symbol = CurrencyKit.shared.findSymbol(for: getOrCrash()) else {
            return ""
        }

        return symbol
    }

    public var locale: Locale {
        let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode])
        return Locale(identifier: localeIdentifier)
    }
}

public enum CurrencyValidationError: LocalizedError {
    case symbolNotFound
}

public struct CurrencyValidator: Validator {
    public func validate(_ input: String) -> Validated<String, CurrencyValidationError> {
        guard let _ = CurrencyKit.shared.findSymbol(for: input) else {
            return .invalid(input, .symbolNotFound)
        }

        return .valid(input)
    }
}
