import Combine
import ComposableArchitecture
import Dependencies
import DomainEntities
import DomainUtilities
import Foundation

public typealias SuccessfulLogIn = (AuthenticatedUserEntity, CredentialsEntity)
public typealias LogInAPIResult = Result<SuccessfulLogIn, DomainError>
public typealias SignUpAPIResult = Result<EmptyDataResponse, DomainError>

public struct AuthAPIService {
    public typealias LogInFunctionAsync = (_ email: String, _ password: String) async throws -> SuccessfulLogIn
    public typealias SignUpFunction = (_ email: String, _ password: String) -> Effect<SignUpAPIResult>
    public typealias LogInFunction = (_ email: String, _ password: String) -> Effect<LogInAPIResult>

    private let _logIn: LogInFunction
    private let _signUp: SignUpFunction
    private let _logInAsync: LogInFunctionAsync

    public init(logIn: @escaping LogInFunction, logInAsync: @escaping LogInFunctionAsync, signUp: @escaping SignUpFunction) {
        self._logIn = logIn
        self._logInAsync = logInAsync
        self._signUp = signUp
    }

    public func logInAsync(email: String, password: String) async throws -> SuccessfulLogIn {
        try await _logInAsync(email, password)
    }

    public func signUp(email: String, password: String) -> Effect<SignUpAPIResult> {
        _signUp(email, password)
    }

    public func logIn(email: String, password: String) -> Effect<LogInAPIResult> {
        _logIn(email, password)
    }
}

public extension AuthAPIService {
    static var test: Self {
        .init(
            logIn: { _, _ in fatalError() },
            logInAsync: { _, _ in fatalError() },
            signUp: { _, _ in fatalError() }
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
