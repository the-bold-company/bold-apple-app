import Foundation

public protocol ServerError: Decodable, LocalizedError {
    var message: String { get }
    var code: Int { get }
}

public extension ServerError {
    /// Localized message for debuggin purposes. Don't show this to user
    var errorDescription: String? {
        return "Error code: \(code): \(message)"
    }

    /// A localized message describing the reason for the failure. Use this to customize error message that is shown to user
    var failureReason: String? {
        return message
    }
}
