import DomainEntities
import Foundation

public enum AuthenticationLogic {
    public enum LogIn {
        public struct Request {
            public let email: String
            public let password: String

            public init(email: String, password: String) {
                self.email = email
                self.password = password
            }
        }

        public struct Response {
            public let user: AuthenticatedUserEntity
        }

        public enum Failure: LocalizedError {
            case genericError(DomainError)
            case invalidCredentials(DomainError, errorCode: Int)

            public init(domainError: DomainError) {
                switch domainError.errorCode {
                case .some(101):
                    self = .invalidCredentials(domainError, errorCode: domainError.errorCode!)
                default:
                    self = .genericError(domainError)
                }
            }

            public var errorDescription: String? {
                switch self {
                case let .invalidCredentials(error, _),
                     let .genericError(error):
                    return error.errorDescription
                }
            }

            public var failureReason: String? {
                switch self {
                case let .invalidCredentials(error, _),
                     let .genericError(error):
                    return error.failureReason
                }
            }
        }
    }

    public enum SignUp {
        public struct Request {
            var email: String
            var password: String
        }

        public struct Response {
            var user: AuthenticatedUserEntity
        }

        public enum Failure: Error {
            case genericError(DomainError)
        }
    }
}
