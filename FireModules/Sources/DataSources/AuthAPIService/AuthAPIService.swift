//
//  AuthAPIService.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import AuthAPIServiceInterface
import Combine
import ComposableArchitecture
import DomainEntities
import Foundation
@_exported import Networking

// TODO: Can we create this with Sourcery?
public extension AuthAPIService {
    static var live: Self {
        let networkClient = MoyaClient<AuthAPI>()

        return AuthAPIService(
            logIn: { email, password in
                try await logIn(client: networkClient, email: email, password: password)
                    .async()
            },
            loginPublisher: { email, password in
                Effect.publisher {
                    logIn(client: networkClient, email: email, password: password)
                        .mapToResult()
                }
            },
            signUp: { email, password in
                try await networkClient
                    .requestPublisher(.register(email: email, password: password))
                    .mapToResponse(LoginResponse.self, apiVersion: .v1)
                    .mapErrorToDomainError()
                    .map { ($0.user.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
                    .eraseToAnyPublisher()
                    .async()
            }
        )
    }

    private static func logIn(
        client: MoyaClient<AuthAPI>,
        email: String,
        password: String
    ) -> AnyPublisher<(AuthenticatedUserEntity, CredentialsEntity), DomainError> {
        client
            .requestPublisher(.login(email: email, password: password))
            .mapToResponse(LoginResponse.self, apiVersion: .v1)
            .mapErrorToDomainError()
            .map { ($0.user.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
            .eraseToAnyPublisher()
    }
}

public extension AuthAPIService {
    static var local: Self {
        let mock = try! Data(contentsOf: URL.local.appendingPathComponent("mock/login_successful_response.json"))

        return AuthAPIService(
            logIn: { _, _ in
                try await logInMock(mock)
                    .async()
            },
            loginPublisher: { _, _ in
                Effect.publisher {
                    logInMock(mock).mapToResult()
                }
            },
            signUp: { _, _ in
                fatalError()
            }
        )
    }

    private static func logInMock(_ mock: Data) -> AnyPublisher<(AuthenticatedUserEntity, CredentialsEntity), DomainError> {
        Just(mock)
            .mapToResponse(LoginResponse.self, apiVersion: .v1)
            .mapErrorToDomainError()
            .map { (user: $0.user.asAuthenticatedUserEntity(), credentials: $0.asCredentialsEntity()) }
            .eraseToAnyPublisher()
    }
}

private extension URL {
    static var local: URL {
        var path = #file.components(separatedBy: "/")
        path.removeLast(6)
        let json = path.joined(separator: "/")
        return URL(fileURLWithPath: json)
    }
}
