import AuthAPIServiceInterface
import KeychainServiceInterface

public struct AccountRegisterUseCase: AccountRegisterUseCaseProtocol {
    let authService: AuthAPIServiceProtocol
    let keychainService: KeychainServiceProtocol

    public init(authService: AuthAPIServiceProtocol, keychainService: KeychainServiceProtocol) {
        self.authService = authService
        self.keychainService = keychainService
    }

    public func registerAccount(email: String, password: String) async -> Result<AuthenticatedUserEntity, DomainError> {
        do {
            let successfulLogIn = try await authService.register(email: email, password: password)

            try keychainService.setCredentials(
                accessToken: successfulLogIn.credentials.accessToken,
                refreshToken: successfulLogIn.credentials.refreshToken
            )
            return .success(successfulLogIn.user)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
