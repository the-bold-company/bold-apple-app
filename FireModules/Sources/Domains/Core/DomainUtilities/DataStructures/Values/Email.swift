import CasePaths
import Foundation

public struct Email: Value, Equatable {
    public var value: Result<String, EmailValidationError> {
        validators.validate(emailString).asResult
    }

    public let validators = ValidatorCollection(
        NotEmpty().eraseToAnyValidator(),
        EmailPatternValidator().eraseToAnyValidator()
    )

    public private(set) var emailString: String

    public init(_ emailString: String) {
        self.emailString = emailString
    }

    public func validateAll() -> [Validated<String, EmailValidationError>] {
        validators.validateAll(emailString)
    }

    public mutating func update(_ newEmail: String) {
        emailString = newEmail
    }
}

public extension Email {
    static let empty = Email("")
}

@CasePathable
public enum EmailValidationError: LocalizedError, Equatable {
    case patternInvalid
    case fieldEmpty
}

public struct EmailPatternValidator: RegexValidator {
    public var regex: String {
        return Regex.emailRegex
    }

    public func validate(_ input: String) -> Validated<String, EmailValidationError> {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: input)
            ? .valid(input)
            : .invalid(input, .patternInvalid)
    }
}

public struct NotEmpty: Validator {
    public func validate(_ input: String) -> Validated<String, EmailValidationError> {
        !input.isEmpty
            ? .valid(input)
            : .invalid(input, .fieldEmpty)
    }
}

public struct EmailValidator: Validator {
    public typealias Input = String
    public typealias Error = EmailValidationError

    public var body: some Validator<String, EmailValidationError> {
        NotEmpty()
        EmailPatternValidator()
    }
}
