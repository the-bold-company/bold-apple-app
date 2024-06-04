import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import Foundation
import Utilities

@Reducer
public struct RegisterReducer {
    let signUpUseCase: SignUpUseCase

    public init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
    }

    public struct State: Equatable {
        @BindingState var email: String = ""
        @BindingState var password: String = ""

        var emailValidationError: String?
        var passwordValidationError: String?
        var accountCreationState: LoadingProgress<AuthenticatedUserEntity, AuthenticationLogic.SignUp.Failure> = .idle

        public init() {}
    }

    public enum Action: BindableAction {
        case createUserButtonTapped
        case binding(BindingAction<State>)

        case signUpSuccessfully(AuthenticationLogic.SignUp.Response)
        case signUpFailure(AuthenticationLogic.SignUp.Failure)

        case navigate(Route)
        case goToPasswordCreationButtonTapped

        public enum Route {
            case goToPasswordCreation(RegisterReducer.State)
            case backToEmailRegistration(RegisterReducer.State)
            case exitRegistrationFlow
            case goToHome
        }
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()
        EmailRegistrationReducer()
        PasswordCreationReducer(signUpUseCase: signUpUseCase)
    }
}

@Reducer
private struct EmailRegistrationReducer {
    public var body: some ReducerOf<RegisterReducer> {
        Reduce { state, action in
            switch action {
            case .binding(\.$email):
                // TODO: Add email validation rules
                if state.email.count <= 5 {
                    state.emailValidationError = "Email invalid"
                } else {
                    state.emailValidationError = nil
                }
                return .none
            case .goToPasswordCreationButtonTapped:
                return .send(.navigate(.goToPasswordCreation(state)))
            case .binding, .createUserButtonTapped, .signUpSuccessfully,
                 .signUpFailure, .navigate:
                return .none
            }
        }
    }
}

@Reducer
private struct PasswordCreationReducer {
    let signUpUseCase: SignUpUseCase

    public init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
    }

    public var body: some ReducerOf<RegisterReducer> {
        Reduce { state, action in
            switch action {
            case .binding(\.$password):
                // TODO: Password Validator
                if state.password.count <= 6 {
                    state.passwordValidationError = "Password length must be greater than 6"
                } else {
                    state.passwordValidationError = nil
                }

                return .none
            case .createUserButtonTapped:
                guard state.email.isNotEmpty, // TODO: replace this with validation rules
                      state.password.isNotEmpty // TODO: replace this with validation rules
                else { return .none }

                state.accountCreationState = .loading

                let email = state.email
                let password = state.password

                return .run { send in
                    let result = await signUpUseCase.signUp(.init(email: email, password: password))

                    switch result {
                    case let .success(response):
                        await send(.signUpSuccessfully(response))
                    case let .failure(error):
                        await send(.signUpFailure(error))
                    }
                }
            case let .signUpSuccessfully(response):
                state.accountCreationState = .loaded(response.user)
                return .send(.navigate(.goToHome))
            case let .signUpFailure(error):
                state.accountCreationState = .failure(error)
                return .none
            case .binding, .navigate, .goToPasswordCreationButtonTapped:
                return .none
            }
        }
    }
}
