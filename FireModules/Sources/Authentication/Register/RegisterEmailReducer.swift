//
//  RegisterEmailReducer.swift
//
//
//  Created by Hien Tran on 29/11/2023.
//

import ComposableArchitecture
import Foundation
import Shared

@Reducer
public struct EmailRegister {
    public init() {}
    public struct State: Equatable {
        @BindingState var email: String = ""

        var emailValidationError: String? {
            if email.isEmpty {
                return "Email invalid" // don't show error when the field is empty
            } else if email.count <= 5 {
                // TODO: add email avalidation here
                return "Email invalid"
            } else {
                return nil
            }
        }

        public init(email: String = "") {
            self.email = email
        }
    }

    public enum Action: BindableAction {
        case proceedButtonTapped
        case binding(BindingAction<State>)
//        case bind(View)
//
//        public enum View: BindableAction {
//            case binding(BindingAction<State>)
//        }
    }

    public var body: some Reducer<State, Action> {
//        BindingReducer(action: \.bind)
        BindingReducer()
        Reduce<State, Action> { _, action in
            switch action {
            case .binding(\.$email):
                return .none
            case .binding:
                return .none
            case .proceedButtonTapped:
                return .none
//            case .bind(.binding(\.$email)):
//                return .none
//            case .bind:
//                return .none
            }
        }
    }
}

@Reducer
public struct RegisterFeature {
    public init() {}

    public struct State: Codable, Equatable, Hashable {
        var email: String = ""
        var password = ""
        var passwordRetyped = ""
        var isFormValid = false
        public init() {}

        public var emailRegisterFeature: EmailRegister.State {
            get { EmailRegister.State(email: email) }
            set { email = newValue.email }
        }

        public var passwordRegisterFeature: PasswordCreationFeature.State {
            get {
                PasswordCreationFeature.State(
                    password: password,
                    passwordRetyped: passwordRetyped
                )
            }
            set {
                password = newValue.password
                passwordRetyped = newValue.passwordRetyped
            }
        }
    }

    public enum Action {
        case email(EmailRegister.Action)
        case password(PasswordCreationFeature.Action)
    }

    public var body: some Reducer<State, Action> {
//        BindingReducer(action: \.email)
        Scope(state: \.emailRegisterFeature, action: \.email) {
            EmailRegister()
        }

        Scope(state: \.passwordRegisterFeature, action: \.password) {
            PasswordCreationFeature()
        }

        Reduce<State, Action> { _, action in
            switch action {
            case .email, .password:
                return .none
            }
        }

//        Scope(state: \.counter, action: \.counter) {
//              Counter()
//            }
//
//            Scope(state: \.profile, action: \.profile) {
//              Profile()
//            }
//        BindingReducer()
//        Reduce<State, Action> { state, action in
//            switch action {
//            case .binding(\.$email):
//                if state.email.isEmpty {
//                    state.emailValidationError = "Email invalid" // don't show error when the field is empty
//                } else if state.email.count <= 5 {
//                    // TODO: add email avalidation here
//                    state.emailValidationError = "Email invalid"
//                } else {
//                    state.emailValidationError = nil
//                }
//                return .none
//            case .binding:
//                return .none
//            case .proceedButtonTapped:
//                return .none
//            }
//        }
    }
}
