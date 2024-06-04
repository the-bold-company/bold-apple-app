import AuthAPIServiceInterface
import ComposableArchitecture
import DomainEntities
import KeychainServiceInterface

public struct AuthenticationUseCase: LogInUseCase, SignUpUseCase {
    let authService: AuthAPIService
    let keychainService: KeychainServiceProtocol

    public init(authService: AuthAPIService, keychainService: KeychainServiceProtocol) {
        self.authService = authService
        self.keychainService = keychainService
    }

    public func logInAsync(_ request: AuthenticationLogic.LogIn.Request) async -> LoginDomainOutput {
        do {
            let successfulLogIn = try await authService.login(email: request.email, password: request.password)

            try keychainService.setCredentials(
                accessToken: successfulLogIn.1.accessToken,
                refreshToken: successfulLogIn.1.refreshToken
            )
            return .success(AuthenticationLogic.LogIn.Response(user: successfulLogIn.0))
        } catch let error as DomainError {
            return .failure(AuthenticationLogic.LogIn.Failure(domainError: error))
        } catch {
            return .failure(AuthenticationLogic.LogIn.Failure.genericError(error.eraseToDomainError()))
        }
    }

    public func logIn(_ request: AuthenticationLogic.LogIn.Request) -> Effect<LoginDomainOutput> {
        authService.loginPublisher(email: request.email, password: request.password)
            .mapResult(
                success: { AuthenticationLogic.LogIn.Response(user: $0.0) },
                failure: { AuthenticationLogic.LogIn.Failure(domainError: $0) },
                actionOnSuccess: { response in
                    try keychainService.setCredentials(
                        accessToken: response.1.accessToken,
                        refreshToken: response.1.refreshToken
                    )
                },
                catch: { AuthenticationLogic.LogIn.Failure(domainError: $0) }
            )
    }

    public func signUp(_ request: AuthenticationLogic.SignUp.Request) async -> SignUpDomainOutput {
        do {
            let successfulLogIn = try await authService.register(email: request.email, password: request.password)

            try keychainService.setCredentials(
                accessToken: successfulLogIn.1.accessToken,
                refreshToken: successfulLogIn.1.refreshToken
            )
            return .success(AuthenticationLogic.SignUp.Response(user: successfulLogIn.0))
        } catch let error as DomainError {
            return .failure(AuthenticationLogic.SignUp.Failure.genericError(error))
        } catch {
            return .failure(AuthenticationLogic.SignUp.Failure.genericError(error.eraseToDomainError()))
        }
    }
}
