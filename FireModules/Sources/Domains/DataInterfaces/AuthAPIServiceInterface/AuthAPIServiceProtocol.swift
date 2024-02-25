//
//  AuthAPIServiceProtocol.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

import DomainEntities

public typealias SuccessfulLogIn = (user: AuthenticatedUserEntity, credentials: CredentialsEntity)

public protocol AuthAPIServiceProtocol {
    func login(email: String, password: String) async throws -> SuccessfulLogIn
    func register(email: String, password: String) async throws -> AuthenticatedUserEntity
}
