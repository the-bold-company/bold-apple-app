import Foundation

public struct Scope<Input, Error>: Validator {
    let _validate: (Input) -> Validated<Input, Error>

    public init<V: Validator>(
        validating path: KeyPath<Input, V.Input>,
        error toRootError: @escaping (V.Error) -> Error,
        @ValidatorBuilder<V.Input, V.Error> _ build: @escaping () -> V
    ) {
        self._validate = { input in
            let childInput = input[keyPath: path]
            let validator = build()
            let validated = validator.validate(childInput)
            switch validated {
            case .valid:
                return .valid(input)
            case let .invalid(_, error):
                return .invalid(input, toRootError(error))
            case .idle:
                return .idle(input)
            }
        }
    }

    public func validate(_ input: Input) -> Validated<Input, Error> {
        _validate(input)
    }
}
