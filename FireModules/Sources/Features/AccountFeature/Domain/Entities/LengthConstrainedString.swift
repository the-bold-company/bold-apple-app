import CasePaths
import DomainEntities
import DomainUtilities
import Foundation

public struct LengthConstrainedString: Value, Equatable {
    public var value: Result<String, LengthConstrainedValidationError> {
        validation.asResult
    }

    public var validation: Validated<String, LengthConstrainedValidationError> {
        validator.validate(valueString)
    }

    let validator: LengthConstrainedValidator

    public private(set) var valueString: String

    public init(lengthRange: ClosedRange<Int>, initialValue: String) {
        self.validator = LengthConstrainedValidator(range: lengthRange)
        self.valueString = initialValue
    }
}

public struct DefaultLengthConstrainedString: Value, Equatable {
    public var value: Result<String, LengthConstrainedValidationError> {
        validation.asResult
    }

    public var validation: Validated<String, LengthConstrainedValidationError> {
        validator.validate(valueString)
    }

    let validator = LengthConstrainedValidator(range: 0 ... 255)

    public private(set) var valueString: String

    public init(_ initialValue: String) {
        self.valueString = initialValue
    }
}

@CasePathable
public enum LengthConstrainedValidationError: LocalizedError, Equatable {
    case shorterThanMin(_ min: Int)
    case longerThanMax(_ max: Int)
}

public struct LengthConstrainedValidator: Validator {
    private let range: ClosedRange<Int>

    public init(range: ClosedRange<Int>) {
        self.range = range
    }

    public func validate(_ input: String) -> Validated<String, LengthConstrainedValidationError> {
        if range.lowerBound > input.count {
            return .invalid(input, .shorterThanMin(range.lowerBound))
        } else if range.upperBound < input.count {
            return .invalid(input, .longerThanMax(range.upperBound))
        }

        return .valid(input)
    }
}
