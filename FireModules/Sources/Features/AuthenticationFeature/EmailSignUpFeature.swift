import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import Foundation
import TCAExtensions

#if DEBUG
import DevSettingsUseCase
#endif

@Reducer
public struct EmailSignUpFeature {
    public init() {}

    public struct State: Equatable {
        @BindingState var emailText: String = ""
        @PresentationState public var destination: Destination.State?
        var email = Email.empty
        var emailValidationError: String?
        var emailVerificationProgress: LoadingProgress<Confirmed, VerifyEmailRegistrationFailure> = .idle

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
        public enum LocalAction {
            case emailHasNotBeenRegistered
            case emailVerificationFailed(VerifyEmailRegistrationFailure)
        }
    }

    @Dependency(\.verifyEmailUseCase.verifyExistence) var verifyEmailExistence

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            case let ._local(localAction):
                return handleLocalAction(localAction, state: &state)
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

            guard let email = state.email.getOrNil() else { return .none }

            state.emailVerificationProgress = .loading

            return verifyEmailExistence(.init(email: email))
                .map(
                    success: { _ in Action._local(.emailHasNotBeenRegistered) },
                    failure: { Action._local(.emailVerificationFailed($0)) }
                )
        case .signInButtonTapped:
            return .none
        }
    }

    private func handleLocalAction(_ action: Action.LocalAction, state: inout State) -> Effect<Action> {
        switch action {
        case .emailHasNotBeenRegistered:
            state.emailVerificationProgress = .loaded(.success(Confirmed()))
            state.destination = .password(.init(email: state.email))
        case let .emailVerificationFailed(reason):
            state.emailVerificationProgress = .loaded(.failure(reason))
        }
        return .none
    }

    private func handleDelegateAction(_: Action.DelegateAction, state _: inout State) -> Effect<Action> {
        return .none
    }
}

public extension EmailSignUpFeature {
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

extension VerifyEmailRegistrationFailure {
    var userFriendlyError: String {
        switch self {
        case .genericError:
            return "Oops! Đã xảy ra sự cố khi đăng kỳ. Hãy thử lại sau một chút."
        case .emailAlreadyRegistered:
            return "Tài khoản đã tồn tại. Vui lòng đăng nhập hoặc sử dụng email khác để đăng ký."
        }
    }
}
