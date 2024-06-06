import DomainUtilities
import Foundation

enum EmailValidationError: LocalizedError, Equatable {
    case patternInvalid
    case fieldEmpty

    var errorDescription: String? {
        switch self {
        case .patternInvalid:
            return "Email không hợp lệ. Bạn hãy thử lại nhé."
        case .fieldEmpty:
            return "Vui lòng điền thông tin"
        }
    }
}

struct EmailPatternValidator: RegexValidator {
    var regex: String {
        return Regex.emailRegex
    }

    func validate(_ input: String) -> Validated<String, EmailValidationError> {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: input)
            ? .valid(input)
            : .invalid(input, .patternInvalid)
    }
}

struct NotEmpty: Validator {
    func validate(_ input: String) -> Validated<String, EmailValidationError> {
        !input.isEmpty
            ? .valid(input)
            : .invalid(input, .fieldEmpty)
    }
}

struct EmailValidator: Validator {
    typealias Input = String
    typealias Error = EmailValidationError

    var body: some Validator<String, EmailValidationError> {
        NotEmpty()
        EmailPatternValidator()
    }
}
