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
        mockData(
            logInResponseMock: try? Data(contentsOf: logInResponseMockURL),
            signUpResponseMock: try? Data(contentsOf: signUpResponseMockURL),
            confirmSignUpOTPMock: try? Data(contentsOf: confirmSignUpOTPMockURL),
            verifyEmailExistenceMock: try? Data(contentsOf: verifyEmailExistenceMockURL),
            forgotPasswordMock: try? Data(contentsOf: forgotPasswordMockURL),
            confirmForgotPasswordOTPMock: try? Data(contentsOf: confirmForgotPasswordOTPMockURL)
        )
    }

    static func directMock(
        logInResponseMock: String? = nil,
        signUpResponseMock: String? = nil,
        confirmSignUpOTPMock: String? = nil,
        verifyEmailExistenceMock: String? = nil,
        forgotPasswordMock: String? = nil,
        confirmForgotPasswordOTPMock: String? = nil
    ) -> Self {
        mockData(
            logInResponseMock: logInResponseMock?.data(using: .utf8),
            signUpResponseMock: signUpResponseMock?.data(using: .utf8),
            confirmSignUpOTPMock: confirmSignUpOTPMock?.data(using: .utf8),
            verifyEmailExistenceMock: verifyEmailExistenceMock?.data(using: .utf8),
            forgotPasswordMock: forgotPasswordMock?.data(using: .utf8),
            confirmForgotPasswordOTPMock: confirmForgotPasswordOTPMock?.data(using: .utf8)
        )
    }
}

extension AuthAPIService {
    private static func mockData(
        logInResponseMock: Data? = nil,
        signUpResponseMock: Data? = nil,
        confirmSignUpOTPMock: Data? = nil,
        verifyEmailExistenceMock: Data? = nil,
        forgotPasswordMock: Data? = nil,
        confirmForgotPasswordOTPMock: Data? = nil
    ) -> Self {
        .init(
            logIn: { _, _ in
                guard let logInResponseMock else { fatalError() }
                return Effect.publisher {
                    Just(logInResponseMock)
                        .mapToResponse(LoginResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .map { ($0.profile.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
                        .mapToResult()
                        .eraseToAnyPublisher()
                }
            },
            logInAsync: { _, _ in
                guard let logInResponseMock else { fatalError() }
                return try await Just(logInResponseMock)
                    .mapToResponse(LoginResponse.self, apiVersion: .v1)
                    .mapErrorToDomainError()
                    .map { ($0.profile.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
                    .eraseToAnyPublisher()
                    .async()
            },
            signUp: { _, _ in
                guard let signUpResponseMock else { fatalError() }
                return Effect.publisher {
                    Just(signUpResponseMock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            confirmOTP: { _, _ in
                guard let confirmSignUpOTPMock else { fatalError() }
                return Effect.publisher {
                    Just(confirmSignUpOTPMock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            verifyEmailExistence: { _ in
                guard let verifyEmailExistenceMock else { fatalError() }
                return Effect.publisher {
                    Just(verifyEmailExistenceMock)
                        .mapToResponse(VerifyEmailResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            forgotPassword: { _ in
                guard let forgotPasswordMock else { fatalError() }
                return Effect.publisher {
                    Just(forgotPasswordMock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            },
            confirmOTPForgotPassword: { _, _, _ in
                guard let confirmForgotPasswordOTPMock else { fatalError() }
                return Effect.publisher {
                    Just(confirmForgotPasswordOTPMock)
                        .mapToResponse(MessageOnlyResponse.self, apiVersion: .v1)
                        .mapErrorToDomainError()
                        .mapToResult()
                }
            }
        )
    }
}
