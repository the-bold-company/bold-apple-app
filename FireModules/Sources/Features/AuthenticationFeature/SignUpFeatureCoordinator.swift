import ComposableArchitecture
import DomainEntities
import TCACoordinators
import TCAExtensions

typealias Destination = SignUpFeatureCoordinator.Destination

@Reducer
public struct SignUpFeatureCoordinator {
    @Reducer
    public struct Destination {
        public enum State: Equatable {
            case signUp(EmailSignUpFeature.State)
            case logIn(LoginReducer.State)
            case forgotPassword(ForgotPasswordReducer.State)
            case otp(ConfirmationCodeReducer.State)
        }

        public enum Action {
            case signUp(EmailSignUpFeature.Action)
            case logIn(LoginReducer.Action)
            case forgotPassword(ForgotPasswordReducer.Action)
            case otp(ConfirmationCodeReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.signUp, action: \.signUp) {
                EmailSignUpFeature()
            }

            Scope(state: \.logIn, action: \.logIn) {
                LoginReducer()
            }

            Scope(state: \.otp, action: \.otp) {
                ConfirmationCodeReducer()
            }

            Scope(state: \.forgotPassword, action: \.forgotPassword) {
                ForgotPasswordReducer()
            }
        }
    }

    public struct State: Equatable, IndexedRouterState {
        static let signUpAsRoot = Self(routes: [.root(.signUp(.init()), embedInNavigationView: true)])

        public var routes: [Route<Destination.State>]

        public init(routes: [Route<Destination.State>]? = nil) {
//            self.routes = routes ?? [.root(.signUp(.init()), embedInNavigationView: true)]
            self.routes = routes ?? [.root(.logIn(.init()), embedInNavigationView: true)]
        }
    }

    public enum Action: FeatureAction {
        case delegate(DelegateAction)
        case view(ViewAction)
        case _local(LocalAction)

        @CasePathable
        public enum DelegateAction {
            case logInSuccessfully(AuthenticatedUserEntity)
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
                return .none
            case let ._local(localAction):
                return handleLocalAction(localAction, state: &state)
            }
        }
        .forEachLocalRoute {
            Destination()
        }
    }

    private func handleLocalAction(_ action: Action.LocalAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .routeAction(index, screenAction):
            switch screenAction {
            case let .signUp(signUpAction):
                return handleSignUpDelegate(signUpAction, state: &state)
            case let .otp(otpAction):
                return handleOTPDelegate(otpAction, state: &state)
            case let .logIn(logInAction):
                return handleLogInDelegate(logInAction, state: &state)
            case let .forgotPassword(forgotPasswordAction):
                return handleForgotPasswordDelegate(forgotPasswordAction, index: index, state: &state)
            }
        case .updateRoutes:
            return .none
        }
    }

    private func handleSignUpDelegate(_ action: EmailSignUpFeature.Action, state: inout State) -> Effect<Action> {
        switch action {
        case let .destination(destinationAction):
            switch destinationAction {
            case let .presented(.password(.delegate(.signUpConfirmed(email, _)))):
                state.routes.push(.otp(.init(challenge: .signUpOTP(email))))
                return .none
            default:
                return .none
            }
        case .view, .binding, ._local:
            return .none
        }
    }

    private func handleOTPDelegate(_ action: ConfirmationCodeReducer.Action, state: inout State) -> Effect<Action> {
        switch action {
        case let .delegate(delegateAction):
            switch delegateAction {
            case let .otpVerified(challenge):
                switch challenge {
                case let .signUpOTP(email),
                     let .resetPasswordOTP(email, _):
                    return .routeWithDelaysIfUnsupported(state.routes) {
                        $0.popToRoot()
                        $0.push(.logIn(.init(email: email)))
                    }
                }

            case .otpFailed:
                return .none
            }
        case .binding, ._local:
            return .none
        }
    }

    private func handleLogInDelegate(_ action: LoginReducer.Action, state: inout State) -> Effect<Action> {
        switch action {
        case let .delegate(delegateAction):
            switch delegateAction {
            case let .userLoggedIn(user):
                return .send(.delegate(.logInSuccessfully(user)))
            case .logInFailed:
                return .none
            case let .forgotPasswordInitiated(email):
                state.routes.push(.forgotPassword(.init(email: email)))

                return .none
            case .signUpInitiate:
                return .routeWithDelaysIfUnsupported(state.routes) {
                    $0.popToRoot()
                    $0.push(.signUp(.init()))
                    $0.remove(at: 0)
                }
            }
        case .binding, .view, ._local:
            return .none
        }
    }

    private func handleForgotPasswordDelegate(_ action: ForgotPasswordReducer.Action, index _: Int, state: inout State) -> Effect<Action> {
        switch action {
        case let .delegate(delegateAction):
            switch delegateAction {
            case .dismiss:
                state.routes.goBack()
                return .none
            }
        case let .destination(destinationAction):
            switch destinationAction {
            case let .presented(.createNewPassword(.delegate(.signUpConfirmed(email, password)))):
                state.routes.push(.otp(.init(challenge: .resetPasswordOTP(email, password))))
                return .none
            default:
                return .none
            }
        case .binding, .view, ._local:
            return .none
        }
    }
}
