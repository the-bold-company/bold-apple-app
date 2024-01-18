//
//  AuthRepository.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import Combine
import CombineExt
import CombineMoya

// TODO: Can we create this with Sourcery?
public struct AuthAPIService {
    let client = MoyaClient<AuthAPI>()

    public init() {}

    public func login(email: String, password: String) async throws -> LoginResponse {
        return try await client
            .requestPublisher(.login(email: email, password: password))
            .mapToResponse(LoginResponse.self)
            .async()
    }

    public func register(email: String, password: String) async throws -> LoginResponse {
        return try await client
            .requestPublisher(.register(email: email, password: password))
            .mapToResponse(LoginResponse.self)
            .async()
    }
}
