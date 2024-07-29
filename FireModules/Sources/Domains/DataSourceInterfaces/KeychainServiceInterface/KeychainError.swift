import DomainEntities
import Foundation

public enum KeychainError: LocalizedError {
    case keychainError(status: OSStatus, errorUserInfo: [String: Any])
    case unknown(Error)

    public var errorDescription: String? {
        switch self {
        case let .keychainError(status, userInfo):
            return """
            Code: \(status)
            Message: \(SecCopyErrorMessageString(status, nil) ?? "N/A" as CFString)
            User info: \(userInfo)
            """
        case let .unknown(error):
            return error.localizedDescription
        }
    }

    public var failureReason: String? {
        switch self {
        case let .keychainError(_, userInfo):
            return userInfo[NSLocalizedDescriptionKey] as? String ?? "An unknown error has occurred."
        case .unknown:
            return "An unknown error has occurred."
        }
    }

    public var asDomainError: DomainError {
        return DomainError(error: self)
    }
}
