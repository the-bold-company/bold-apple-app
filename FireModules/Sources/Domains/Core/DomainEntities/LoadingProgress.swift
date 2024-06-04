import Foundation

public enum LoadingProgress<Success, Failure>: Equatable where Success: Equatable, Failure: LocalizedError {
    case idle
    case loading
    case loaded(Success)
    case failure(Failure)

    public static func == (lhs: LoadingProgress<Success, Failure>, rhs: LoadingProgress<Success, Failure>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case let (.loaded(lhsResult), .loaded(rhsResult)):
            return lhsResult == rhsResult
        case let (.failure(lhsErr), failure(rhsErr)):
            return lhsErr.localizedDescription == rhsErr.localizedDescription
        default:
            return false
        }
    }

    public var isLoading: Bool {
        return self == .loading
    }

    public var result: Success? {
        if case let .loaded(res) = self {
            return res
        } else {
            return nil
        }
    }

    public var error: Failure? {
        if case let .failure(error) = self {
            return error
        } else {
            return nil
        }
    }

    /// Localized message for debuggin purposes. Don't show this to user
    public var errorDescription: String? {
        return error?.errorDescription
    }

    /// A localized message describing the reason for the failure. Use this to customize error message that is shown to user
    public var failureReason: String? {
        return error?.failureReason
    }

    public var hasResult: Bool {
        return result != nil
    }
}
