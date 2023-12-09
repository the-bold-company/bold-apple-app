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
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case loginButtonTapped
        case signUpButtonTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .loginButtonTapped:
                return .none
            case .signUpButtonTapped:
                return .none
            }
        }
    }
}
