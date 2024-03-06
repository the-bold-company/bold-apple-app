//
//  RegisterReducer.swift
//
//
//  Created by Hien Tran on 29/11/2023.
//

import AccountRegisterUseCase
import ComposableArchitecture
import Foundation
import Utilities

@Reducer
public struct RegisterReducer {
    let accountRegisterUseCase: AccountRegisterUseCaseProtocol

    public init(accountRegisterUseCase: AccountRegisterUseCaseProtocol) {
        self.accountRegisterUseCase = accountRegisterUseCase
    }

    public struct State: Equatable {
        @BindingState var email: String = ""
        @BindingState var password: String = ""

        var emailValidationError: String?
        var passwordValidationError: String?
        var accountCreationState: LoadingState<AuthenticatedUserEntity> = .idle

        public init() {}
    }

    public enum Action: BindableAction {
        case createUserButtonTapped
        case binding(BindingAction<State>)

        case createUserSuccesfully(AuthenticatedUserEntity)
        case createUserFailure(DomainError)

        case navigate(Route)
        case goToPasswordCreationButtonTapped

        public enum Route {
            case goToPasswordCreation(RegisterReducer.State)
            case backToEmailRegistration(RegisterReducer.State)
            case exitRegistrationFlow
            case goToHome
        }
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
        EmailRegistrationReducer()
        PasswordCreationReducer(accountRegisterUseCase: accountRegisterUseCase)
    }
}

@Reducer
private struct EmailRegistrationReducer {
    public var body: some ReducerOf<RegisterReducer> {
        Reduce { state, action in
            switch action {
            case .binding(\.$email):
                // TODO: Add email validation rules
                if state.email.count <= 5 {
                    state.emailValidationError = "Email invalid"
                } else {
                    state.emailValidationError = nil
                }
                return .none
            case .goToPasswordCreationButtonTapped:
                return .send(.navigate(.goToPasswordCreation(state)))
            case .binding, .createUserButtonTapped, .createUserSuccesfully,
                 .createUserFailure, .navigate:
                return .none
            }
        }
    }
}

@Reducer
private struct PasswordCreationReducer {
    let accountRegisterUseCase: AccountRegisterUseCaseProtocol

    init(accountRegisterUseCase: AccountRegisterUseCaseProtocol) {
        self.accountRegisterUseCase = accountRegisterUseCase
    }

    public var body: some ReducerOf<RegisterReducer> {
        Reduce { state, action in
            switch action {
            case .binding(\.$password):
                // TODO: Password Validator
                if state.password.count <= 6 {
                    state.passwordValidationError = "Password length must be greater than 6"
                } else {
                    state.passwordValidationError = nil
                }

                return .none
            case .createUserButtonTapped:
                guard state.email.isNotEmpty, // TODO: replace this with validation rules
                      state.password.isNotEmpty // TODO: replace this with validation rules
                else { return .none }

                state.accountCreationState = .loading

                let email = state.email
                let password = state.password

                return .run { send in
                    let result = await accountRegisterUseCase.registerAccount(email: email, password: password)

                    switch result {
                    case let .success(authenticatedUser):
                        await send(.createUserSuccesfully(authenticatedUser))
                    case let .failure(error):
                        await send(.createUserFailure(error))
                    }
                }
            case let .createUserSuccesfully(response):
                state.accountCreationState = .loaded(response)
                return .send(.navigate(.goToHome))
            case let .createUserFailure(error):
                state.accountCreationState = .failure(error)
                return .none
            case .binding, .navigate, .goToPasswordCreationButtonTapped:
                return .none
            }
        }
    }
}
