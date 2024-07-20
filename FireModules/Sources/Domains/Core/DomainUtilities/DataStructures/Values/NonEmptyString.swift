import Foundation

public struct NonEmptyString: Value, Equatable {
    public var value: Result<String, NonEmptyStringValidationError> {
        validation.asResult
    }

    public var validation: Validated<String, NonEmptyStringValidationError> {
        validator.validate(string)
    }

    public let validator = NotEmptyValidator()

    public private(set) var string: String

    public init(_ string: String) {
        self.string = string
    }

    public mutating func update(_ newString: String) {
        string = newString
    }
}

public enum NonEmptyStringValidationError: LocalizedError, Equatable {
    case empty
}

public struct NotEmptyValidator: Validator {
    public func validate(_ input: String) -> Validated<String, NonEmptyStringValidationError> {
        !input.isEmpty
            ? .valid(input)
            : .invalid(input, .empty)
    }
}
