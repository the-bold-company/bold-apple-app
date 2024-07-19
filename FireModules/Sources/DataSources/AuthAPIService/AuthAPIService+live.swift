import AuthAPIServiceInterface
import Combine
import ComposableArchitecture
import DomainEntities
import DomainUtilities
import Foundation
@_exported import Networking

// TODO: Can we create this with Sourcery?
public extension AuthAPIService {
    static var live: Self {
        let networkClient = MoyaClient<AuthAPI.v1>()

        return AuthAPIService(
            logIn: { email, password in
                Effect.publisher {
                    logIn(client: networkClient, email: email, password: password)
                        .mapToResult()
                }
            },
            logInAsync: { email, password in
                try await logIn(client: networkClient, email: email, password: password)
                    .async()
            },
            signUp: { email, password in
                Effect.publisher {
                    networkClient
                        .requestPublisher(.signUp(email: email, password: password))
                        .mapToResponse(EmptyDataResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            confirmOTP: { email, otp in
                Effect.publisher {
                    networkClient
                        .requestPublisher(.otp(email: email, code: otp))
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            verifyEmailExistence: { email in
                Effect.publisher {
                    networkClient
                        .requestPublisher(.verifyEmailExistence(email: email))
                        .mapToResponse(VerifyEmailResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            forgotPassword: { email in
                Effect.publisher {
                    networkClient
                        .requestPublisher(.forgotPassword(email: email))
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            confirmOTPForgotPassword: { email, password, otp in
                Effect.publisher {
                    networkClient
                        .requestPublisher(.confirmResetPassword(email: email, password: password, code: otp))
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            }
        )
    }

    private static func logIn(
        client: MoyaClient<AuthAPI.v1>,
        email: String,
        password: String
    ) -> AnyPublisher<(AuthenticatedUserEntity, CredentialsEntity), DomainError> {
        client
            .requestPublisher(.logIn(email: email, password: password))
            .mapToResponse(LoginResponse.self, apiVersion: .v1)
            .mapErrorToDomainError()
            .map { ($0.profile.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
            .eraseToAnyPublisher()
    }
}
