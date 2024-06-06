//
//  Coordinator.swift
//
//
//  Created by Hien Tran on 10/12/2023.
//

import ComposableArchitecture
import DI
import DomainEntities
import KeychainServiceInterface
import OnboardingFeature
import SettingsFeature
import TCACoordinators

@Reducer
public struct Destination {
    public enum State: Equatable {
        case landingRoute(LandingFeature.State)
        case signUpRoute(RegisterReducer.State)
        case loginRoute(LoginReducer.State)
        case homeRoute(HomeReducer.State)
        case secretDevSettingsRoute
        case devSettingsRoute(DevSettingsReducer.State)
    }

    public enum Action {
        case landingRoute(LandingFeature.Action)
        case signUpRoute(RegisterReducer.Action)
        case loginRoute(LoginReducer.Action)
        case homeRoute(HomeReducer.Action)
        case secretDevSettingsRoute
        case devSettingsRoute(DevSettingsReducer.Action)
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.landingRoute, action: \.landingRoute) {
            LandingFeature()
        }

        Scope(state: \.signUpRoute, action: \.signUpRoute) {
            resolve(\SignUpFeatureContainer.registerReducer)
        }

        Scope(state: \.loginRoute, action: \.loginRoute) {
            resolve(\LogInFeatureContainer.logInReducer)?._printChanges()
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

//    @ObservableState
    public struct State: Equatable, IndexedRouterState {
        public static let authenticatedInitialState = State(
            //            routes: [.root(.homeRoute(.init()), embedInNavigationView: true)]
//            routes: [.root(.loginRoute(.init()), embedInNavigationView: true)]
            routes: [.root(.signUpRoute(.init()), embedInNavigationView: true)]
        )

        public static let unAuthenticatedInitialState = State(
            //            routes: [.root(.loginRoute(.init()), embedInNavigationView: true)]
            routes: [.root(.signUpRoute(.init()), embedInNavigationView: true)]
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

            case let .routeAction(index, screenAction):
                switch screenAction {
                case let .landingRoute(onboardingFeatureAction):
                    return handleOnboardingFeatureAction(onboardingFeatureAction, state: &state)
                case let .signUpRoute(signUpAction):
//                    return handleSignUpFeatureAction(signUpAction, state: &state)
                    return .none
                case let .loginRoute(logInAction):
                    return handleLoginFeatureAction(logInAction, state: &state)
                case let .homeRoute(homeAction):
                    break
                case .secretDevSettingsRoute:
                    state.routes.presentSheet(.devSettingsRoute(.init()))
                case let .devSettingsRoute(devSettingsAction):
                    break
                }
            case .updateRoutes, .binding:
                break
            }
            return .none
        }
        .forEachRoute {
            Destination()
        }
    }

    // MARK: - Onboarding routes

    private func handleOnboardingFeatureAction(_ action: LandingFeature.Action, index _: Int? = nil, state: inout State) -> Effect<Action> {
        switch action {
        case .loginButtonTapped:
            state.routes.push(.loginRoute(.init()))
        case .signUpButtonTapped:
            state.routes.push(.signUpRoute(.init()))
        }
        return .none
    }

    // MARK: - Registration routes

    private func handleSignUpFeatureAction(_: RegisterReducer.Action, index _: Int? = nil, state _: inout State) -> Effect<Action> {
//        switch action {
//        case let .navigate(routeAction):
//            switch routeAction {
//            case let .goToPasswordCreation(carriedOverState):
//                state.routes.push(.passwordCreationRoute(carriedOverState))
//            case .goToHome:
//                return .routeWithDelaysIfUnsupported(state.routes) {
//                    $0.popToRoot()
//                    $0.push(.homeRoute(.init()))
//                }
//                break
//            case .backToEmailRegistration,
//                 .exitRegistrationFlow:
//                break
//            }
//        case .binding,
//             .createUserButtonTapped,
//             .signUpSuccessfully,
//             .signUpFailure,
//             .goToPasswordCreationButtonTapped:
//            break
//        }
        return .none
    }

    // MARK: - Log in routes

    private func handleLoginFeatureAction(_ action: LoginReducer.Action, index _: Int? = nil, state: inout State) -> Effect<Action> {
        switch action {
        case let .delegate(delegateAction):
            switch delegateAction {
            case let .userLoggedIn(user):
//                state.authenticatedUser = user
                return .routeWithDelaysIfUnsupported(state.routes) {
                    $0.popToRoot()
//                    _ = $0.popLast()
                    $0.push(.homeRoute(.init()))
                    $0.remove(at: 0)
                }
            case .logInFailed:
                break
            }
        case .binding, .view, ._local:
            break
        }
        return .none
    }
}
