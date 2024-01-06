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
        case loginRoute(LoginReducer.State)
        case home
    }

    public enum Action {
        case landingRoute(LandingFeature.Action)
        case emailRegistrationRoute(RegisterReducer.Action)
        case passwordCreationRoute(RegisterReducer.Action)
        case loginRoute(LoginReducer.Action)
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
        
        Scope(state: \.loginRoute, action: \.loginRoute) {
            LoginReducer()
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
            // MARK: - Landing routes

            case .routeAction(_, action: .landingRoute(.loginButtonTapped)):
                state.routes.push(.loginRoute(.init()))
            case .routeAction(_, action: .landingRoute(.signUpButtonTapped)):
                state.routes.push(.emailRegistrationRoute(.init()))

            // MARK: - Registration routes

            case let .routeAction(_, action: .emailRegistrationRoute(.navigate(.goToPasswordCreation(carriedOverState)))):
                state.routes.push(.passwordCreationRoute(carriedOverState))
            case .routeAction(_, action: .passwordCreationRoute(.navigate(.backToEmailRegistration))):
                break
            case .routeAction(_, action: .passwordCreationRoute(.navigate(.goToHome))):
                return .routeWithDelaysIfUnsupported(state.routes) {
                    $0.popToRoot()
                    _ = $0.popLast()
                    $0.push(.home)
                }

            // MARK: - Home routes

            case .routeAction(_, action: .home):
                state.routes.push(.home)

            // MARK: - Log in routes

            case .routeAction(_, action: .loginRoute(.navigate(.goToHome))):
                return .routeWithDelaysIfUnsupported(state.routes) {
                    $0.popToRoot()
                    _ = $0.popLast()
                    $0.push(.home)
                }

            // MARK: - This section is for non-existent routes, or routes that have been handled by default. They're here just to satisfy the compiler

            case .routeAction(_, action: .loginRoute),
                 .routeAction(_, action: .passwordCreationRoute),
                 .routeAction(_, action: .emailRegistrationRoute):
                break
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
