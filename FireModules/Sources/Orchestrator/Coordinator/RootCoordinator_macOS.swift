#if os(macOS)
import AuthenticationFeature
import ComposableArchitecture
import DI
import DomainEntities
import HomeFeature

@Reducer
public struct RootCoordinator {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case homeRoute(HomeReducer.State)
            case logIn(LogInFeature.State)
        }

        public enum Action {
            case homeRoute(HomeReducer.Action)
            case logIn(LogInFeature.Action)
        }

        public var body: some Reducer<State, Action> {
            Scope(state: \.logIn, action: \.logIn) {
                LogInFeature()
            }

            Scope(state: \.homeRoute, action: \.homeRoute) {
                resolve(\HomeFeatureContainer.homeReducer)
            }
        }
    }

    public struct State: Equatable {
        var routes = StackState<Destination.State>()

        public init(initialRoute: Destination.State? = .logIn(.init())) {
            if let initialRoute {
                routes.append(initialRoute)
            }
        }
    }

    public enum Action {
        case routes(StackActionOf<Destination>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case let .routes(.element(id, destinationAction)):
                switch destinationAction {
                case .homeRoute:
                    break
                case let .logIn(logInAction):
                    return handleLogInAction(logInAction, id: id, state: &state)
                }
            case let .routes(.popFrom(id: id)):
                break
            case let .routes(.push(id: id, state: state)):
                break
            }
            return .none
        }
        .forEach(\.routes, action: \.routes) {
            Destination()
        }
    }

    // MARK: - Authentication delegation

    private func handleLogInAction(_ action: LogInFeature.Action, id _: StackElementID, state: inout State) -> Effect<Action> {
        switch action {
        case let .delegate(delegateAction):
            switch delegateAction {
            case .userLoggedIn:
                state.routes.removeAll()
                state.routes.append(.homeRoute(.init()))
                return .none
            case .logInFailed:
                return .none
            case .forgotPasswordInitiated:
                return .none
            case .signUpInitiate:
                return .none
            }
        case .binding, .view, ._local:
            return .none
        }
    }
}
#endif
