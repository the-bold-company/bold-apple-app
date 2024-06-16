import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import TCAExtensions

@Reducer
public struct CreateNewPasswordReducer {
    public struct State: Equatable {
        @BindingState var passwordText: String = ""
        let email: Email
        var password = Password.empty

        var passwordValidated: PasswordValidated {
            password.validateAll()
        }

        public init(email: Email) {
            self.email = email
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
        }

        @CasePathable
        public enum LocalAction {}
    }

    @Dependency(\.dismiss) var dismiss

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
        case .nextButtonTapped:
            guard let email = state.email.getSelfOrNil(), let password = state.password.getSelfOrNil() else { return .none }
            return .send(.delegate(.signUpConfirmed(email, password)))
        case .backButtonTapped:
            return .run { _ in await dismiss() }
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state _: inout State) -> Effect<Action> {
        switch action {
        case .signUpConfirmed:
            return .none
        }
    }
}
