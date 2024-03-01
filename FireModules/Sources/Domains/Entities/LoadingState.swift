public enum LoadingState<Success>: Equatable where Success: Equatable {
    case idle
    case loading
    case loaded(Success)
    case failure(DomainError)

    public static func == (lhs: LoadingState<Success>, rhs: LoadingState<Success>) -> Bool {
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

    public var hasResult: Bool {
        return result != nil
    }
}
