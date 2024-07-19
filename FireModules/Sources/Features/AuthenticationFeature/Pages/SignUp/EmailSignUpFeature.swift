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
    @Reducer(state: .equatable)
    public enum Destination {
        case password(PasswordSignUpReducer)
    }

    public struct State: Equatable {
        @BindingState var emailText: String = ""
        @PresentationState var destination: Destination.State?
        var email: Email { .init(emailText) }
        var emailVerificationProgress: LoadingProgress<Confirmed, VerifyEmailFailure> = .idle
        var emailValidated: EmailValidated = .idle("")
        var emailValidationError: String? {
            switch emailValidated {
            case .idle, .valid: return nil
            case let .invalid(_, err):
                switch err {
                case .patternInvalid: return "Email không hợp lệ. Bạn hãy thử lại nhé."
                case .fieldEmpty: return "Vui lòng điền thông tin."
                }
            }
        }

        public init() {
//            #if DEBUG
//            @Dependency(\.devSettingsUseCase) var devSettings: DevSettingsUseCase
//            self.emailText = devSettings.credentials.username
//            self.email = Email(emailText)
//            #endif
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
            case logInButtonTapped
        }

        @CasePathable
        public enum DelegateAction {
            case logInFlowInitiated(Email?)
            case emailIsAvailable
            case failedToConfirmEmailExistence(VerifyEmailFailure)
        }

        @CasePathable
        public enum LocalAction {
            case verifyEmail
        }
    }

    @Dependency(\.verifyEmailUseCase.verifyExistence) var verifyEmailExistence
    @Dependency(\.mainQueue) var mainQueue

    public init() {}

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
                enum CancelId { case verifyEmail }

                return .run { send in
                    await send(._local(.verifyEmail))
                }
                .debounce(id: CancelId.verifyEmail, for: .milliseconds(200), scheduler: mainQueue)
            case .binding, .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .nextButtonTapped:
            enum CancelId { case verifyEmailExistence }

            guard let email = state.email.getOrNil() else { return .none } // TODO: Move this check to use case

            state.emailVerificationProgress = .loading

            return verifyEmailExistence(.init(email: email))
                .debounce(id: CancelId.verifyEmailExistence, for: .milliseconds(200), scheduler: mainQueue)
                .map(
                    success: { _ in Action.delegate(.emailIsAvailable) },
                    failure: { Action.delegate(.failedToConfirmEmailExistence($0)) }
                )
        case .logInButtonTapped:
            return .send(.delegate(.logInFlowInitiated(state.email.isValid ? state.email : nil)))
        }
    }

    private func handleLocalAction(_ action: Action.LocalAction, state: inout State) -> Effect<Action> {
        switch action {
        case .verifyEmail:
            state.emailValidated = state.email.validation
            return .none
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case .logInFlowInitiated:
            return .none
        case .emailIsAvailable:
            state.emailVerificationProgress = .loaded(.success(Confirmed()))
            state.destination = .password(.init(email: state.email))
            return .none
        case let .failedToConfirmEmailExistence(error):
            state.emailVerificationProgress = .loaded(.failure(error))
            return .none
        }
    }
}

extension VerifyEmailFailure {
    var userFriendlyError: String {
        switch self {
        case .genericError:
            return "Oops! Đã xảy ra sự cố khi đăng kỳ. Hãy thử lại sau một chút."
        case .emailAlreadyRegistered:
            return "Tài khoản đã tồn tại. Vui lòng đăng nhập hoặc sử dụng email khác để đăng ký."
        }
    }
}
