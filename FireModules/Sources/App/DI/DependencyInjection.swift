//
//  DependencyInjection.swift
//
//
//  Created by Hien Tran on 24/02/2024.
//

import AuthAPIService
import AuthAPIServiceInterface
import KeychainService
import KeychainServiceInterface
import LogInUseCase

@_exported import Factory
@_exported import LogInFeature

public extension Container {
    var keychainService: Factory<KeychainServiceProtocol> {
        self { KeychainService() }
    }

    var authAPIService: Factory<AuthAPIServiceProtocol> {
        self { AuthAPIService() }
    }

    var logInUseCase: Factory<LogInUseCaseProtocol> {
        self { LogInUseCase(authService: self.authAPIService.callAsFunction(), keychainService: self.keychainService.callAsFunction()) }
    }

    var logInReducer: Factory<LoginReducer> {
        self { LoginReducer(logInUseCase: self.logInUseCase.callAsFunction()) }
    }
}
