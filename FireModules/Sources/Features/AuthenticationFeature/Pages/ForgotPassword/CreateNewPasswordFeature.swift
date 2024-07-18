import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import TCAExtensions

@Reducer
public struct CreateNewPasswordFeature {
    @Reducer(state: .equatable)
    public enum Destination {
        case otp(ConfirmationCodeFeature)
    }

    public struct State: Equatable {
        @BindingState var passwordText: String = ""
        @PresentationState var destination: Destination.State?
        let email: Email
        var password = Password.empty

        public init(email: Email) {
            self.email = email
        }
    }

    public enum Action: BindableAction, FeatureAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum ViewAction {
            case nextButtonTapped
            case backButtonTapped
        }

        @CasePathable
        public enum DelegateAction {}

        @CasePathable
        public enum LocalAction {
            case updateAndValidatePassword(password: String)
        }
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.mainQueue) var mainQueue

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let ._local(localAction):
                return handleLocalAction(localAction, state: &state)
            case .binding(\.$passwordText):
                enum CancelId { case verifyPassword }

                return .run { [passwordText = state.passwordText] send in
                    await send(._local(.updateAndValidatePassword(password: passwordText)))
                }
                .debounce(id: CancelId.verifyPassword, for: .milliseconds(300), scheduler: mainQueue)
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .nextButtonTapped:
            guard let email = state.email.getSelfOrNil(), let password = state.password.getSelfOrNil() else { return .none }
            state.destination = .otp(.init(challenge: .resetPasswordOTP(email, password)))
            return .none
        case .backButtonTapped:
            return .run { _ in await dismiss() }
        }
    }

    private func handleLocalAction(_ action: Action.LocalAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .updateAndValidatePassword(passwordText):
            state.password.update(passwordText)
            return .none
        }
    }
}
