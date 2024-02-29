//
//  SignUpFeatureContainer.swift
//
//
//  Created by Hien Tran on 28/02/2024.
//

import AccountRegisterUseCase
import Factory

public final class SignUpFeatureContainer: SharedContainer {
    public static let shared = SignUpFeatureContainer()
    public let manager = ContainerManager()
}

public extension SignUpFeatureContainer {
    var accountRegisterUseCase: Factory<AccountRegisterUseCaseProtocol?> { self { nil } }
    var registerReducer: Factory<RegisterReducer?> { self { nil } }
}
