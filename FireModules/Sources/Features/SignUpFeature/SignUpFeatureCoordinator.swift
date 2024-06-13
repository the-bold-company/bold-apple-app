import ComposableArchitecture
import TCACoordinators
import TCAExtensions

typealias Destination = SignUpFeatureCoordinator.Destination

@Reducer
public struct SignUpFeatureCoordinator {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case signUp(EmailSignUpReducer.State)
            case logIn
            case forgotPassword
            case otp(ConfirmationCodeReducer.State)
        }

        public enum Action {
            case signUp(EmailSignUpReducer.Action)
            case logIn
            case forgotPassword
            case otp(ConfirmationCodeReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.signUp, action: \.signUp) {
                EmailSignUpReducer()
            }

            Scope(state: \.otp, action: \.otp) {
                ConfirmationCodeReducer()
            }
        }
    }

    public struct State: Equatable, IndexedRouterState {
        static let signUpAsRoot = Self(routes: [.root(.signUp(.init()), embedInNavigationView: true)])

        public var routes: [Route<Destination.State>]

        public init(routes: [Route<Destination.State>]? = nil) {
            self.routes = routes ?? [.root(.signUp(.init()), embedInNavigationView: true)]
        }
    }

    public enum Action: FeatureAction {
        case delegate(DelegateAction)
        case view(ViewAction)
        case _local(LocalAction)

        @CasePathable
        public enum DelegateAction {
            case signUpSuccessfully(Email)
        }

        @CasePathable
        public enum ViewAction {}

        @CasePathable
        public enum LocalAction: IndexedRouterAction {
            case routeAction(Int, action: Destination.Action)
            case updateRoutes([Route<Destination.State>])
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            case let ._local(localAction):
                return handleLocalAction(localAction, state: &state)
            }
        }
        .forEachLocalRoute {
            Destination()
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state _: inout State) -> Effect<Action> {
        switch action {
        case .signUpSuccessfully:
            return .none
        }
    }

    private func handleLocalAction(_ action: Action.LocalAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .routeAction(_, screenAction):
            switch screenAction {
            case let .signUp(signUpAction):
                return handleSignUpDelegate(signUpAction, state: &state)
            case let .otp(otpAction):
                return handleOTPDelegate(otpAction, state: &state)
            case .logIn:
                return .none
            case .forgotPassword:
                return .none
            }
        case .updateRoutes:
            return .none
        }
    }

    private func handleSignUpDelegate(_ action: EmailSignUpReducer.Action, state: inout State) -> Effect<Action> {
        switch action {
        case let .destination(destinationAction):
            switch destinationAction {
            case let .presented(.password(.delegate(.signUpConfirmed(email, _)))):
                state.routes.push(.otp(.init(email: email)))
                return .none
            default:
                return .none
            }
        case .view, .binding:
            return .none
        }
    }

    private func handleOTPDelegate(_ action: ConfirmationCodeReducer.Action, state _: inout State) -> Effect<Action> {
        switch action {
        case let .delegate(delegateAction):
            switch delegateAction {
            case let .otpVerified(email):
                return .send(.delegate(.signUpSuccessfully(email)))
            case .otpFailed:
                return .none
            }
        case .binding, ._local:
            return .none
        }
    }
}
