//
//  AuthAPIService.swift
//
//
//  Created by Hien Tran on 26/11/2023.
//

import AuthAPIServiceInterface
import Combine
import DomainEntities
import Foundation
@_exported import Networking

// TODO: Can we create this with Sourcery?
public extension AuthAPIService {
    static var live: Self {
        let networkClient = MoyaClient<AuthAPI>()

        return AuthAPIService(
            logIn: { email, password in
                try await networkClient
                    .requestPublisher(.login(email: email, password: password))
                    .mapToResponse(LoginResponse.self)
                    .mapErrorToDomainError()
                    .map { ($0.user.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
                    .eraseToAnyPublisher()
                    .async()
            },
            signUp: { email, password in
                try await networkClient
                    .requestPublisher(.register(email: email, password: password))
                    .mapToResponse(LoginResponse.self)
                    .mapErrorToDomainError()
                    .map { ($0.user.asAuthenticatedUserEntity(), $0.asCredentialsEntity()) }
                    .eraseToAnyPublisher()
                    .async()
            }
        )
    }
}

public extension AuthAPIService {
    static var local: Self {
        let mock = try! Data(contentsOf: URL.local.appendingPathComponent("mock/login_successful_error_invalid_credentials.json"))

        return AuthAPIService(
            logIn: { _, _ in
                try await Just(mock)
                    .mapToResponse(LoginResponse.self)
                    .mapErrorToDomainError()
                    .map { (user: $0.user.asAuthenticatedUserEntity(), credentials: $0.asCredentialsEntity()) }
                    .eraseToAnyPublisher()
                    .async()
            },
            signUp: { _, _ in
                fatalError()
            }
        )
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
