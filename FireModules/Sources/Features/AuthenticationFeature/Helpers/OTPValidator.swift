import DomainEntities
import Foundation

public enum OTPValidationError: Equatable, LocalizedError {
    case otpInvalid
}

public struct OTPValidator: RegexValidator, Equatable {
    let length: Int
    init(length: Int) {
        self.length = length
    }

    public var regex: String { "^[0-9]{\(length)}$" }

    public func validate(_ input: String) -> Validated<String, OTPValidationError> {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: input)
            ? .valid(input)
            : .invalid(input, .otpInvalid)
    }
}

public struct OTP: Value, Equatable {
    public var value: Result<String, OTPValidationError> {
        otpValidator.validate(otpString).asResult
    }

    private let otpValidator = OTPValidator(length: 6)

    public private(set) var otpString: String

    public init(_ otpString: String) {
        self.otpString = otpString
    }

    mutating func update(_ newOTPString: String) {
        otpString = newOTPString
    }
}

public extension OTP {
    static let empty = OTP("")
}
