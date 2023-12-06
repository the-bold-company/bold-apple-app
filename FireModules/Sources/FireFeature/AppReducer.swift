//
//  AppReducer.swift
//
//
//  Created by Hien Tran on 05/12/2023.
//

import Authentication
import ComposableArchitecture
import Foundation

@Reducer
public struct AppReducer {
    public init() {}
    public struct State: Equatable {
        public var isAuthenticated = false

        public var routes = StackState<Route.State>()

        public init() {}
    }

    public enum Action {
        case routes(StackAction<Route.State, Route.Action>)
        case onLaunch
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .routes(action):
                switch action {
                case let .element(id: id, action: .landingRoute(.signUpButtonTapped)):

                    let ok = state.routes[id: id]! // as? LandingFeature.State

                    if case let AppReducer.Route.State.landingRoute(aState) = ok {
                        print(aState)
//                        state.routes.append(.registerEmail(state))
                        state.routes.append(.registerEmail(aState.register.emailRegisterFeature))
                    } else {
                        state.routes.append(.registerEmail())
                    }
                    return .none
                case .element(id: _, action: .landingRoute(.loginButtonTapped)):
                    state.routes.append(.loginRoute)
                    return .none
                case .element(id: _, action: .registerEmail(.proceedButtonTapped)):
//                    state.routes.append(.registerPassword())
                    return .none
                case .element(id: _, action: .loginRoute):
                    return .none
//                case .element(id: _, action: .registerEmail(.binding(_))):
//                    return .none
//                case .element(id: _, action: .registerPassword(_)):
//                    return .none
                default:
                    return .none
//                case .element(id: _, action: .landingRoute(.register(_))),
//                    .element(id: _, action: .registerEmail(.binding(_))):
//                    return .none
                }
            case .onLaunch:
                if state.isAuthenticated {
                    state.routes.append(.loginRoute)
                } else {
                    state.routes.append(.landingRoute())
                }
                return .none
            }
        }
        .forEach(\.routes, action: \.routes) {
            Route()
        }
    }
}

public extension AppReducer {
    @Reducer
    struct Route {
        public enum State: Equatable {
            case landingRoute(LandingFeature.State = .init())
            case loginRoute
            case registerEmail(EmailRegister.State = .init())
//            case registerPassword(PasswordCreationFeature.State = .init())
        }

        public enum Action {
            case landingRoute(LandingFeature.Action)
            case loginRoute
            case registerEmail(EmailRegister.Action)
//            case registerPassword(PasswordCreationFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.landingRoute, action: \.landingRoute) {
                LandingFeature()
            }

            Scope(state: \.loginRoute, action: \.loginRoute) {}

//            Scope(state: \.registerEmail, action: \.registerEmail) {
//                EmailRegister()
//            }
//
//            Scope(state: \.registerPassword, action: \.registerPassword) {
//                PasswordCreationFeature()
//            }
        }
    }
}
