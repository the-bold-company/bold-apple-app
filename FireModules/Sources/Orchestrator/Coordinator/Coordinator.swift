import ComposableArchitecture
import DI
import DomainEntities
import KeychainServiceInterface
import OnboardingFeature
import SettingsFeature
import TCACoordinators

@Reducer
public struct Coordinator {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case landingRoute(LandingFeature.State)
            case loginRoute(LoginReducer.State)
            case homeRoute(HomeReducer.State)
            case secretDevSettingsRoute
            case devSettingsRoute(DevSettingsReducer.State)
            case authentication(SignUpFeatureCoordinator.State)
        }

        public enum Action {
            case landingRoute(LandingFeature.Action)
            case loginRoute(LoginReducer.Action)
            case homeRoute(HomeReducer.Action)
            case secretDevSettingsRoute
            case devSettingsRoute(DevSettingsReducer.Action)
            case authentication(SignUpFeatureCoordinator.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.landingRoute, action: \.landingRoute) {
                LandingFeature()
            }

            Scope(state: \.authentication, action: \.authentication) {
                SignUpFeatureCoordinator()._printChanges()
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

    public struct State: Equatable, IndexedRouterState {
        public static let authenticatedInitialState = State(
            routes: [.root(.homeRoute(.init()), embedInNavigationView: true)]
        )

        public static let unAuthenticatedInitialState = State(
            routes: [.root(.authentication(.init()), embedInNavigationView: true)]
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

    @Injected(\.keychainService) var keychainService: KeychainServiceProtocol

    public init() {}

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
                    return handleOnboardingFeatureAction(onboardingFeatureAction, index: index, state: &state)
                case let .loginRoute(logInAction):
                    return handleLoginFeatureAction(logInAction, index: index, state: &state)
                case .homeRoute:
                    break
                case .secretDevSettingsRoute:
                    state.routes.presentSheet(.devSettingsRoute(.init()))
                case .devSettingsRoute:
                    break
                case let .authentication(authenticationAction):
                    return handleAuthenticationAction(authenticationAction, index: index, state: &state)
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

    // MARK: - Authentication delegation

    private func handleAuthenticationAction(_ action: SignUpFeatureCoordinator.Action, index _: Int, state: inout State) -> Effect<Action> {
        switch action {
        case let .delegate(signUpDelegate):
            switch signUpDelegate {
            case .signUpSuccessfully:
                return .routeWithDelaysIfUnsupported(state.routes) {
                    $0.popToRoot()
                    $0.push(.homeRoute(.init()))
                }
            }
        case ._local:
            return .none
        }
    }

    // MARK: - Onboarding delegation

    private func handleOnboardingFeatureAction(_ action: LandingFeature.Action, index _: Int, state: inout State) -> Effect<Action> {
        switch action {
        case .loginButtonTapped:
            state.routes.push(.loginRoute(.init()))
        case .signUpButtonTapped:
            state.routes.push(.authentication(.init()))
        }
        return .none
    }

    // MARK: - Registration routes

//    private func handleSignUpFeatureAction(_: RegisterReducer.Action, index _: Int? = nil, state _: inout State) -> Effect<Action> {
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
//        return .none
//    }

    // MARK: - Log in routes

    private func handleLoginFeatureAction(_ action: LoginReducer.Action, index _: Int, state: inout State) -> Effect<Action> {
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
