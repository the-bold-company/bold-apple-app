import AuthAPIServiceInterface
import KeychainServiceInterface

public struct AccountRegisterUseCase: AccountRegisterUseCaseProtocol {
    let authService: AuthAPIService
    let keychainService: KeychainServiceProtocol

    public init(authService: AuthAPIService, keychainService: KeychainServiceProtocol) {
        self.authService = authService
        self.keychainService = keychainService
    }

    public func registerAccount(email: String, password: String) async -> Result<AuthenticatedUserEntity, DomainError> {
        do {
            let successfulLogIn = try await authService.register(email: email, password: password)

            try keychainService.setCredentials(
                accessToken: successfulLogIn.1.accessToken,
                refreshToken: successfulLogIn.1.refreshToken
            )
            return .success(successfulLogIn.0)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
