//
//  Coordinator.swift
//
//
//  Created by Hien Tran on 10/12/2023.
//

import ComposableArchitecture
import DI
import KeychainServiceInterface
import OnboardingFeature
import SettingsFeature
import TCACoordinators

@Reducer
public struct Destination {
    public enum State: Equatable {
        case landingRoute(LandingFeature.State)
        case emailRegistrationRoute(RegisterReducer.State)
        case passwordCreationRoute(RegisterReducer.State)
        case loginRoute(LoginReducer.State)
        case homeRoute(HomeReducer.State)
        case secretDevSettingsRoute
        case devSettingsRoute(DevSettingsReducer.State)
    }

    public enum Action {
        case landingRoute(LandingFeature.Action)
        case emailRegistrationRoute(RegisterReducer.Action)
        case passwordCreationRoute(RegisterReducer.Action)
        case loginRoute(LoginReducer.Action)
        case homeRoute(HomeReducer.Action)
        case secretDevSettingsRoute
        case devSettingsRoute(DevSettingsReducer.Action)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.landingRoute, action: \.landingRoute) {
            LandingFeature()
        }

        Scope(state: \.emailRegistrationRoute, action: \.emailRegistrationRoute) {
            resolve(\SignUpFeatureContainer.registerReducer)
        }

        Scope(state: \.passwordCreationRoute, action: \.passwordCreationRoute) {
            resolve(\SignUpFeatureContainer.registerReducer)
        }

        Scope(state: \.loginRoute, action: \.loginRoute) {
            resolve(\LogInFeatureContainer.logInReducer)
        }

        Scope(state: \.homeRoute, action: \.homeRoute) {
            resolve(\HomeFeatureContainer.homeReducer)
        }

        Scope(state: \.devSettingsRoute, action: \.devSettingsRoute) {
            resolve(\SettingsFeatureContainer.devSettingsReducer)
        }
    }
}

@Reducer
public struct Coordinator {
    @Injected(\.keychainService) var keychainService: KeychainServiceProtocol

    public init() {}

    public struct State: Equatable, IndexedRouterState {
        public static let authenticatedInitialState = State(
            routes: [.root(.homeRoute(.init()), embedInNavigationView: true)]
        )

        public static let unAuthenticatedInitialState = State(
            //            routes: [.root(.landingRoute(.init()), embedInNavigationView: true)]
            routes: [.root(.loginRoute(.init()), embedInNavigationView: true)]
        )

        public var routes: [Route<Destination.State>]

        public init(routes: [Route<Destination.State>]) {
            self.routes = routes
        }
    }

    public enum Action: IndexedRouterAction, BindableAction {
        case onLaunch
        case routeAction(Int, action: Destination.Action)
        case updateRoutes([Route<Destination.State>])
        case binding(BindingAction<State>)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onLaunch:
                return .run { _ in
                    do {
                        try keychainService.removeCredentials()
                    } catch {}
                }

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
                    $0.push(.homeRoute(.init()))
                }

            // MARK: - Log in routes

            case .routeAction(_, action: .loginRoute(.navigate(.goToHome))):
                return .routeWithDelaysIfUnsupported(state.routes) {
                    $0.popToRoot()
//                    _ = $0.popLast()
                    $0.push(.homeRoute(.init()))
                    $0.remove(at: 0)
                }

            // MARK: - This section is for non-existent routes, or routes that have been handled by default. They're here just to satisfy the compiler

            case .binding,
                 .routeAction(_, action: .loginRoute),
                 .routeAction(_, action: .passwordCreationRoute),
                 .routeAction(_, action: .emailRegistrationRoute),
                 .routeAction(_, action: .homeRoute),
                 .routeAction(_, action: .devSettingsRoute):
                break
            case .routeAction(_, action: .secretDevSettingsRoute):
                state.routes.presentSheet(.devSettingsRoute(.init()))
            case .updateRoutes:
                break
            }
            return .none
        }
        .forEachRoute {
            Destination()
        }
    }
}
