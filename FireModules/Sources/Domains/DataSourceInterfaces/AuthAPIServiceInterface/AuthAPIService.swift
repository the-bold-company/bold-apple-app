//
//  AuthAPIService.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

import Combine
import ComposableArchitecture
import DomainEntities

public typealias SuccessfulLogIn = (AuthenticatedUserEntity, CredentialsEntity)
public typealias LoginAPIResult = Result<SuccessfulLogIn, DomainError>

public struct AuthAPIService {
    public typealias LogInFunction = (_ email: String, _ password: String) async throws -> SuccessfulLogIn
    public typealias SignUpFunction = (_ email: String, _ password: String) async throws -> SuccessfulLogIn
    public typealias LogInPublisher = (_ email: String, _ password: String) -> Effect<LoginAPIResult>

    private let _logIn: LogInFunction
    private let _signUp: SignUpFunction
    private let _loginPublisher: LogInPublisher

    public init(logIn: @escaping LogInFunction, loginPublisher: @escaping LogInPublisher, signUp: @escaping SignUpFunction) {
        self._logIn = logIn
        self._loginPublisher = loginPublisher
        self._signUp = signUp
    }

    public func login(email: String, password: String) async throws -> SuccessfulLogIn {
        try await _logIn(email, password)
    }

    public func register(email: String, password: String) async throws -> SuccessfulLogIn {
        try await _signUp(email, password)
    }

    public func loginPublisher(email: String, password: String) -> Effect<LoginAPIResult> {
        _loginPublisher(email, password)
    }
}

public extension AuthAPIService {
    static var noop: Self {
        .init(
            logIn: { _, _ in fatalError() },
            loginPublisher: { _, _ in fatalError() },
            signUp: { _, _ in fatalError() }
        )
    }
}
