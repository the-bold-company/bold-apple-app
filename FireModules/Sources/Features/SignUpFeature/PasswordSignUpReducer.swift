import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import TCAExtensions

typealias PasswordValidated = [Validated<String, PasswordValidationError>]

@Reducer
public struct PasswordSignUpReducer {
    public init() {}

    public struct State: Equatable {
        var email: String
        @BindingState var password: String = ""

        var accountCreationState: LoadingProgress<AuthenticatedUserEntity, AuthenticationLogic.SignUp.Failure> = .idle

        var passwordValidated = PasswordValidated()

        public init(email: String) {
            self.email = email
        }
    }

    public enum Action: BindableAction, FeatureAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)
        case binding(BindingAction<State>)

        public enum ViewAction {
            case onAppear
            case nextButtonTapped
            case backButtonTapped
        }

        public enum DelegateAction {
            case signUpSuccessfully(AuthenticatedUserEntity)
            case signUpFailed(AuthenticationLogic.SignUp.Failure)
        }

        public enum LocalAction {}
    }

    @Dependency(\.dismiss) var dismiss

    private let passwordValidator = ValidatorCollection(
        LengthValidator(min: 8, max: 60).eraseToAnyValidator(),
        LowercaseLetterValidator(atleast: 1).eraseToAnyValidator(),
        UppercaseLetterValidator(atleast: 1).eraseToAnyValidator(),
        NumericLetterValidator(atleast: 1).eraseToAnyValidator(),
        SpecilaCharacterValidator(atleast: 1).eraseToAnyValidator()
    )

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .nextButtonTapped:
                    return .none
                case .onAppear:
                    return .none
                case .backButtonTapped:
                    return .run { _ in await dismiss() }
                }
            case let .delegate(delegateAction):
                return .none
            case .binding(\.$password):
                state.passwordValidated = passwordValidator.validateAll(state.password)
                return .none
            case .binding:
                return .none
            }
        }
    }
}

// @Reducer
// private struct PasswordCreationReducer {
//    let signUpUseCase: SignUpUseCase
//
//    public init(signUpUseCase: SignUpUseCase) {
//        self.signUpUseCase = signUpUseCase
//    }
//
//    public var body: some ReducerOf<RegisterReducer> {
//        Reduce { state, action in
//            switch action {
//            case .binding(\.$password):
//                // TODO: Password Validator
//                if state.password.count <= 6 {
//                    state.passwordValidationError = "Password length must be greater than 6"
//                } else {
//                    state.passwordValidationError = nil
//                }
//
//                return .none
//            case .createUserButtonTapped:
//                guard state.email.isNotEmpty, // TODO: replace this with validation rules
//                      state.password.isNotEmpty // TODO: replace this with validation rules
//                else { return .none }
//
//                state.accountCreationState = .loading
//
//                let email = state.email
//                let password = state.password
//
//                return .run { send in
//                    let result = await signUpUseCase.signUp(.init(email: email, password: password))
//
//                    switch result {
//                    case let .success(response):
//                        await send(.signUpSuccessfully(response))
//                    case let .failure(error):
//                        await send(.signUpFailure(error))
//                    }
//                }
//            case let .signUpSuccessfully(response):
//                state.accountCreationState = .loaded(response.user)
//                return .send(.navigate(.goToHome))
//            case let .signUpFailure(error):
//                state.accountCreationState = .failure(error)
//                return .none
//            case .binding, .navigate, .goToPasswordCreationButtonTapped:
//                return .none
//            }
//        }
//    }
// }
