//
//  AuthAPIServiceProtocol.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

import DomainEntities

public typealias SuccessfulLogIn = (user: AuthenticatedUserEntity, credentials: CredentialsEntity)

public struct AuthAPIService {
    public typealias LogInFunction = (_ email: String, _ password: String) async throws -> SuccessfulLogIn
    public typealias SignUpFunction = (_ email: String, _ password: String) async throws -> SuccessfulLogIn

    private let _logIn: LogInFunction
    private let _signUp: SignUpFunction

    public init(logIn: @escaping LogInFunction, signUp: @escaping SignUpFunction) {
        self._logIn = logIn
        self._signUp = signUp
    }

    public func login(email: String, password: String) async throws -> SuccessfulLogIn {
        try await _logIn(email, password)
    }

    public func register(email: String, password: String) async throws -> SuccessfulLogIn {
        try await _signUp(email, password)
    }
}

public extension AuthAPIService {
    static var noop: Self {
        .init(logIn: { _, _ in fatalError() }, signUp: { _, _ in fatalError() })
    }
}
