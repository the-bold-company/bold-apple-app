import Codextended
import Foundation
import Moya

public enum NetworkError: LocalizedError {
    case serverError(ServerError)
    case moyaError(MoyaError)
    case custom(String)
    case unknown(Error)

    /// Localized message for debuggin purposes. Don't show this to user
    public var errorDescription: String? {
        switch self {
        case let .serverError(serverError):
            return serverError.errorDescription
        case let .moyaError(moyaError):
            return moyaError.errorDescription
        case let .unknown(error):
            return "Unexpected error: \(error.localizedDescription)"
        case let .custom(message):
            return message
        }
    }

    /// A localized message describing the reason for the failure. Use this to customize error message that is shown to user
    public var failureReason: String? {
        switch self {
        case let .serverError(serverError):
            return serverError.failureReason
        case let .custom(message):
            return message
        default:
            return "An error has occured"
        }
    }
}
