//
//  SignUpFeatureContainer+AutoRegister.swift
//
//
//  Created by Hien Tran on 28/02/2024.
//

// swiftlint:disable force_unwrapping

extension SignUpFeatureContainer: AutoRegistering {
    public func autoRegister() {
        accountRegisterUseCase.register { resolve(\.accountRegisterUseCase) }
        registerReducer.register { RegisterReducer(accountRegisterUseCase: self.accountRegisterUseCase.resolve()!) }
    }
}

// swiftlint:enable force_unwrapping
