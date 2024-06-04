import ComposableArchitecture

public extension Effect {
    func mapResult<Success, Failure, NewAction>(
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

    func mapResult<S1, F1, S2, F2>(
        success transformSuccess: @escaping (S1) -> S2,
        failure transformFailure: @escaping (F1) -> F2,
        actionOnSuccess: ((S1) throws -> Void)?,
        catch handler: ((DomainError) -> F2)? = nil
    ) -> Effect<Result<S2, F2>>
        where Action == Result<S1, F1>, F1: Error, F2: Error
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
}
