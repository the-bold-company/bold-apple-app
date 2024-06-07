public struct AnyValidator<Input, Error> {
    private let _validate: (Input) -> Validated<Input, Error>

    public init<V>(_ validator: V) where V: Validator, V.Input == Input, V.Error == Error {
        self._validate = validator.validate
    }

    public func validate(_ input: Input) -> Validated<Input, Error> {
        _validate(input)
    }
}
