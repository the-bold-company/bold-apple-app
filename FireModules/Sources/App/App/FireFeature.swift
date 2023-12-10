import ComposableArchitecture
import CoreUI
import HomeFeature
import LogInFeature
import OnboardingFeature
import SignUpFeature
import SwiftUI
import TCACoordinators

public struct AppView: View {
    @ObserveInjection private var iO

    let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: \.isAuthenticated) { authenticated in
            CoordinatorView(
                store: Store(
                    initialState: authenticated.state
                        ? Coordinator.State.authenticatedInitialState
                        : Coordinator.State.unAuthenticatedInitialState,
                    reducer: { Coordinator() }
                )
            )
            .task {
                store.send(.onLaunch)
            }
        }
        .enableInjection()
    }
}

@Reducer
struct Navigation {
    enum State: Equatable {
        case landingRoute(LandingFeature.State)
        case emailRegistrationRoute(RegisterReducer.State)
        case passwordCreationRoute(RegisterReducer.State)
        case login
        case home
    }

    enum Action {
        case landingRoute(LandingFeature.Action)
        case emailRegistrationRoute(RegisterReducer.Action)
        case passwordCreationRoute(RegisterReducer.Action)
        case login
        case home
    }

    var body: some ReducerOf<Self> {
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
struct Coordinator {
    struct State: Equatable, IndexedRouterState {
        static let authenticatedInitialState = State(
            routes: [.root(.home, embedInNavigationView: true)]
        )

        static let unAuthenticatedInitialState = State(
            routes: [.root(.landingRoute(.init()), embedInNavigationView: true)]
        )

        var routes: [Route<Navigation.State>]
    }

    enum Action: IndexedRouterAction {
        case routeAction(Int, action: Navigation.Action)
        case updateRoutes([Route<Navigation.State>])
    }

    var body: some ReducerOf<Self> {
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

struct CoordinatorView: View {
    let store: StoreOf<Coordinator>

    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .landingRoute:
                    CaseLet(
                        /Navigation.State.landingRoute,
                        action: Navigation.Action.landingRoute
                    ) { LandingPage(store: $0) }
                case .emailRegistrationRoute:
                    CaseLet(
                        /Navigation.State.emailRegistrationRoute,
                        action: Navigation.Action.emailRegistrationRoute
                    ) { EmailRegistrationPage(store: $0) }
                case .passwordCreationRoute:
                    CaseLet(
                        /Navigation.State.passwordCreationRoute,
                        action: Navigation.Action.passwordCreationRoute
                    ) { PasswordCreationPage(store: $0) }
                case .home:
                    HomePage()
                case .login:
                    LoginPage()
                }
            }
        }
    }
}
