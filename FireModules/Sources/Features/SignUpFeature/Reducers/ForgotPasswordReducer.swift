import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import Factory
import Foundation
import TCAExtensions

@Reducer
public struct ForgotPasswordReducer {
    public struct State: Equatable {
        @PresentationState var destination: Destination.State?
        @BindingState var emailText: String

        var forgotPasswordConfirmProgress: LoadingProgress<Confirmed, ForgotPasswordFailure> = .idle

        var email: Email { Email(emailText) }
        var emailValidationError: String?

        public init(email: Email? = nil) {
            self.emailText = email?.getOrNil() ?? ""
        }
    }

    public enum Action: BindableAction, FeatureAction {
        case destination(PresentationAction<Destination.Action>)
        case binding(BindingAction<State>)
        case delegate(DelegateAction)
        case view(ViewAction)
        case _local(LocalAction)

        @CasePathable
        public enum ViewAction {
            case nextButtonTapped
            case backButtonTapped
        }

        @CasePathable
        public enum DelegateAction {
            case dismiss
        }

        @CasePathable
        public enum LocalAction {
            case forgotPasswordConfirmed(Email)
            case forgotPasswordFailure(ForgotPasswordFailure)
        }
    }

    @Dependency(\.forgotPassword.forgotPassword) var forgotPassword

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let ._local(localAction):
                return handleLocalAction(localAction, state: &state)
            case .destination, .binding, .delegate:
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
            if let emailText = state.email.getOrNil() {
                state.emailValidationError = nil
                state.forgotPasswordConfirmProgress = .loading
                let email = state.email

                return forgotPassword(.init(email: emailText))
                    .map(
                        success: { _ in Action._local(.forgotPasswordConfirmed(email)) },
                        failure: { Action._local(.forgotPasswordFailure($0)) }
                    )
            } else {
                state.emailValidationError = "Email không hợp lệ."
            }

            return .none
        case .backButtonTapped:
            return .send(.delegate(.dismiss))
        }
    }

//    private func handleDelegateAction(_ action: Action.DelegateAction, state _: inout State) -> Effect<Action> {
//        switch action {
//        case .dismiss:
//            return .none
//        }
//    }

    private func handleLocalAction(_ action: Action.LocalAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .forgotPasswordFailure(reason):
            state.forgotPasswordConfirmProgress = .loaded(.failure(reason))
            return .none
        case .forgotPasswordConfirmed:
            state.forgotPasswordConfirmProgress = .loaded(.success(Confirmed()))
            guard state.email.isValid else { return .none }
            state.destination = .createNewPassword(.init(email: state.email))
            return .none
        }
    }
}

public extension ForgotPasswordReducer {
    @Reducer
    struct Destination: Equatable {
        public enum State: Equatable {
            case createNewPassword(CreateNewPasswordReducer.State)
        }

        public enum Action {
            case createNewPassword(CreateNewPasswordReducer.Action)
        }

        public var body: some ReducerOf<Self> {
            Scope(state: \.createNewPassword, action: \.createNewPassword) {
                CreateNewPasswordReducer()
            }
        }
    }
}

extension ForgotPasswordFailure {
    var userFriendlyError: String? {
        switch self {
        case .genericError:
            return "Oops! Đã xảy ra sự cố khi đổi mật khẩu. Hãy thử lại sau một chút."
        case .emailHasNotBeenRegistered:
            return "Email này không có trong hệ thống của mouka. Vui lòng kiểm tra lại hoặc thử một email khác."
        }
    }
}
