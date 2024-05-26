//
//  DomainError.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

import Foundation

public struct DomainError: LocalizedError {
    public let error: Error
    public let errorCode: Int?

    public init(error: LocalizedError, errorCode: Int? = nil) {
        self.error = error
        self.errorCode = errorCode
    }

    public init(error: Error, errorCode: Int? = nil) {
        self.error = error
        self.errorCode = errorCode
    }

    /// Localized message for debuggin purposes. Don't show this to user
    public var errorDescription: String? {
        if let localizedError = error as? LocalizedError {
            return localizedError.errorDescription
        } else {
            return error.localizedDescription
        }
    }

    /// A localized message describing the reason for the failure. Use this to customize error message that is shown to user
    public var failureReason: String? {
        if let localizedError = error as? LocalizedError {
            return localizedError.failureReason
        } else {
            return "An error has occured"
        }
    }
}

public extension Error {
    func eraseToDomainError() -> DomainError {
        if let error = self as? DomainError {
            return error
        } else {
            return DomainError(error: self)
        }
    }
}

public extension DomainError {
    static func custom(description: String, reason: String? = nil) -> DomainError {
        return DomainError(error: CustomError(description: description, reason: reason))
    }
}

private struct CustomError: LocalizedError {
    let description: String
    let reason: String?

    init(description: String, reason: String? = nil) {
        self.description = description
        self.reason = reason
    }

    public var errorDescription: String? {
        return description
    }

    public var failureReason: String? {
        return reason ?? "An error has occured"
    }
}
