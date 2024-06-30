import AuthenticationUseCase
import ComposableArchitecture
import Foundation
import TCAExtensions
import Utilities

#if DEBUG
import DevSettingsUseCase
#endif

@Reducer
public struct LoginReducer {
    public struct State: Equatable {
        @BindingState var emailText: String = ""
        @BindingState var passwordText: String = ""

        var logInProgress: LoadingProgress<AuthenticatedUserEntity, LogInFailure> = .idle
        var serverError: String?

        var email: Email { Email(emailText) }
        var password: NonEmptyString { NonEmptyString(passwordText) }
        var emailValidationError: String?
        var passwordValidationError: String?

        public init(email: Email? = nil) {
            #if DEBUG // && os(iOS)
//                @Dependency(\.devSettingsUseCase) var devSettings: DevSettingsUseCase
//
//                self.emailText = email?.emailString ?? devSettings.credentials.username
//                self.passwordText = email == nil
//                    ? devSettings.credentials.password
//                    : ""
//                self.email = email
            self.emailText = email?.emailString ?? ""
            #else
            self.email = email
//                self.emailText = email?.emailString ?? ""
            #endif
        }
    }

    public enum Action: BindableAction, FeatureAction {
        case binding(BindingAction<State>)
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)

        @CasePathable
        public enum DelegateAction {
            case userLoggedIn(AuthenticatedUserEntity)
            case logInFailed(AuthenticationLogic.LogIn.Failure)
            case forgotPasswordInitiated(Email?)
            case signUpInitiate
        }

        @CasePathable
        public enum ViewAction {
            case logInButtonTapped
            case forgotPasswordButtonTapped
            case signUpButtonTapped
        }

        @CasePathable
        public enum LocalAction {
            case verifyEmail
            case verifyPassword
        }
    }

    @Dependency(\.logInUseCase.logIn) var logIn
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
                .debounce(id: CancelId.verifyEmail, for: .milliseconds(300), scheduler: mainQueue)
            case .binding(\.$passwordText):
                enum CancelId { case verifyPassword }

                return .run { send in
                    await send(._local(.verifyPassword))
                }
                .debounce(id: CancelId.verifyPassword, for: .milliseconds(300), scheduler: mainQueue)
            case .binding:
                return .none
            }
        }
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .logInButtonTapped:
            guard let email = state.email.getOrNil(),
                  let password = state.password.getOrNil()
            else { return .none }

            state.logInProgress = .loading

            return logIn(.init(email: email, password: password))
                .map(
                    success: { Action.delegate(.userLoggedIn($0.user)) },
                    failure: { Action.delegate(.logInFailed($0)) }
                )
        case .forgotPasswordButtonTapped:
            return .send(.delegate(.forgotPasswordInitiated(state.email.isValid ? state.email : nil)))
        case .signUpButtonTapped:
            return .send(.delegate(.signUpInitiate))
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .userLoggedIn(user):
            state.serverError = nil
            state.logInProgress = .loaded(.success(user))
            return .none
        case let .logInFailed(error):
            state.logInProgress = .loaded(.failure(error))

            switch error {
            case .genericError:
                state.serverError = "Oops! Đã xảy ra sự cố khi đăng nhập. Hãy thử lại sau một chút."
            case .invalidCredentials:
                state.serverError = "Tên đăng nhập hoặc mật khẩu không đúng. Vui lòng thử lại hoặc đăng ký tài khoản mới!"
                // state.serverError = "Tài khoản này đã được đăng ký với một cách khác. Hãy đăng nhập lại hoặc chọn cách đăng ký khác."
            }
            return .none
        case .forgotPasswordInitiated, .signUpInitiate:
            return .none
        }
    }

    private func handleLocalAction(_ action: Action.LocalAction, state: inout State) -> Effect<Action> {
        switch action {
        case .verifyEmail:
            let emailError = state.email.getErrorOrNil()

            switch emailError {
            case .patternInvalid:
                state.emailValidationError = "Email không hợp lệ."
            case .fieldEmpty:
                state.emailValidationError = "Vui lòng điền thông tin."
            case .none:
                state.emailValidationError = nil
            }
            return .none
        case .verifyPassword:
            let passwordError = state.password.getErrorOrNil()

            state.passwordValidationError = passwordError != nil
                ? "Vui lòng điền thông tin."
                : nil
            return .none
        }
    }
}