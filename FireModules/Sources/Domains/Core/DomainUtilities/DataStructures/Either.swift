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

    public var this: This? {
        guard case let .this(this) = self else {
            return nil
        }

        return this
    }

    public var that: That? {
        guard case let .that(that) = self else {
            return nil
        }

        return that
    }
}

public struct None {}

public typealias EitherThisOrNothing<This> = Either<This, None>
