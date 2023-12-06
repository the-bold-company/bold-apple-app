//
//  File 2.swift
//
//
//  Created by Hien Tran on 02/12/2023.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct LandingFeature {
    public init() {}
    public struct State: Equatable, Hashable {
        public var register = RegisterFeature.State()
        public init() {}
    }

    public enum Action {
        case loginButtonTapped
        case signUpButtonTapped
        case register(RegisterFeature.Action)
//        case dis(Dis)
//
//        public enum Dis {
//            case register(RegisterFeature.Action)
//        }
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.register, action: \.register) {
            RegisterFeature()
        }

        Reduce { _, action in
            switch action {
            case .loginButtonTapped:
                return .none
            case .signUpButtonTapped:
                return .none
            case .register:
                return .none
            }
        }
    }
}
