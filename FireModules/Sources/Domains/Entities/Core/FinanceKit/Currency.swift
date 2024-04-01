import Foundation

public struct Currency: Value, Equatable, Hashable {
    private let currencyValidator = CurrencyValidator()

    public let value: Result<CurrencyCode, CurrencyValidationError>

    public let code: CurrencyCode

    public init(code: CurrencyCode) {
        self.code = code
        let validated = currencyValidator.validate(code)
        self.value = validated.asResult
    }

    public init(codeString: String) {
        self.init(code: CurrencyCode(rawValue: codeString) ?? .none)
    }

    public var symbol: String {
        guard let symbol = MoneyKit.shared.findSymbol(for: code.rawValue) else {
            return ""
        }

        return symbol
    }

    public var currencyCodeString: String {
        return code.rawValue
    }

    public var currencyLocale: Locale {
        let localeIdentifier = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: code.rawValue])
        return Locale(identifier: localeIdentifier)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}

public extension Currency {
    static let current = Currency(codeString: Locale.current.currency!.identifier)
}

public enum CurrencyValidationError: LocalizedError {
    case symbolNotFound
}

public struct CurrencyValidator: Validator {
    public func validate(_ input: CurrencyCode) -> Validated<CurrencyCode, CurrencyValidationError> {
        return input != .none
            ? .valid(input)
            : .invalid(input, .symbolNotFound)
    }
}
