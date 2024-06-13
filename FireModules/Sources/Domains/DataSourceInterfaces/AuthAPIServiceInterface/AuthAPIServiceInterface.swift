import Combine
import ComposableArchitecture
import Dependencies
import DomainEntities
import DomainUtilities
import Foundation

public typealias SuccessfulLogIn = (AuthenticatedUserEntity, CredentialsEntity)
public typealias LogInAPIResult = Result<SuccessfulLogIn, DomainError>
public typealias SignUpAPIResult = Result<EmptyDataResponse, DomainError>
public typealias ConfirmOTPResult = Result<EmptyDataResponse, DomainError>

public struct AuthAPIService {
    public typealias LogInFunctionAsync = @Sendable (_ email: String, _ password: String) async throws -> SuccessfulLogIn
    public typealias LogInFunction = @Sendable (_ email: String, _ password: String) -> Effect<LogInAPIResult>
    public typealias SignUpFunction = @Sendable (_ email: String, _ password: String) -> Effect<SignUpAPIResult>
    public typealias ConfirmOTPFunction = @Sendable (_ email: String, _ code: String) -> Effect<ConfirmOTPResult>

    public var logIn: LogInFunction
    public var signUp: SignUpFunction
    public var logInAsync: LogInFunctionAsync
    public var confirmOTP: ConfirmOTPFunction

    public init(
        logIn: @escaping LogInFunction,
        logInAsync: @escaping LogInFunctionAsync,
        signUp: @escaping SignUpFunction,
        confirmOTP: @escaping ConfirmOTPFunction
    ) {
        self.logIn = logIn
        self.logInAsync = logInAsync
        self.signUp = signUp
        self.confirmOTP = confirmOTP
    }
}

public extension AuthAPIService {
    static var test: Self {
        .init(
            logIn: { _, _ in fatalError() },
            logInAsync: { _, _ in fatalError() },
            signUp: { _, _ in fatalError() },
            confirmOTP: { _, _ in fatalError() }
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
