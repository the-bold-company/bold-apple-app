import Foundation

public protocol Value<Object, Err>: CustomStringConvertible {
    associatedtype Object
    associatedtype Err: LocalizedError

    var value: Result<Object, Err> { get }

    var isValid: Bool { get }

    func getOrCrash() -> Object
    func getOrNil() -> Object?

    var errorOnly: EitherThisOrNothing<Err> { get }
}

public extension Value where Object: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        do {
            let leftValue = try lhs.value.get()
            let rightValue = try rhs.value.get()
            return leftValue == rightValue
        } catch {
            return false
        }
    }
}

public extension Value {
    var isValid: Bool {
        do {
            _ = try value.get()
            return true
        } catch {
            return false
        }
    }

    func getOrCrash() -> Object {
        return try! value.get()
    }

    func getOrNil() -> Object? {
        do {
            let validValue = try value.get()
            return validValue
        } catch {
            return nil
        }
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

public enum NeverFail: LocalizedError {}
