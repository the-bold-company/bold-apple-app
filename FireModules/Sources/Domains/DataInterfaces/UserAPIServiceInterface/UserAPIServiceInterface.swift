import DomainEntities

public typealias SuccessfulSignUp = (user: AuthenticatedUserEntity, credentials: CredentialsEntity)

public protocol UserAPIServiceInterface {
    func register(email: String, password: String) async throws -> SuccessfulSignUp
}
