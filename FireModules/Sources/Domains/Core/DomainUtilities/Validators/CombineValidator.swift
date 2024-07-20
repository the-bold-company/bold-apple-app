import Foundation

public struct CombineValidator<Input, Error>: Validator {
    let validators: any Validator<Input, Error>

    public init(
        @ValidatorBuilder<Input, Error> _ build: () -> some Validator<Input, Error>
    ) {
        self.init(internal: build())
    }

    init(internal validators: some Validator<Input, Error>) {
        self.validators = validators
    }

    public func validate(
        _ input: Input
    ) -> Validated<Input, Error> {
        validators.validate(input)
    }
}
