import CasePaths
import ComposableArchitecture
import DomainEntities
import Foundation

public enum AuthenticationLogic {}

// TODO: Move it to DomainEntities
public protocol UseCaseRequirements {
    associatedtype Request // TODO: Rename this to Input
    associatedtype Response
    associatedtype Failure: LocalizedError, Equatable
}

// MARK: - Log in use case logic

public typealias LogInRequest = AuthenticationLogic.LogIn.Request
public typealias LogInResponse = AuthenticationLogic.LogIn.Response
public typealias LogInFailure = AuthenticationLogic.LogIn.Failure
public extension AuthenticationLogic {
    enum LogIn: UseCaseRequirements {
        public struct Request {
            public let email: Email
            public let password: NonEmptyString

            public init(email emailString: String, password passwordString: String) {
                self.email = Email(emailString)
                self.password = NonEmptyString(passwordString)
            }

            public init(email: Email, password: NonEmptyString) {
                self.email = email
                self.password = password
            }
        }

        public struct Response {
            public let user: AuthenticatedUserEntity
        }

        @CasePathable
        public enum Failure: LocalizedError, Equatable {
            case genericError(DomainError)
            case invalidCredentials(DomainError)
            case invalidInputs(EmailValidationError?, NonEmptyStringValidationError?)

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
                case let .invalidInputs(emailValidationError, passwordValidationError):
                    return """
                    \(String(describing: emailValidationError?.errorDescription))
                    \(String(describing: passwordValidationError?.errorDescription))
                    """
                }
            }

            public var failureReason: String? {
                switch self {
                case let .invalidCredentials(error),
                     let .genericError(error):
                    return error.failureReason
                case .invalidInputs:
                    return "Invalid credentials"
                }
            }
        }
    }
}

// MARK: - Sign up use case logic

public typealias SignUpRequest = AuthenticationLogic.SignUp.Request
public typealias SignUpResponse = AuthenticationLogic.SignUp.Response
public typealias SignUpFailure = AuthenticationLogic.SignUp.Failure
public extension AuthenticationLogic {
    enum SignUp: UseCaseRequirements {
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

        public enum Failure: LocalizedError, Equatable {
            case genericError(DomainError)
        }
    }
}

// MARK: - MFA use case logic

public typealias MFAInput = AuthenticationLogic.MFA.Request
public typealias MFAResponse = AuthenticationLogic.MFA.Response
public typealias MFAFailure = AuthenticationLogic.MFA.Failure
public typealias MFAOutput = Effect<Result<MFAResponse, MFAFailure>>
public extension AuthenticationLogic {
    enum MFA: UseCaseRequirements {
        @CasePathable
        public enum Request: Equatable {
            case signUpOTP(email: Email, code: OTP)
            case resetPasswordOTP(email: Email, password: Password, code: OTP)
        }

        public struct Response: Equatable {
            public init() {}
        }

        @CasePathable
        public enum Failure: LocalizedError, Equatable {
            case genericError(DomainError)
            case codeMismatch(DomainError)
            case inputInvalid(MFAInput)

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
                case let .inputInvalid(input):
                    return "Input invalid: \(input)"
                }
            }

            public var failureReason: String? {
                switch self {
                case let .codeMismatch(error),
                     let .genericError(error):
                    return error.failureReason
                case .inputInvalid:
                    return "Invalid inputs"
                }
            }
        }
    }
}

// MARK: - Verify email existence logic

public typealias VerifyEmailInput = AuthenticationLogic.VerifyEmailRegistration.Request
public typealias VerifyEmailResponse = AuthenticationLogic.VerifyEmailRegistration.Response
public typealias VerifyEmailFailure = AuthenticationLogic.VerifyEmailRegistration.Failure
public typealias VerifyEmailOutput = Result<VerifyEmailResponse, VerifyEmailFailure>
public extension AuthenticationLogic {
    enum VerifyEmailRegistration: UseCaseRequirements {
        public struct Request {
            let email: String

            public init(email: String) {
                self.email = email
            }
        }

        public struct Response: Equatable {}

        @CasePathable
        public enum Failure: LocalizedError, Equatable {
            case genericError(DomainError)
            case emailAlreadyRegistered
        }
    }
}

// MARK: - Reset password logic

public typealias ForgotPasswordRequest = AuthenticationLogic.ForgotPassword.Request
public typealias ForgotPasswordResponse = AuthenticationLogic.ForgotPassword.Response
public typealias ForgotPasswordFailure = AuthenticationLogic.ForgotPassword.Failure
public extension AuthenticationLogic {
    enum ForgotPassword: UseCaseRequirements {
        public struct Request {
            let email: Email

            public init(email: Email) {
                self.email = email
            }

            public init(emailText: String) {
                self.email = Email(emailText)
            }
        }

        public struct Response: Equatable {
            public let message: String

            public init(message: String) {
                self.message = message
            }
        }

        @CasePathable
        public enum Failure: LocalizedError, Equatable {
            case genericError(DomainError)
            case emailHasNotBeenRegistered
            case emailInvalid(EmailValidationError)

            public init(domainError: DomainError) {
                switch domainError.errorCode {
                case .some(13002):
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
                case let .emailInvalid(error):
                    return error.errorDescription
                }
            }

            public var failureReason: String? {
                switch self {
                case .emailHasNotBeenRegistered:
                    return "Email has not been registered"
                case let .genericError(error):
                    return error.failureReason
                case .emailInvalid:
                    return "Invalid email"
                }
            }
        }
    }
}
