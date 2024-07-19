import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import TCAExtensions

#if DEBUG
import DevSettingsUseCase
#endif

typealias SignUpProgress = LoadingProgress<Confirmed, SignUpFailure>
struct Confirmed: Equatable {}

@Reducer
public struct PasswordSignUpReducer {
    public struct State: Equatable {
        @BindingState var passwordText: String = ""
        let email: Email
        var password: Password { .init(passwordText) }
        var signUpProgress: SignUpProgress = .idle

        public init(email: Email) {
            self.email = email

            #if DEBUG
            @Dependency(\.devSettingsUseCase) var devSettings: DevSettingsUseCase
            self.passwordText = devSettings.credentials.password
            #endif
        }
    }

    public enum Action: BindableAction, FeatureAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)
        case binding(BindingAction<State>)

        @CasePathable
        public enum ViewAction {
            case nextButtonTapped
            case backButtonTapped
        }

        @CasePathable
        public enum DelegateAction {
            case signUpConfirmed(Email, Password)
            case signUpFailed(SignUpFailure)
        }

        @CasePathable
        public enum LocalAction {}
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.signUpUseCase) var signUpUseCase

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            case .binding(\.$passwordText):
                return .none
            case .binding:
                return .none
            }
        }
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .nextButtonTapped:
            guard let email = state.email.getSelfOrNil(), let password = state.password.getSelfOrNil() else { return .none }

            state.signUpProgress = .loading

            return signUpUseCase.signUp(.init(email: email, password: password))
                .map(
                    success: { _ in Action.delegate(.signUpConfirmed(email, password)) },
                    failure: { Action.delegate(.signUpFailed($0)) }
                )
        case .backButtonTapped:
            return .run { _ in await dismiss() }
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case .signUpConfirmed:
            state.signUpProgress = .loaded(.success(Confirmed()))
            return .none
        case let .signUpFailed(error):
            state.signUpProgress = .loaded(.failure(error))
            return .none
        }
    }
}

extension SignUpFailure {
    var userFriendlyError: String? {
        switch self {
        case .genericError:
            return "Something went wrong, please try again later"
        case .invalidInputs:
            return "Invalid inputs"
        }
    }
}
