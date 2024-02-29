//
//  AuthAPIService.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import AuthAPIServiceInterface
import DomainEntities
@_exported import Networking

// TODO: Can we create this with Sourcery?
public struct AuthAPIService: AuthAPIServiceProtocol {
    let client = MoyaClient<AuthAPI>()

    public init() {}

    public func login(email: String, password: String) async throws -> SuccessfulLogIn {
        return try await client
            .requestPublisher(.login(email: email, password: password))
            .mapToResponse(LoginResponse.self)
            .mapError { DomainError(error: $0) }
            .map { ($0.user.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
            .eraseToAnyPublisher()
            .async()
    }

    public func register(email: String, password: String) async throws -> SuccessfulLogIn {
        return try await client
            .requestPublisher(.register(email: email, password: password))
            .mapToResponse(LoginResponse.self)
            .mapError { DomainError(error: $0) }
            .map { ($0.user.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
            .eraseToAnyPublisher()
            .async()
    }
}
