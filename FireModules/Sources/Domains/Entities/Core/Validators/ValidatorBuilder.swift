import Foundation

@resultBuilder
public enum ValidatorBuilder<Input, Error> {
    public static func buildArray<V: Validator>(_ validators: [V]) -> _SequenceMany<V>
        where V.Input == Input, V.Error == Error
    {
        _SequenceMany(validators: validators)
    }

    public static func buildBlock<V: Validator>(
        _ validator: V
    ) -> V
        where V.Input == Input, V.Error == Error
    {
        validator
    }

    public static func buildExpression<V: Validator>(_ validator: V) -> V
        where V.Input == Input, V.Error == Error
    {
        validator
    }

    public static func buildFinalResult<V: Validator>(_ validator: V) -> V
        where V.Input == Input, V.Error == Error
    {
        validator
    }

    public static func buildPartialBlock<V: Validator>(
        first: V
    ) -> V
        where V.Input == Input, V.Error == Error
    {
        first
    }

    public static func buildPartialBlock<V0: Validator, V1: Validator>(
        accumulated: V0, next: V1
    ) -> _Sequence<V0, V1>
        where V0.Input == Input, V1.Input == Input, V0.Error == Error, V1.Error == Error
    {
        _Sequence(v0: accumulated, v1: next)
    }
}

public struct _SequenceMany<Element: Validator>: Validator {
    let validators: [Element]

    init(
        validators: [Element]
    ) {
        self.validators = validators
    }

    public func validate(
        _ input: Element.Input
    ) -> Validated<Element.Input, Element.Error> {
        validators.reduce(.idle(input)) { $1.validate($0) }
    }
}

public struct _Sequence<V0: Validator, V1: Validator>: Validator
    where V0.Input == V1.Input, V0.Error == V1.Error
{
    let v0: V0
    let v1: V1

    init(v0: V0, v1: V1) {
        self.v0 = v0
        self.v1 = v1
    }

    public func validate(_ input: V0.Input) -> Validated<V0.Input, V0.Error> {
        v1.validate(v0.validate(input))
    }
}
