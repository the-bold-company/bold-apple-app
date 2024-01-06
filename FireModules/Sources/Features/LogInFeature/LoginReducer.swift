//
//  LoginReducer.swift
//
//
//  Created by Hien Tran on 06/01/2024.
//

import ComposableArchitecture
import Foundation
import KeychainStorageUseCases
import Networking
import Utilities

@Reducer
public struct LoginReducer {
    let authService = AuthAPIService()
    let keychainService = KeychainService()
    public init() {}

    public struct State: Equatable {
        public init() {}
        @BindingState var email: String = ""
        @BindingState var password: String = ""

        var areInputsValid: Bool {
            return email.isNotEmpty && password.isNotEmpty
        }

        var logInInProgress = false
        var loggedInUser: UserDetails?
        var loginError: String?
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case binding(BindingAction<State>)
//        case bind(Binding)
        case navigate(Route)

        case logInSuccesfully(UserDetails)
        case logInFailure(NetworkError)

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
                    do {
                        let response = try await authService.login(email: email, password: password)

                        keychainService.setCredentials(accessToken: response.token, refreshToken: response.refreshToken)

                        await send(.logInSuccesfully(response.user))
                    } catch let error as NetworkError {
                        await send(.logInFailure(error))
                    } catch {
                        await send(.logInFailure(.unknown(error)))
                    }
                }
            case let .logInSuccesfully(user):
                state.loggedInUser = user
                state.logInInProgress = false
                return .send(.navigate(.goToHome))
            case let .logInFailure(error):
                state.loginError = error.errorDescription
                state.logInInProgress = false
                return .none
            case .navigate, .binding:
                return .none
            }
        }
    }
}
