//
//  LogInFeatureContainer.swift
//
//
//  Created by Hien Tran on 28/02/2024.
//

import Factory
import LogInUseCase

public final class LogInFeatureContainer: SharedContainer {
    public static let shared = LogInFeatureContainer()
    public let manager = ContainerManager()
}

public extension LogInFeatureContainer {
    var logInUseCase: Factory<LogInUseCaseProtocol?> { self { nil } }
    var logInReducer: Factory<LoginReducer?> { self { nil } }
}
