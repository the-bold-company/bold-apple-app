import CasePaths
import Foundation

@CasePathable
public enum Validated<Value, Error> {
    case idle(Value)
    case valid(Value)
    case invalid(Value, Error)

    public var value: Value {
        switch self {
        case let .idle(value): return value
        case let .invalid(value, _): return value
        case let .valid(value): return value
        }
    }

    public var isIdle: Bool {
        switch self {
        case .valid, .invalid: return false
        case .idle: return true
        }
    }

    public var isValid: Bool {
        switch self {
        case .idle, .invalid: return false
        case .valid: return true
        }
    }

    public var error: Error? {
        switch self {
        case .idle, .valid: return nil
        case let .invalid(_, validationError): return validationError
        }
    }
}

extension Validated: Equatable where Value: Equatable, Error: Equatable {
    public static func == (lhs: Validated, rhs: Validated) -> Bool {
        switch (lhs, rhs) {
        case let (.idle(lValue), .idle(rValue)): return lValue == rValue
        case let (.valid(lValue), .valid(rValue)): return lValue == rValue
        case let (.invalid(lValue, lError), .invalid(rValue, rError)): return lValue == rValue && lError == rError
        default: return false
        }
    }
}

public extension Validated {
    func replacing(error: Error) -> Validated {
        switch self {
        case .idle, .valid: return self
        case let .invalid(value, _): return .invalid(value, error)
        }
    }
}

public extension Validated where Error: LocalizedError {
    func localizeError() -> Validated<Value, DomainError> {
        switch self {
        case let .idle(value):
            return Validated<Value, DomainError>.idle(value)
        case let .valid(value):
            return Validated<Value, DomainError>.valid(value)
        case let .invalid(value, error): return .invalid(value, error.eraseToDomainError())
        }
    }

    var asResult: Result<Value, Error> {
        switch self {
        case let .valid(value): return .success(value)
        case let .invalid(_, error): return .failure(error)
        case .idle:
            fatalError("\(Self.self) is in idle state. Cannot convert to `Result`")
        }
    }
}
