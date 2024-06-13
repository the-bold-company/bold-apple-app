import DomainEntities
import Foundation

public enum AuthenticationLogic {}

// MARK: Log in use case logic

public extension AuthenticationLogic {
    enum LogIn {
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
}

// MARK: Sign up use case logic

public typealias SignUpRequest = AuthenticationLogic.SignUp.Request
public typealias SignUpResponse = AuthenticationLogic.SignUp.Response
public typealias SignUpFailure = AuthenticationLogic.SignUp.Failure
public extension AuthenticationLogic {
    enum SignUp {
        public struct Request {
            let email: String
            let password: String

            public init(email: String, password: String) {
                self.email = email
                self.password = password
            }
        }

        public struct Response: Equatable {
            public init() {}
        }

        public enum Failure: LocalizedError {
            case genericError(DomainError)
        }
    }
}

// MARK: MFA use case logic

public typealias OTPRequest = AuthenticationLogic.OTP.Request
public typealias OTPResponse = AuthenticationLogic.OTP.Response
public typealias OTPFailure = AuthenticationLogic.OTP.Failure
public extension AuthenticationLogic {
    enum OTP {
        public struct Request {
            let email: String
            let code: String

            public init(email: String, code: String) {
                self.email = email
                self.code = code
            }
        }

        public struct Response: Equatable {
            public init() {}
        }

        public enum Failure: LocalizedError {
            case genericError(DomainError)
            case codeMismatch
        }
    }
}
