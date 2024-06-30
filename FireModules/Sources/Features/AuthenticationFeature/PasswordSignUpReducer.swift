import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import TCAExtensions

#if DEBUG
import DevSettingsUseCase
#endif

typealias PasswordValidated = [Validated<String, PasswordValidationError>]
typealias SignUpProgress = LoadingProgress<Confirmed, AuthenticationLogic.SignUp.Failure>
struct Confirmed: Equatable {}

@Reducer
public struct PasswordSignUpReducer {
    public struct State: Equatable {
        @BindingState var passwordText: String = ""
        let email: Email
        var password = Password.empty

        var passwordValidated: PasswordValidated {
            password.validateAll()
        }

        var signUpProgress: SignUpProgress = .idle

        public init(email: Email) {
            self.email = email

            #if DEBUG
            @Dependency(\.devSettingsUseCase) var devSettings: DevSettingsUseCase
            self.passwordText = devSettings.credentials.password
            self.password = Password(passwordText)
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
            case onAppear
            case nextButtonTapped
            case backButtonTapped
        }

        @CasePathable
        public enum DelegateAction {
            case signUpConfirmed(Email, Password)
            case signUpFailed(AuthenticationLogic.SignUp.Failure)
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
                state.password.update(state.passwordText)
                return .none
            case .binding:
                return .none
            }
        }
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .nextButtonTapped:
            let email = state.email
            let password = state.password
            guard let emailString = email.getOrNil(), let passwordString = password.getOrNil() else { return .none }

            state.signUpProgress = .loading

            return signUpUseCase.signUp(.init(email: emailString, password: passwordString))
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
