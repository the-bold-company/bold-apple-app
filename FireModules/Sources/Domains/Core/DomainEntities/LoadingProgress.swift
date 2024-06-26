import CasePaths
import Foundation

@CasePathable
@dynamicMemberLookup
public enum LoadingProgress<Success, Failure>: Equatable where Success: Equatable, Failure: LocalizedError {
    case idle
    case loading
    case loaded(Result<Success, Failure>)

    public static func == (lhs: LoadingProgress<Success, Failure>, rhs: LoadingProgress<Success, Failure>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case let (.loaded(lhsResult), .loaded(rhsResult)):
            if let lhsSuccess = lhsResult[case: \.success],
               let rhsSuccess = rhsResult[case: \.success]
            {
                return lhsSuccess == rhsSuccess
            } else if let lhsFailure = lhsResult[case: \.failure],
                      let rhsFailure = rhsResult[case: \.failure]
            {
                return lhsFailure.localizedDescription == rhsFailure.localizedDescription
            }

            return false
        default:
            return false
        }
    }

    /// Return a boolean indicating if the current state is .loading
    ///
    /// This is going to be deprecated, use this instead
    /// ```swift
    ///
    /// let state1: LoadingState<Int, DomainError> = .idle
    /// state1.is(\.loading) // false
    ///
    /// let state2: LoadingState<Int, DomainError> = .loaded(.success(42))
    /// state2.is(\.loading) // true
    /// ```
    @available(
        *, deprecated,
        message: "Use `is(_:)` from CasePaths instead"
    )
    public var isLoading: Bool {
        return self == .loading
    }

    /// Return a `Success` value if available
    ///
    /// This is going to be deprecated, use this instead
    /// ```swift
    ///
    /// let state1: LoadingState<Int, DomainError> = .loaded(.failure(someError))
    /// state1[case: \.loaded.success] // nil
    ///
    /// let state2: LoadingState<Int, DomainError> = .loaded(.success(42))
    /// state2[case: \.loaded.success] // 42
    /// ```
    @available(
        *, deprecated,
        message: "Use subscript from CasePaths instead"
    )
    public var result: Success? {
        return self[case: \.loaded.success]
    }

    /// Return a `Failure` value if available
    ///
    /// This is going to be deprecated use this instead
    /// ```swift
    ///
    /// let state1: LoadingState<Int, DomainError> = .loaded(.failure(someError))
    /// state1[case: \.loaded.failure] // someError
    ///
    /// let state2: LoadingState<Int, DomainError> = .loaded(.success(42))
    /// state2[case: \.loaded.failure] // nil
    /// ```
    @available(
        *, deprecated,
        message: "Use subscript from CasePaths instead"
    )
    public var error: Failure? {
        return self[case: \.loaded.failure]
    }

    /// Localized message for debuggin purposes. Don't show this to user
    public var errorDescription: String? {
        return self[case: \.loaded.failure]?.errorDescription
    }

    /// A localized message describing the reason for the failure. Use this to customize error message that is shown to user
    public var failureReason: String? {
        return self[case: \.loaded.failure]?.failureReason
    }

    @available(
        *, deprecated,
        message: "Use `is(_:)` from CasePaths instead"
    )
    public var hasResult: Bool {
        return result != nil
    }
}
