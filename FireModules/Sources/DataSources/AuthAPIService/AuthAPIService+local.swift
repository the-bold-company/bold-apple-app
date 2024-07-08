import AuthAPIServiceInterface
import Combine
import ComposableArchitecture
import DomainEntities
import DomainUtilities
import Foundation

public extension AuthAPIService {
    static func local(
        logInResponseMockURL: URL,
        signUpResponseMockURL: URL,
        confirmSignUpOTPMockURL: URL,
        verifyEmailExistenceMockURL: URL,
        forgotPasswordMockURL: URL,
        confirmForgotPasswordOTPMockURL: URL
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
                let mock = try! Data(contentsOf: confirmSignUpOTPMockURL)
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            verifyEmailExistence: { _ in
                let mock = try! Data(contentsOf: verifyEmailExistenceMockURL)
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(String.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            forgotPassword: { _ in
                let mock = try! Data(contentsOf: forgotPasswordMockURL)
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            confirmOTPForgotPassword: { _, _, _ in
                let mock = try! Data(contentsOf: confirmForgotPasswordOTPMockURL)
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            }
        )
    }

    private static func logInMock(_ mock: Data) -> AnyPublisher<(AuthenticatedUserEntity, CredentialsEntity), DomainError> {
        return Just(mock)
            .mapToResponse(LoginResponse.self, apiVersion: .v1)
            .mapErrorToDomainError()
            .map { (user: $0.profile.asAuthenticatedUserEntity(), credentials: $0.asCredentialsEntity()) }
            .eraseToAnyPublisher()
    }
}

public extension AuthAPIService {
    static func directMock(
        logInResponseMock: String? = nil,
        signUpResponseMock: String? = nil,
        confirmSignUpOTPMock: String? = nil,
        verifyEmailExistenceMock: String? = nil,
        forgotPasswordMock: String? = nil,
        confirmForgotPasswordOTPMock: String? = nil
    ) -> Self {
        .init(
            logIn: { _, _ in
                guard let logInResponseMock else { fatalError() }
                let mock = logInResponseMock.data(using: .utf8)!
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(LoginResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .map { ($0.profile.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
            },
            logInAsync: { _, _ in
                guard let logInResponseMock else { fatalError() }
                let mock = logInResponseMock.data(using: .utf8)!
                return try await Just(mock)
                    .mapToResponse(LoginResponse.self, apiVersion: .v1)
                    .mapErrorToDomainError()
                    .map { ($0.profile.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
                    .eraseToAnyPublisher()
                    .async()
            },
            signUp: { _, _ in
                guard let signUpResponseMock else { fatalError() }
                let mock = signUpResponseMock.data(using: .utf8)!
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(EmptyDataResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            confirmOTP: { _, _ in
                guard let confirmSignUpOTPMock else { fatalError() }
                let mock = confirmSignUpOTPMock.data(using: .utf8)!
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            verifyEmailExistence: { _ in
                guard let verifyEmailExistenceMock else { fatalError() }
                let mock = verifyEmailExistenceMock.data(using: .utf8)!
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(String.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            forgotPassword: { _ in
                guard let forgotPasswordMock else { fatalError() }
                let mock = forgotPasswordMock.data(using: .utf8)!
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            confirmOTPForgotPassword: { _, _, _ in
                guard let confirmForgotPasswordOTPMock else { fatalError() }
                let mock = confirmForgotPasswordOTPMock.data(using: .utf8)!
                return Effect.publisher {
                    Just(mock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            }
        )
    }
}
