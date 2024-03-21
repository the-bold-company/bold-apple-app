public enum Either<This, That> {
    case this(This)
    case that(That)

    public func performWhen(
        _ doThis: ((This) -> Void)?,
        _ doThat: ((That) -> Void)?
    ) {
        switch self {
        case let .this(t):
            doThis?(t)
        case let .that(t):
            doThat?(t)
        }
    }
}

public struct None {}

public typealias EitherThisOrNothing<This> = Either<This, None>
