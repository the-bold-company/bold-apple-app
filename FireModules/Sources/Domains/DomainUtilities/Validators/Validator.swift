import Foundation

public protocol Validator<Input, Error> {
    associatedtype Input
    associatedtype Error

    associatedtype _Body

    typealias Body = _Body

    func validate(_ input: Input) -> Validated<Input, Error>

    @ValidatorBuilder<Input, Error>
    var body: Body { get }
}

public extension Validator where Error: LocalizedError {
    func callAsFunction(_ input: Input) -> Validated<Input, Error> {
        validate(input)
    }
}

//    public extension Validator where Error: LocalizedError {
//    func callAsFunction(_ input: Input) -> Result<Input, Error> {
//        let validated = validate(input)
//        switch validated {
//        case .valid(let input):
//            return .success(input)
//        case .idle(let input):
//            return .success(input)
//        case .invalid(let input, let error):
//            return .failure(error)
//        }
//    }
// }

public extension Validator {
    func validate(_ input: Validated<Input, Error>) -> Validated<Input, Error> {
        switch input {
        case let .valid(input):
            return validate(input)
        case let .idle(input):
            return validate(input)
        case let .invalid(input, error):
            return .invalid(input, error)
        }
    }
}

public extension Validator where Body == Never {
    var body: Body {
        fatalError(
            """
              \(Self.self) has no body.

              Do not call a validator body property directly, as it may not exists.
              Call Validator.validate(input:) instead
            """
        )
    }
}

public extension Validator where Body: Validator, Body.Input == Input, Body.Error == Error {
    func validate(
        _ input: Input
    ) -> Validated<Input, Error> {
        body.validate(input)
    }
}
