// sourcery: AutoMockable
public protocol AccountRegisterUseCaseProtocol {
    func registerAccount(email: String, password: String) async -> Result<AuthenticatedUserEntity, DomainError>
}
