public struct ValidatorCollection<Input, Error> {
    let validators: [AnyValidator<Input, Error>]

    public init(_ validators: AnyValidator<Input, Error>...) {
        self.validators = validators
    }

    public func validateAll(_ input: Input) -> [Validated<Input, Error>] {
        validators.map { $0.validate(input) }
    }
}
