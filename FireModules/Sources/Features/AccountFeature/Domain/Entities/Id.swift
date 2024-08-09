import CasePaths
import DomainUtilities
import Foundation

public struct Id: Value, Equatable, Identifiable, Hashable {
    public var id: String {
        return idString
    }

    public var value: Result<String, UUIDValidationError> {
        return validator.validate(idString).asResult
    }

    public let idString: String

    private let validator = UUIDValidator()

    public init(_ idString: String) {
        self.idString = idString
    }

    public init?(_ nullableString: String?) {
        if let nullableString {
            self.idString = nullableString
        } else {
            return nil
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(idString)
    }
}

public struct UUIDValidator: RegexValidator {
    public var regex: String {
        "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
    }

    public func validate(_ input: String) -> Validated<String, UUIDValidationError> {
        let regexText = NSPredicate(format: "SELF MATCHES %@", regex)
        return regexText.evaluate(with: input)
            ? .valid(input)
            : .invalid(input, .invalidUUIDFormat)
    }
}

@CasePathable
public enum UUIDValidationError: Equatable, LocalizedError {
    case invalidUUIDFormat
}
