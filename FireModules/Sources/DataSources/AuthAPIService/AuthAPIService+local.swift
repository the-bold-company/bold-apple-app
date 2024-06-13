import AuthAPIServiceInterface
import Combine
import ComposableArchitecture
import DomainEntities
import DomainUtilities
import Foundation

public extension AuthAPIService {
    static func local(
        logInResponseMockURL: URL,
        signUpResponseMockURL: URL
    ) -> Self {
        .init(
            logIn: { _, _ in
                let mock = try! Data(contentsOf: logInResponseMockURL)
                return Effect.publisher {
                    logInMock(mock).mapToResult()
                }
            },
            logInAsync: { _, _ in
                let mock = try! Data(contentsOf: logInResponseMockURL)
                return try await logInMock(mock)
                    .async()
            },
            signUp: { _, _ in
                let mock = try! Data(contentsOf: signUpResponseMockURL)
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(EmptyDataResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            confirmOTP: { _, _ in
                fatalError()
            }
        )
    }

    private static func logInMock(_ mock: Data) -> AnyPublisher<(AuthenticatedUserEntity, CredentialsEntity), DomainError> {
        return Just(mock)
            .mapToResponse(LoginResponse.self, apiVersion: .v1)
            .mapErrorToDomainError()
            .map { (user: $0.user.asAuthenticatedUserEntity(), credentials: $0.asCredentialsEntity()) }
            .eraseToAnyPublisher()
    }
}
