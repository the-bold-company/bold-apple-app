import DomainUtilities
import Foundation

public enum PasswordValidationError: Int, Equatable, LocalizedError, CaseIterable {
    case incorrectLength = 0
    case notContainLowercaseCharacter = 1
    case notContainUppercaseCharacter = 2
    case notContainNumericCharacter = 3
    case notContainSpecialCharacter = 4

    var ruleDescription: String {
        switch self {
        case .incorrectLength:
            return "Có ít nhất 8 chữ cái"
        case .notContainLowercaseCharacter:
            return "Có chứa chữ cái thường"
        case .notContainUppercaseCharacter:
            return "Có chứa chữ cái viết hoa"
        case .notContainNumericCharacter:
            return "Có chứa số"
        case .notContainSpecialCharacter:
            return "Có chứa ký tự đặc biệt"
        }
    }
}

struct LengthValidator: Validator {
    let min: Int
    let max: Int

    func validate(_ input: String) -> Validated<String, PasswordValidationError> {
        if input.count < min {
            return .invalid(input, .incorrectLength)
        } else if input.count > max {
            return .invalid(input, .incorrectLength)
        }

        return .valid(input)
    }
}

struct NumericLetterValidator: RegexValidator {
    let min: Int

    init(atleast min: Int = 1) {
        self.min = min
    }

    var regex: String {
        return "^(?=(?:.*[0-9]){\(min)}).*$"
    }

    func validate(_ input: String) -> Validated<String, PasswordValidationError> {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: input)
            ? .valid(input)
            : .invalid(input, .notContainNumericCharacter)
    }
}

struct LowercaseLetterValidator: RegexValidator {
    let min: Int

    init(atleast min: Int = 1) {
        self.min = min
    }

    var regex: String {
        return "^(?=(?:.*[a-z]){\(min)}).*$"
    }

    func validate(_ input: String) -> Validated<String, PasswordValidationError> {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: input)
            ? .valid(input)
            : .invalid(input, .notContainLowercaseCharacter)
    }
}

struct UppercaseLetterValidator: RegexValidator {
    let min: Int

    init(atleast min: Int = 1) {
        self.min = min
    }

    var regex: String {
        return "^(?=(?:.*[A-Z]){\(min)}).*$"
    }

    func validate(_ input: String) -> Validated<String, PasswordValidationError> {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: input)
            ? .valid(input)
            : .invalid(input, .notContainUppercaseCharacter)
    }
}

/// This validator ensure that an inout of type [String] will always have at least
/// x special characters. `x` is defined through the constructor, default is 1
///
/// Special characters include: !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~.
/// Ref: https://owasp.org/www-community/password-special-characters
struct SpecilaCharacterValidator: RegexValidator {
    let min: Int

    init(atleast min: Int = 1) {
        self.min = min
    }

    var regex: String {
//        return "^(?=(?:.*[!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~]){\(min)}).*$"
        return "^(?=(?:.*[!\"#$%&'()*+,-./:;<=>?@\\[\\]^_`{|}~]){\(min)}).*$"
//        return "^(?=(?:.*[!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~]){\(min)}).*$"
    }

    func validate(_ input: String) -> Validated<String, PasswordValidationError> {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: input)
            ? .valid(input)
            : .invalid(input, .notContainSpecialCharacter)
    }
}

struct PasswordValidator: Validator {
    typealias Input = String
    typealias Error = PasswordValidationError

    var body: some Validator<String, PasswordValidationError> {
        LengthValidator(min: 8, max: 60)
        LowercaseLetterValidator(atleast: 1)
        UppercaseLetterValidator(atleast: 1)
        NumericLetterValidator(atleast: 1)
        SpecilaCharacterValidator(atleast: 1)
    }
}

public struct Password: Value, Equatable {
    public var value: Result<String, PasswordValidationError> {
        return validators.validate(passwordString).asResult
    }

    private let validators = ValidatorCollection(
        LengthValidator(min: 8, max: 60).eraseToAnyValidator(),
        LowercaseLetterValidator(atleast: 1).eraseToAnyValidator(),
        UppercaseLetterValidator(atleast: 1).eraseToAnyValidator(),
        NumericLetterValidator(atleast: 1).eraseToAnyValidator(),
        SpecilaCharacterValidator(atleast: 1).eraseToAnyValidator()
    )

    public private(set) var passwordString: String

    public init(_ passwordString: String) {
        self.passwordString = passwordString
    }

    public func validateAll() -> [Validated<String, PasswordValidationError>] {
        validators.validateAll(passwordString)
    }

    public mutating func update(_ newPassword: String) {
        passwordString = newPassword
    }
}

public extension Password {
    static let empty = Password("")
}
