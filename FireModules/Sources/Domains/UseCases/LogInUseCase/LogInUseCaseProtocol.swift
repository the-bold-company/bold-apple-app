//
//  LogInUseCaseProtocol.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

// sourcery: AutoMockable
public protocol LogInUseCaseProtocol {
    func login(email: String, password: String) async -> Result<AuthenticatedUserEntity, DomainError>
}
