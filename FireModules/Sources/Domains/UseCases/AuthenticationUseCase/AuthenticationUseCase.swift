import AuthAPIServiceInterface
import DomainEntities
import KeychainServiceInterface

public struct AuthenticationUseCase: LogInUseCase, SignUpUseCase {
    let authService: AuthAPIService
    let keychainService: KeychainServiceProtocol

    public init(authService: AuthAPIService, keychainService: KeychainServiceProtocol) {
        self.authService = authService
        self.keychainService = keychainService
    }

    public func logIn(_ request: AuthenticationLogic.LogIn.Request) async -> Result<AuthenticationLogic.LogIn.Response, AuthenticationLogic.LogIn.Failure> {
        do {
            let successfulLogIn = try await authService.login(email: request.email, password: request.password)

            try keychainService.setCredentials(
                accessToken: successfulLogIn.credentials.accessToken,
                refreshToken: successfulLogIn.credentials.refreshToken
            )
            return .success(AuthenticationLogic.LogIn.Response(user: successfulLogIn.user))
        } catch let error as DomainError {
            return .failure(AuthenticationLogic.LogIn.Failure(domainError: error))
        } catch {
            return .failure(AuthenticationLogic.LogIn.Failure.genericError(error.eraseToDomainError()))
        }
    }

    public func signUp(_ request: AuthenticationLogic.SignUp.Request) async -> Result<AuthenticationLogic.SignUp.Response, AuthenticationLogic.SignUp.Failure> {
        do {
            let successfulLogIn = try await authService.register(email: request.email, password: request.password)

            try keychainService.setCredentials(
                accessToken: successfulLogIn.credentials.accessToken,
                refreshToken: successfulLogIn.credentials.refreshToken
            )
            return .success(AuthenticationLogic.SignUp.Response(user: successfulLogIn.user))
        } catch let error as DomainError {
            return .failure(AuthenticationLogic.SignUp.Failure.genericError(error))
        } catch {
            return .failure(AuthenticationLogic.SignUp.Failure.genericError(error.eraseToDomainError()))
        }
    }
}

protocol Request {
    associatedtype Response
    associatedtype Error: Swift.Error

    typealias Handler = (Result<Response, Error>) -> Void

    func perform(then handler: @escaping Handler)
}
