//
//  RegisterReducer.swift
//
//
//  Created by Hien Tran on 29/11/2023.
//

import ComposableArchitecture
import Foundation
import Networking
import Utilities

@Reducer
public struct RegisterReducer {
    public init() {}

    public struct State: Equatable {
        @BindingState var email: String = ""
        @BindingState var password: String = ""

        var emailValidationError: String?
        var passwordValidationError: String?
        var accountCreationError: String?
        var accountCreationInProgress = false
        var accountCreationResult: LoginResponse?

        public init() {}
    }

    public enum Action: BindableAction {
        case createUserButtonTapped
        case binding(BindingAction<State>)

        case createUserSuccesfully(LoginResponse)
        case createUserFailure(NetworkError)
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
        EmailRegistrationReducer()
        PasswordCreationReducer()
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
            case .binding,
                 .createUserButtonTapped,
                 .createUserSuccesfully,
                 .createUserFailure:
                return .none
            }
        }
    }
}

@Reducer
private struct PasswordCreationReducer {
    let authService = UserAPIService()
    public var body: some ReducerOf<RegisterReducer> {
        Reduce { state, action in
            switch action {
            case .binding(\.$password):
                // TODO: Password Validator
                if state.password.count <= 6 {
                    state.passwordValidationError = "Password length must be greater than 8"
                } else {
                    state.passwordValidationError = nil
                }

                return .none
            case .createUserButtonTapped:
                guard state.email.isNotEmpty, // TODO: replace this with validation rules
                      state.password.isNotEmpty // TODO: replace this with validation rules
                else { return .none }

                state.accountCreationInProgress = true

                let email = state.email
                let password = state.password

                return .run { send in
                    do {
                        let response = try await authService.signUp(email: email, password: password)
                        await send(.createUserSuccesfully(response))
                    } catch let error as NetworkError {
                        await send(.createUserFailure(error))
                    } catch {
                        await send(.createUserFailure(.unknown(error)))
                    }
                }
            case let .createUserSuccesfully(response):
                state.accountCreationInProgress = false
                state.accountCreationResult = response
                return .none
            case let .createUserFailure(error):
                state.accountCreationInProgress = false
                state.accountCreationError = error.errorDescription
                return .none
            case .binding:
                return .none
            }
        }
    }
}
