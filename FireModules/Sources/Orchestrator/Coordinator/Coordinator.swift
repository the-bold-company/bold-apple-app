#if os(iOS)
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
            case homeRoute(HomeFeature.State)
            case secretDevSettingsRoute
            case devSettingsRoute(DevSettingsReducer.State)
//            case authentication(SignUpFeatureCoordinator.State)
            case logIn(LogInFeature.State)
        }

        public enum Action {
            case landingRoute(LandingFeature.Action)
            case homeRoute(HomeFeature.Action)
            case secretDevSettingsRoute
            case devSettingsRoute(DevSettingsReducer.Action)
//            case authentication(SignUpFeatureCoordinator.Action)
            case logIn(LogInFeature.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.landingRoute, action: \.landingRoute) {
                LandingFeature()
            }

//            Scope(state: \.authentication, action: \.authentication) {
//                SignUpFeatureCoordinator()
//            }

            Scope(state: \.logIn, action: \.logIn) {
                LogInFeature()
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
            //            routes: [.root(.authentication(.init()), embedInNavigationView: true)]
            routes: [.root(.logIn(.init()), embedInNavigationView: true)]
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
//                return .run { _ in
//                    do {
//                        try keychainService.removeCredentials()
//                    } catch {}
//                }
                return .none

            case let .routeAction(index, screenAction):
                switch screenAction {
                case let .landingRoute(onboardingFeatureAction):
                    return handleOnboardingFeatureAction(onboardingFeatureAction, index: index, state: &state)
                case .homeRoute:
                    break
                case .secretDevSettingsRoute:
                    state.routes.presentSheet(.devSettingsRoute(.init()))
                case .devSettingsRoute:
                    break
//                case let .authentication(authenticationAction):
//                    return handleAuthenticationAction(authenticationAction, index: index, state: &state)
                case let .logIn(logInAction):
                    return handleAuthenticationAction(logInAction, index: index, state: &state)
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

    private func handleAuthenticationAction(_ action: LogInFeature.Action, index _: Int, state: inout State) -> Effect<Action> {
        switch action {
//        case let .delegate(signUpDelegate):
//            switch signUpDelegate {
//            case .logInSuccessfully:
//                return .routeWithDelaysIfUnsupported(state.routes) {
//                    $0.popToRoot()
//                    $0.push(.homeRoute(.init()))
//                }
//            }
//        case ._local:
//            return .none
        case let .delegate(delegateAction):
            switch delegateAction {
            case .userLoggedIn:
                return .routeWithDelaysIfUnsupported(state.routes) {
                    $0.popToRoot()
                    $0.push(.homeRoute(.init()))
                }
            case .logInFailed, .forgotPasswordInitiated, .signUpInitiate:
                return .none
            }
        case .binding, .view, ._local:
            return .none
        }
    }

    // MARK: - Onboarding delegation

    private func handleOnboardingFeatureAction(_ action: LandingFeature.Action, index _: Int, state _: inout State) -> Effect<Action> {
        switch action {
        case .loginButtonTapped:
//            state.routes.push(.loginRoute(.init()))
            break
        case .signUpButtonTapped:
//            state.routes.push(.authentication(.init()))
            break
        }
        return .none
    }
}
#endif
