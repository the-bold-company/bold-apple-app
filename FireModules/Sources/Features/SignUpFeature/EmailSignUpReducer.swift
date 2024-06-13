import ComposableArchitecture
import DomainEntities
import Foundation
import TCAExtensions

#if DEBUG
    import DevSettingsUseCase
#endif

@Reducer
public struct EmailSignUpReducer {
    public init() {}

    public struct State: Equatable {
        @BindingState var emailText: String = ""
        var email = Email.empty
        var emailValidationError: String?

        @PresentationState public var destination: Destination.State?

        public init() {
            #if DEBUG
                @Dependency(\.devSettingsUseCase) var devSettings: DevSettingsUseCase
                self.emailText = devSettings.credentials.username
                self.email = Email(emailText)
            #endif
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
            case signInButtonTapped
        }

        @CasePathable
        public enum DelegateAction {}

        @CasePathable
        public enum LocalAction {}
    }

    private let emailValidator = EmailValidator()

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
//            case let .delegate(delegateAction):
//                return handleDelegateAction(delegateAction, state: &state)
            case .binding(\.$emailText):
                state.email.update(state.emailText)
                return .none
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .nextButtonTapped:
            switch state.email.value {
            case .success:
                state.emailValidationError = nil
            case let .failure(error):
                state.emailValidationError = error.errorDescription
            }

            guard state.email.getOrNil() != nil else { return .none }

            // TODO: Call API to check if email is in the system
            state.destination = .password(.init(email: state.email))
            return .none
        case .signInButtonTapped:
            return .none
        }
    }

    private func handleDelegateAction(_: Action.DelegateAction, state _: inout State) -> Effect<Action> {
        return .none
    }
}

public extension EmailSignUpReducer {
    @Reducer
    struct Destination {
        public enum State: Equatable {
            case password(PasswordSignUpReducer.State)
        }

        public enum Action {
            case password(PasswordSignUpReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.password, action: \.password) {
                PasswordSignUpReducer()
            }
        }
    }
}
