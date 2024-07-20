import Foundation

public protocol Value<Object, Err>: CustomStringConvertible {
    associatedtype Object
    associatedtype Err: Swift.Error

    var value: Result<Object, Err> { get }

    var isValid: Bool { get }

    func getOrCrash() -> Object
    func getOrThrow() throws -> Object
    func getOrNil() -> Object?

    func getErrorOrNil() -> Err?
    func getErrorOrCrash() -> Err

    func getSelfOrNil() -> Self?

    var errorOnly: EitherThisOrNothing<Err> { get }
}

public extension Value where Object: Equatable, Err: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs.value, rhs.value) {
        case let (.success(lhsValue), .success(rhsValue)):
            return lhsValue == rhsValue
        case let (.failure(lhsErr), .failure(rhsErr)):
            return lhsErr == rhsErr
        default:
            return false
        }
    }
}

public extension Value {
    var isValid: Bool {
        value.is(\.success)
    }

    func getOrCrash() -> Object {
        return try! value.get()
    }

    func getOrThrow() throws -> Object {
        return try value.get()
    }

    func getOrNil() -> Object? {
        value[case: \.success]
    }

    func getErrorOrNil() -> Err? {
        value[case: \.failure]
    }

    func getErrorOrCrash() -> Err {
        value[case: \.failure]!
    }

    func getSelfOrNil() -> Self? {
        isValid ? self : nil
    }

    var errorOnly: EitherThisOrNothing<Err> {
        switch value {
        case let .failure(error):
            return .this(error)
        case .success:
            return .that(None())
        }
    }
}

public enum NeverFail: Error, Equatable {}
