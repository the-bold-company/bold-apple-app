import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import Factory
import Foundation
import TCAExtensions

@Reducer
public struct ForgotPasswordFeature {
    @Reducer(state: .equatable)
    public enum Destination {
        case createNewPassword(CreateNewPasswordFeature)
    }

    public struct State: Equatable {
        @PresentationState var destination: Destination.State?
        @BindingState var emailText: String

        var forgotPasswordConfirmProgress: LoadingProgress<Confirmed, ForgotPasswordFailure> = .idle

        public init(email: Email? = nil) {
            self.emailText = email?.getOrNil() ?? ""
        }
    }

    public enum Action: BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case delegate(DelegateAction)
        case view(ViewAction)
        case _local(LocalAction)
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum ViewAction {
            case nextButtonTapped
            case backButtonTapped
        }

        @CasePathable
        public enum DelegateAction {
            case resetPasswordSuccessfully(Email)
        }

        @CasePathable
        public enum LocalAction {
            case forgotPasswordConfirmed(Email)
            case forgotPasswordFailure(ForgotPasswordFailure)
        }
    }

    @Dependency(\.forgotPassword.forgotPassword) var forgotPassword
    @Dependency(\.dismiss) var dismiss

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let ._local(localAction):
                return handleLocalAction(localAction, state: &state)
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            case let .destination(destinationAction):
                return handleDestinationDelegate(destinationAction, state: &state)
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .nextButtonTapped:
            state.forgotPasswordConfirmProgress = .loading

            return forgotPassword(.init(emailText: state.emailText))
                .map(
                    success: { [emailText = state.emailText] _ in Action._local(.forgotPasswordConfirmed(Email(emailText))) },
                    failure: { Action._local(.forgotPasswordFailure($0)) }
                )
        case .backButtonTapped:
            return .run { _ in await dismiss() }
        }
    }

    private func handleLocalAction(_ action: Action.LocalAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .forgotPasswordFailure(reason):
            state.forgotPasswordConfirmProgress = .loaded(.failure(reason))
            return .none
        case .forgotPasswordConfirmed:
            state.forgotPasswordConfirmProgress = .loaded(.success(Confirmed()))
            state.destination = .createNewPassword(.init(email: Email(state.emailText)))
            return .none
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state _: inout State) -> Effect<Action> {
        switch action {
        case .resetPasswordSuccessfully: return .none
        }
    }

    private func handleDestinationDelegate(_ action: PresentationAction<Self.Destination.Action>, state _: inout State) -> Effect<Action> {
        switch action {
        case .dismiss: return .none
        case let .presented(.createNewPassword(.destination(.presented(.otp(.delegate(.otpVerified(challenge))))))):
            guard let (email, _) = challenge[case: \.resetPasswordOTP] else { return .none }
            return .send(.delegate(.resetPasswordSuccessfully(email)))
        default: return .none
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
        case .emailInvalid:
            return "Email không hợp lệ."
        }
    }
}
