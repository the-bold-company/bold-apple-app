public struct AnyValidator<Input, Error> {
    private let _validate: (Input) -> Validated<Input, Error>
    private let validator: any Validator<Input, Error>

    public init<V>(_ validator: V) where V: Validator, V.Input == Input, V.Error == Error {
        self._validate = validator.validate
        self.validator = validator
    }

    public func validate(_ input: Input) -> Validated<Input, Error> {
        _validate(input)
    }

    public func validate(_ input: Validated<Input, Error>) -> Validated<Input, Error> {
        validator.validate(input)
    }
}
