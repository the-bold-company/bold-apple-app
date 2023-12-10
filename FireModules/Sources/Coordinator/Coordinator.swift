//
//  Coordinator.swift
//
//
//  Created by Hien Tran on 10/12/2023.
//

import ComposableArchitecture
import HomeFeature
import LogInFeature
import OnboardingFeature
import SignUpFeature
import TCACoordinators

@Reducer
public struct Navigation {
    public enum State: Equatable {
        case landingRoute(LandingFeature.State)
        case emailRegistrationRoute(RegisterReducer.State)
        case passwordCreationRoute(RegisterReducer.State)
        case login
        case home
    }

    public enum Action {
        case landingRoute(LandingFeature.Action)
        case emailRegistrationRoute(RegisterReducer.Action)
        case passwordCreationRoute(RegisterReducer.Action)
        case login
        case home
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.landingRoute, action: \.landingRoute) {
            LandingFeature()
        }

        Scope(state: \.emailRegistrationRoute, action: \.emailRegistrationRoute) {
            RegisterReducer()
        }
        Scope(state: \.passwordCreationRoute, action: \.passwordCreationRoute) {
            RegisterReducer()
        }
    }
}

@Reducer
public struct Coordinator {
    public init() {}

    public struct State: Equatable, IndexedRouterState {
        public static let authenticatedInitialState = State(
            routes: [.root(.home, embedInNavigationView: true)]
        )

        public static let unAuthenticatedInitialState = State(
            routes: [.root(.landingRoute(.init()), embedInNavigationView: true)]
        )

        public var routes: [Route<Navigation.State>]

        public init(routes: [Route<Navigation.State>]) {
            self.routes = routes
        }
    }

    public enum Action: IndexedRouterAction {
        case routeAction(Int, action: Navigation.Action)
        case updateRoutes([Route<Navigation.State>])
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // MARK: - Landing Routes

            case .routeAction(_, action: .landingRoute(.loginButtonTapped)):
                state.routes.push(.login)
            case .routeAction(_, action: .landingRoute(.signUpButtonTapped)):
                state.routes.push(.emailRegistrationRoute(.init()))

            // MARK: - Registration Routes

            case let .routeAction(_, action: .emailRegistrationRoute(.navigate(.goToPasswordCreation(carriedOverState)))):
                state.routes.push(.passwordCreationRoute(carriedOverState))
            case let .routeAction(_, action: .passwordCreationRoute(.navigate(.backToEmailRegistration(carriedOverState)))):
                break
            case .routeAction(_, action: .passwordCreationRoute(.navigate(.goToHome))):
                state.routes.push(.home)
            case .routeAction(_, action: .passwordCreationRoute),
                 .routeAction(_, action: .emailRegistrationRoute):
                break
            case .routeAction(_, action: .home):
                state.routes.push(.home)
            case .routeAction(_, action: .login):
                state.routes.push(.login)
            case .updateRoutes:
                break
            }
            return .none
        }
        .forEachRoute {
            Navigation()
        }
    }
}
