import Combine
import ComposableArchitecture
import Dependencies
import DomainEntities
import DomainUtilities
import Foundation

public typealias LogInAPIResult = Result<(AuthenticatedUserEntity, CredentialsEntity), DomainError>
public typealias SignUpAPIResult = Result<EmptyDataResponse, DomainError>
public typealias ConfirmOTPResult = Result<MessageOnlyResponse, DomainError>
public typealias VerifyEmailExistenceResult = Result<VerifyEmailResponse, DomainError>
public typealias ForgotPasswordResult = Result<MessageOnlyResponse, DomainError>

public struct AuthAPIService {
    public var logIn: @Sendable (_ email: String, _ password: String) -> Effect<LogInAPIResult>
    public var logInAsync: @Sendable (_ email: String, _ password: String) async throws -> (AuthenticatedUserEntity, CredentialsEntity)
    public var signUp: @Sendable (_ email: String, _ password: String) -> Effect<SignUpAPIResult>
    public var confirmOTP: @Sendable (_ email: String, _ code: String) -> Effect<ConfirmOTPResult>
    public var verifyEmailExistence: @Sendable (_ email: String) -> Effect<VerifyEmailExistenceResult>
    public var forgotPassword: @Sendable (_ email: String) -> Effect<ForgotPasswordResult>
    public var confirmOTPForgotPassword: @Sendable (_ email: String, _ password: String, _ code: String) -> Effect<ConfirmOTPResult>

    public init(
        logIn: @escaping @Sendable (_ email: String, _ password: String) -> Effect<LogInAPIResult>,
        logInAsync: @escaping @Sendable (_ email: String, _ password: String) async throws -> (AuthenticatedUserEntity, CredentialsEntity),
        signUp: @escaping @Sendable (_ email: String, _ password: String) -> Effect<SignUpAPIResult>,
        confirmOTP: @escaping @Sendable (_ email: String, _ code: String) -> Effect<ConfirmOTPResult>,
        verifyEmailExistence: @escaping @Sendable (_ email: String) -> Effect<VerifyEmailExistenceResult>,
        forgotPassword: @escaping @Sendable (_ email: String) -> Effect<ForgotPasswordResult>,
        confirmOTPForgotPassword: @escaping @Sendable (_ email: String, _ password: String, _ code: String) -> Effect<ConfirmOTPResult>
    ) {
        self.logIn = logIn
        self.logInAsync = logInAsync
        self.signUp = signUp
        self.confirmOTP = confirmOTP
        self.verifyEmailExistence = verifyEmailExistence
        self.forgotPassword = forgotPassword
        self.confirmOTPForgotPassword = confirmOTPForgotPassword
    }
}

public extension AuthAPIService {
    static var test: Self {
        .init(
            logIn: unimplemented("\(Self.self).logIn"),
            logInAsync: unimplemented("\(Self.self).logInAsync"),
            signUp: unimplemented("\(Self.self).signUp"),
            confirmOTP: unimplemented("\(Self.self).confirmOTP"),
            verifyEmailExistence: unimplemented("\(Self.self).verifyEmailExistence"),
            forgotPassword: unimplemented("\(Self.self).forgotPassword"),
            confirmOTPForgotPassword: unimplemented("\(Self.self).confirmOTPForgotPassword")
        )
    }
}

public enum AuthAPIServiceKey: TestDependencyKey {
    public static let testValue = AuthAPIService.test
}

public extension DependencyValues {
    var authAPIService: AuthAPIService {
        get { self[AuthAPIServiceKey.self] }
        set { self[AuthAPIServiceKey.self] = newValue }
    }
}
