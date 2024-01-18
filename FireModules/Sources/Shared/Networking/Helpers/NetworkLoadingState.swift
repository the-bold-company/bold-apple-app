//
//  NetworkLoadingState.swift
//
//
//  Created by Hien Tran on 18/01/2024.
//

public enum NetworkLoadingState<Success>: Equatable where Success: Equatable {
    case idle
    case loading
    case loaded(Success)
    case failure(NetworkError)

    public static func == (lhs: NetworkLoadingState<Success>, rhs: NetworkLoadingState<Success>) -> Bool {
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
