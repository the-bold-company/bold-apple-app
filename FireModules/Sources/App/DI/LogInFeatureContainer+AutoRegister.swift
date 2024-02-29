//
//  LogInFeatureContainer+AutoRegister.swift
//
//
//  Created by Hien Tran on 28/02/2024.
//

// swiftlint:disable force_unwrapping

extension LogInFeatureContainer: AutoRegistering {
    public func autoRegister() {
        logInUseCase.register { resolve(\.logInUseCase) }
        devSettingsUseCase.register { resolve(\.devSettingsUseCase) }
        logInReducer.register {
            LoginReducer(logInUseCase: self.logInUseCase.resolve()!)
        }
    }
}

// swiftlint:enable force_unwrapping
