//
//  LogInUseCase.swift
//
//
//  Created by Hien Tran on 23/02/2024.
//

import AuthAPIServiceInterface
import KeychainServiceInterface

public struct LogInUseCase: LogInUseCaseProtocol {
    let authService: AuthAPIService
    let keychainService: KeychainServiceProtocol

    public init(authService: AuthAPIService, keychainService: KeychainServiceProtocol) {
        self.authService = authService
        self.keychainService = keychainService
    }

    public func login(email: String, password: String) async -> Result<AuthenticatedUserEntity, DomainError> {
        do {
            let successfulLogIn = try await authService.login(email: email, password: password)

            try keychainService.setCredentials(
                accessToken: successfulLogIn.1.accessToken,
                refreshToken: successfulLogIn.1.refreshToken
            )
            return .success(successfulLogIn.0)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
