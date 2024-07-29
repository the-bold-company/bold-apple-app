#if os(macOS)
import AuthenticationFeature
import ComposableArchitecture
import DomainEntities
import KeychainServiceInterface

@Reducer
public struct RootCoordinator {
    @Reducer(state: .equatable)
    public enum Destination {
        case home(HomeFeature)
        case logIn(LogInFeature)
        case signUp(EmailSignUpFeature)
    }

    public struct State: Equatable {
        var routes = StackState<Destination.State>()

        public init(initialRoute: Destination.State? = nil) {
            if let initialRoute {
                routes.append(initialRoute)
            }
        }
    }

    public enum Action {
        case routes(StackActionOf<Destination>)
        case view(ViewAction)

        @CasePathable
        public enum ViewAction {
            case onAppear
        }
    }

    @Dependency(\.keychainService.getAccessToken) var getAccessToken

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let .routes(.element(id, destinationAction)):
                switch destinationAction {
                case .home:
                    break
                case let .logIn(logInAction):
                    return handleLogInAction(logInAction, id: id, state: &state)
                case let .signUp(signUpAction):
                    return handleSignUpAction(signUpAction, id: id, state: &state)
                }
            case let .routes(.popFrom(id: id)):
                break
            case let .routes(.push(id: id, state: state)):
                break
            }
            return .none
        }
        .forEach(\.routes, action: \.routes)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .onAppear:
            if getAccessToken().is(\.success) {
                state.routes.removeAll()
                state.routes.append(.home(.init()))
            } else {
                state.routes.removeAll()
                state.routes.append(.logIn(.init()))
            }

            return .none
        }
    }

    private func handleLogInAction(_ action: LogInFeature.Action, id _: StackElementID, state: inout State) -> Effect<Action> {
        switch action {
        case let .delegate(delegateAction):
            switch delegateAction {
            case .userLoggedIn:
                state.routes.removeAll()
                state.routes.append(.home(.init()))
                return .none
            case .logInFailed:
                return .none
            case .signUpInitiate:
                state.routes.removeAll()
                state.routes.append(.signUp(.init()))
                return .none
            }
        case .binding, .view, ._local:
            return .none
        case .destination:
            return .none
        }
    }

    private func handleSignUpAction(_ action: EmailSignUpFeature.Action, id _: StackElementID, state: inout State) -> Effect<Action> {
        switch action {
        case let .delegate(delegateAction):
            switch delegateAction {
            case let .logInFlowInitiated(email):
                state.routes.removeAll()
                state.routes.append(.logIn(.init(email: email)))
                return .none
            case let .signUpSuccessfully(email):
                state.routes.removeAll()
                state.routes.append(.logIn(.init(email: email)))
                return .none
            }
        case .binding, .view, ._local:
            return .none
        case .destination:
            return .none
        }
    }
}
#endif
