import DomainEntities
import Networking
import UserAPIServiceInterface

public struct UserAPIService: UserAPIServiceInterface {
    let client = MoyaClient<UserAPI>()

    init() {}

    public func register(email: String, password: String) async throws -> SuccessfulSignUp {
        return try await client
            .requestPublisher(.signUp(email: email, password: password))
            .mapToResponse(SignUpResponse.self, apiVersion: .v0)
            .map { ($0.user.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
            .mapError { DomainError(error: $0) }
            .eraseToAnyPublisher()
            .async()
    }
}
