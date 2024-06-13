public struct ValidatorCollection<Input, Error> {
    let validators: [AnyValidator<Input, Error>]

    public init(_ validators: AnyValidator<Input, Error>...) {
        self.validators = validators
    }

    /// Return all the errors associated with `input`
    /// - Parameter input: The input to be validated
    /// - Returns: List of validated result from all `validators`
    public func validateAll(_ input: Input) -> [Validated<Input, Error>] {
        validators.map { $0.validate(input) }
    }

    /// Return the nerest error associated with `input` acoording to the order of `validators`
    /// - Parameter input: The input to be validated
    /// - Returns: The error caught by the nearest validator
    public func validate(_ input: Input) -> Validated<Input, Error> {
        validators.reduce(.idle(input)) { partialResult, val in
            val.validate(partialResult)
        }
    }
}
