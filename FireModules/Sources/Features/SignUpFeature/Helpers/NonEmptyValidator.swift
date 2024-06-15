import DomainUtilities
import Foundation

public enum StringValidationError: LocalizedError, Equatable {
    case empty
}

public struct NotEmptyValidator: Validator {
    public func validate(_ input: String) -> Validated<String, StringValidationError> {
        !input.isEmpty
            ? .valid(input)
            : .invalid(input, .empty)
    }
}

public struct NonEmptyString: Value, Equatable {
    public var value: Result<String, StringValidationError> {
        validator.validate(string).asResult
    }

    public let validator = NotEmptyValidator()

    public private(set) var string: String

    public init(_ string: String) {
        self.string = string
    }

    mutating func update(_ newString: String) {
        string = newString
    }
}
