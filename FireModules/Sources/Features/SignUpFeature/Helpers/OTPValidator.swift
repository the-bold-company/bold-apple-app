import DomainEntities
import Foundation

enum OTPValidationError: Equatable {
    case otpInvalid
}

struct OTPValidator: RegexValidator {
    let length: Int
    init(length: Int) {
        self.length = length
    }

    var regex: String { "^[0-9]{\(length)}$" }

    func validate(_ input: String) -> Validated<String, OTPValidationError> {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: input)
            ? .valid(input)
            : .invalid(input, .otpInvalid)
    }
}
