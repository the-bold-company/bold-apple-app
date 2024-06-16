import DomainEntities
import Foundation

public enum AuthenticationLogic {}

// MARK: Log in use case logic

public typealias LogInRequest = AuthenticationLogic.LogIn.Request
public typealias LogInResponse = AuthenticationLogic.LogIn.Response
public typealias LogInFailure = AuthenticationLogic.LogIn.Failure
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
            case invalidCredentials(DomainError)

            public init(domainError: DomainError) {
                switch domainError.errorCode {
                case .some(14001):
                    self = .invalidCredentials(domainError)
                default:
                    self = .genericError(domainError)
                }
            }

            public var errorDescription: String? {
                switch self {
                case let .invalidCredentials(error),
                     let .genericError(error):
                    return error.errorDescription
                }
            }

            public var failureReason: String? {
                switch self {
                case let .invalidCredentials(error),
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
        public enum Request {
            case signUpOTP(email: String, code: String)
            case resetPasswordOTP(email: String, password: String, code: String)
        }

        public struct Response: Equatable {
            public init() {}
        }

        public enum Failure: LocalizedError {
            case genericError(DomainError)
            case codeMismatch(DomainError)

            public init(domainError: DomainError) {
                switch domainError.errorCode {
                case .some(14001):
                    self = .codeMismatch(domainError)
                default:
                    self = .genericError(domainError)
                }
            }

            public var errorDescription: String? {
                switch self {
                case let .codeMismatch(error),
                     let .genericError(error):
                    return error.errorDescription
                }
            }

            public var failureReason: String? {
                switch self {
                case let .codeMismatch(error),
                     let .genericError(error):
                    return error.failureReason
                }
            }
        }
    }
}

// MARK: Verify email existence logic

public typealias VerifyEmailRegistrationRequest = AuthenticationLogic.VerifyEmailRegistration.Request
public typealias VerifyEmailRegistrationResponse = AuthenticationLogic.VerifyEmailRegistration.Response
public typealias VerifyEmailRegistrationFailure = AuthenticationLogic.VerifyEmailRegistration.Failure
public extension AuthenticationLogic {
    enum VerifyEmailRegistration {
        public struct Request {
            let email: String

            public init(email: String) {
                self.email = email
            }
        }

        public struct Response: Equatable {
            public let message: String

            public init(message: String) {
                self.message = message
            }
        }

        public enum Failure: LocalizedError {
            case genericError(DomainError)
            case emailAlreadyRegistered
        }
    }
}

// MARK: Reset password logic

public typealias ForgotPasswordRequest = AuthenticationLogic.ForgotPassword.Request
public typealias ForgotPasswordResponse = AuthenticationLogic.ForgotPassword.Response
public typealias ForgotPasswordFailure = AuthenticationLogic.ForgotPassword.Failure
public extension AuthenticationLogic {
    enum ForgotPassword {
        public struct Request {
            let email: String

            public init(email: String) {
                self.email = email
            }
        }

        public struct Response: Equatable {
            public let message: String

            public init(message: String) {
                self.message = message
            }
        }

        public enum Failure: LocalizedError {
            case genericError(DomainError)
            case emailHasNotBeenRegistered

            public init(domainError: DomainError) {
                switch domainError.errorCode {
                case .some(14001):
                    self = .emailHasNotBeenRegistered
                default:
                    self = .genericError(domainError)
                }
            }

            public var errorDescription: String? {
                switch self {
                case .emailHasNotBeenRegistered:
                    return "Email has not been registered"
                case let .genericError(error):
                    return error.errorDescription
                }
            }

            public var failureReason: String? {
                switch self {
                case .emailHasNotBeenRegistered:
                    return "Email has not been registered"
                case let .genericError(error):
                    return error.failureReason
                }
            }
        }
    }
}
