//
//  PasswordCreationFeature.swift
//
//
//  Created by Hien Tran on 03/12/2023.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PasswordCreationFeature {
    public init() {}

    public struct State: Codable, Equatable, Hashable {
        @BindingState var password: String = ""
        @BindingState var passwordRetyped: String = ""

        var passwordValidationError: String? {
            return nil
        }

        public init(
            password: String = "",
            passwordRetyped: String = ""
        ) {
            self.password = password
            self.passwordRetyped = passwordRetyped
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case proceedButtonTapped
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce<State, Action> { _, action in
            switch action {
            case .binding(\.$password):
                return .none
            case .binding(\.$passwordRetyped):
                return .none
            case .binding:
                return .none
            case .proceedButtonTapped:
                return .none
            }
        }
    }
}
