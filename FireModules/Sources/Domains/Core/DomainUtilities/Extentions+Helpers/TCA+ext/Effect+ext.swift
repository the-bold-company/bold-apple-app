import ComposableArchitecture
import Foundation

public extension Effect {
    func map<Success, Failure, NewAction>(
        success transformSuccess: @escaping (Success) -> NewAction,
        failure transformFailure: @escaping (Failure) -> NewAction
    ) -> Effect<NewAction> where Action == Result<Success, Failure> {
        map { result in
            switch result {
            case let .success(success):
                return transformSuccess(success)
            case let .failure(failure):
                return transformFailure(failure)
            }
        }
    }

    @available(
        *, deprecated,
        message: "Use `mapToUseCaseLogic` instead"
    )
    func mapResult<S1, F1, S2, F2>(
        success transformSuccess: @escaping (S1) -> S2,
        failure transformFailure: @escaping (F1) -> F2,
        actionOnSuccess: ((S1) throws -> Void)? = nil,
        catch handler: ((Swift.Error) -> F2)? = nil
    ) -> Effect<Result<S2, F2>>
        where Action == Result<S1, F1>,
        F1: Swift.Error,
        F2: Swift.Error
    {
        map { result in
            do {
                switch result {
                case let .success(successValue):
                    try actionOnSuccess?(successValue)
                    return .success(transformSuccess(successValue))
                case let .failure(error):
                    return .failure(transformFailure(error))
                }
            } catch let error as DomainError {
                guard let handler else {
                    fatalError("""
                    An unhandled error was thrown.

                    All errors thrown by `actionOnSuccess` must be explicitly handled via the `catch` parameter.
                    """)
                }
                return .failure(handler(error))
            } catch {
                guard let handler else {
                    fatalError("""
                    An unhandled error was thrown.

                    All errors thrown by `actionOnSuccess` must be explicitly handled via the `catch` parameter.
                    """)
                }

                return .failure(handler(error.eraseToDomainError()))
            }
        }
    }

    func mapResult<S1, S2, F2>(
        success onSuccess: @escaping (S1) -> Result<S2, F2>,
        failure onFailure: @escaping (DomainError) -> Result<S2, F2>,
        actionOnSuccess: ((S1) throws -> Void)? = nil,
        catch handler: ((Swift.Error) -> Result<S2, F2>)? = nil
    ) -> Effect<Result<S2, F2>>
        where Action == Result<S1, DomainError>,
        F2: LocalizedError
    {
        map { result in
            do {
                switch result {
                case let .success(successValue):
                    try actionOnSuccess?(successValue)
                    return onSuccess(successValue)
                case let .failure(error):
                    return onFailure(error)
                }
            } catch {
                guard let handler else {
                    fatalError("""
                    An unhandled error was thrown.

                    All errors thrown by `actionOnSuccess` must be explicitly handled via the `catch` parameter.
                    """)
                }

                return handler(error)
            }
        }
    }

    func mapToUseCaseLogic<S1, S2, F2>(
        success transformSuccess: @escaping (S1) -> S2,
        failure transformFailure: @escaping (DomainError) -> F2,
        actionOnSuccess: ((S1) throws -> Void)? = nil,
        catch handler: ((Swift.Error) -> F2)? = nil
    ) -> Effect<Result<S2, F2>>
        where Action == Result<S1, DomainError>,
        F2: LocalizedError
    {
        map { result in
            do {
                switch result {
                case let .success(successValue):
                    try actionOnSuccess?(successValue)
                    return .success(transformSuccess(successValue))
                case let .failure(error):
                    return .failure(transformFailure(error))
                }
            } catch {
                guard let handler else {
                    fatalError("""
                    An unhandled error was thrown.

                    All errors thrown by `actionOnSuccess` must be explicitly handled via the `catch` parameter.
                    """)
                }

                return .failure(handler(error))
            }
        }
    }
}
