//
//  DomainError.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

import Foundation

public struct DomainError: LocalizedError {
    let error: LocalizedError

    public init(error: LocalizedError) {
        self.error = error
    }

    /// Localized message for debuggin purposes. Don't show this to user
    public var errorDescription: String? {
        return error.errorDescription
    }

    /// A localized message describing the reason for the failure. Use this to customize error message that is shown to user
    public var failureReason: String? {
        return error.failureReason
    }
}

public extension DomainError {
    static func custom(errorMessage: String) -> DomainError {
        return DomainError(error: CustomError.custom(errorMessage))
    }

    static func custom(error: Error) -> DomainError {
        return DomainError(error: CustomError.unknown(error))
    }
}

private enum CustomError: LocalizedError {
    case custom(String)
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case let .custom(message):
            return message
        case let .unknown(error):
            return error.localizedDescription
        }
    }

    public var failureReason: String? {
        switch self {
        case let .custom(message):
            return message
        case .unknown:
            return "An error has occured"
        }
    }
}
