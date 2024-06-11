import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import TCAExtensions

typealias PasswordValidated = [Validated<String, PasswordValidationError>]
typealias SignUpProgress = LoadingProgress<AuthenticationLogic.SignUp.Response, AuthenticationLogic.SignUp.Failure>

@Reducer
public struct PasswordSignUpReducer {
    public struct State: Equatable {
        var email: String
        @BindingState var password: String = ""
        @PresentationState var destination: Destination.State?

        var signUpProgress: SignUpProgress = .idle

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
        case destination(PresentationAction<Destination.Action>)

        @CasePathable
        public enum ViewAction {
            case onAppear
            case nextButtonTapped
            case backButtonTapped
        }

        @CasePathable
        public enum DelegateAction {
            case signUpSuccessfully(AuthenticationLogic.SignUp.Response)
            case signUpFailed(AuthenticationLogic.SignUp.Failure)
        }

        @CasePathable
        public enum LocalAction {}
    }

    @Dependency(\.dismiss) var dismiss
    @Dependency(\.signUpUseCase) var signUpUseCase

    public init() {}

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
                return handleViewAction(viewAction, state: &state)
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            case .binding(\.$password):
                state.passwordValidated = passwordValidator.validateAll(state.password)
                return .none
            case .binding:
                return .none
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .nextButtonTapped:
            // make sure email and password are valid

            state.signUpProgress = .loading

            return signUpUseCase.signUp(.init(email: state.email, password: state.password))
                .map(
                    success: { Action.delegate(.signUpSuccessfully($0)) },
                    failure: { Action.delegate(.signUpFailed($0)) }
                )
        case .backButtonTapped:
            return .run { _ in await dismiss() }
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .signUpSuccessfully(response):
            state.signUpProgress = .loaded(response)
            state.destination = .otp(.init())
            return .none
        case let .signUpFailed(error):
            state.signUpProgress = .failure(error)
            return .none
        }
    }
}

public extension PasswordSignUpReducer {
    @Reducer(state: .equatable)
    enum Destination {
        case otp(ConfirmationCodeReducer)
    }
}
