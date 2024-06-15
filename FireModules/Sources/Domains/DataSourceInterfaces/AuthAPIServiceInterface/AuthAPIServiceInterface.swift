import Combine
import ComposableArchitecture
import Dependencies
import DomainEntities
import DomainUtilities
import Foundation

public typealias LogInAPIResult = Result<(AuthenticatedUserEntity, CredentialsEntity), DomainError>
public typealias SignUpAPIResult = Result<EmptyDataResponse, DomainError>
public typealias ConfirmOTPResult = Result<EmptyDataResponse, DomainError>
public typealias VerifyEmailExistenceResult = Result<String, DomainError>

public struct AuthAPIService {
    public typealias LogInFunctionAsync = @Sendable (_ email: String, _ password: String) async throws -> (AuthenticatedUserEntity, CredentialsEntity)
    public typealias LogInFunction = @Sendable (_ email: String, _ password: String) -> Effect<LogInAPIResult>
    public typealias SignUpFunction = @Sendable (_ email: String, _ password: String) -> Effect<SignUpAPIResult>
    public typealias ConfirmOTPFunction = @Sendable (_ email: String, _ code: String) -> Effect<ConfirmOTPResult>
    public typealias VerifyEmailExistenceFunction = @Sendable (_ email: String) -> Effect<VerifyEmailExistenceResult>

    public var logIn: LogInFunction
    public var signUp: SignUpFunction
    public var logInAsync: LogInFunctionAsync
    public var confirmOTP: ConfirmOTPFunction
    public var verifyEmailExistence: VerifyEmailExistenceFunction

    public init(
        logIn: @escaping LogInFunction,
        logInAsync: @escaping LogInFunctionAsync,
        signUp: @escaping SignUpFunction,
        confirmOTP: @escaping ConfirmOTPFunction,
        verifyEmailExistence: @escaping VerifyEmailExistenceFunction
    ) {
        self.logIn = logIn
        self.logInAsync = logInAsync
        self.signUp = signUp
        self.confirmOTP = confirmOTP
        self.verifyEmailExistence = verifyEmailExistence
    }
}

public extension AuthAPIService {
    static var test: Self {
        .init(
            logIn: unimplemented("\(Self.self).logIn"),
            logInAsync: unimplemented("\(Self.self).logInAsync"),
            signUp: unimplemented("\(Self.self).signUp"),
            confirmOTP: unimplemented("\(Self.self).confirmOTP"),
            verifyEmailExistence: unimplemented("\(Self.self).verifyEmailExistence")
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
