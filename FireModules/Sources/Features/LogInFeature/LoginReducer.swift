//
//  LoginReducer.swift
//
//
//  Created by Hien Tran on 06/01/2024.
//

import ComposableArchitecture
import DevSettingsUseCases
import Factory
import Foundation
import LogInUseCase
import Utilities

@Reducer
public struct LoginReducer {
    let logInUseCase: LogInUseCaseProtocol

    public init(logInUseCase: LogInUseCaseProtocol) {
        self.logInUseCase = logInUseCase
    }

    public struct State: Equatable {
        public init() {
            // TODO: Add if DEBUG handler for dev setting
            @Dependency(\.devSettings) var devSettings

            self.email = devSettings.credentials.username
            self.password = devSettings.credentials.password
        }

        @BindingState var email: String = ""
        @BindingState var password: String = ""

        var areInputsValid: Bool {
            return email.isNotEmpty && password.isNotEmpty
        }

        var logInInProgress = false
        var loginError: String?
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case binding(BindingAction<State>)
        case navigate(Route)

        case logInSuccesfully(AuthenticatedUserEntity)
        case logInFailure(DomainError)

        public enum Route {
            case goToHome
        }

        public enum Delegate {
            case logInButtonTapped
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .delegate(.logInButtonTapped):
                guard state.areInputsValid else { return .none }

                state.logInInProgress = true

                return .run { [email = state.email, password = state.password] send in

                    let result = await logInUseCase.login(email: email, password: password)

                    switch result {
                    case let .success(authenticatedUser):
                        await send(.logInSuccesfully(authenticatedUser))
                    case let .failure(error):
                        await send(.logInFailure(error))
                    }
                }
            case .logInSuccesfully:
                state.logInInProgress = false
                return .send(.navigate(.goToHome))
            case let .logInFailure(error):
                state.loginError = error.failureReason
                state.logInInProgress = false
                return .none
            case .navigate, .binding:
                return .none
            }
        }
    }
}
