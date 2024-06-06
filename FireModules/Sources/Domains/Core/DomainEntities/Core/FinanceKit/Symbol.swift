public struct Symbol: Value, Equatable, Hashable, Identifiable {
    public let value: Result<String, SymbolValidationError>

    public let symbol: String

    public var id: String {
        return symbol
    }

    public init(_ symbol: String) {
        self.symbol = symbol
        if symbol.isEmpty {
            self.value = .failure(.symbolNotFound)
        } else {
            self.value = .success(symbol)
        }
    }
}

extension Symbol: Comparable {
    public static func < (lhs: Symbol, rhs: Symbol) -> Bool {
        lhs.symbol < rhs.symbol
    }
}

extension Symbol: CustomStringConvertible {
    public var description: String {
        symbol
    }
}

public enum SymbolValidationError: ValidationError {
    case symbolNotFound
}
