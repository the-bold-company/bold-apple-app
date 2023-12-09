//
//  AppReducer.swift
//
//
//  Created by Hien Tran on 05/12/2023.
//

import Authentication
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct AppReducer {
    public init() {}
    public struct State: Equatable {
        public var isAuthenticated = true

        public init() {}
    }

    public enum Action {
        case onLaunch
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onLaunch:
                // TODO: Check if user's authenticated
                state.isAuthenticated = false
                return .none
            }
        }
    }
}
