import Foundation

public struct Validate<Input, Error>: Validator {
    let _validate: (Input) -> Validated<Input, Error>

    public init(validate: @escaping (Input) -> Validated<Input, Error>) {
        self._validate = validate
    }

    public func validate(_ input: Input) -> Validated<Input, Error> {
        _validate(input)
    }
}
