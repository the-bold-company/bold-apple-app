import ComposableArchitecture
import DomainEntities
import Foundation
import TCAExtensions

@Reducer
public struct EmailSignUpReducer {
    public init() {}

    public struct State: Equatable {
        @BindingState var email: String = ""
        var password: String = ""

        var emailValidationError: String {
            switch emailValidated {
            case .idle, .valid:
                return ""
            case let .invalid(_, error):
                return error.errorDescription ?? ""
            }
        }

        var emailValidated: Validated<String, EmailValidationError> = .idle("")

        @PresentationState public var destination: Destination.State?

        public init() {}
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
                switch viewAction {
                case .onAppear:
                    state.emailValidated = .idle(state.email)
                    return .none
                case .nextButtonTapped:
                    let emailValidated = emailValidator.validate(state.email)
                    state.emailValidated = emailValidated

                    if emailValidated.isValid {
                        // Call API to check if email is in the system
                        state.destination = .password(.init(email: state.email))
                    }
                    return .none
                case .signInButtonTapped:
                    return .none
                }
            case let .destination(destinationAction):
                return .none
            case .binding(\.$email):
//                state.emailValidated = emailValidator.validate(state.email)
                return .none
            case .binding:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

// @Reducer
// private struct EmailRegistrationReducer {
//    public var body: some ReducerOf<RegisterReducer> {
//        Reduce { state, action in
//            switch action {
//            case .binding(\.$email):
//                // TODO: Add email validation rules
//                if state.email.count <= 5 {
//                    state.emailValidationError = "Email invalid"
//                } else {
//                    state.emailValidationError = nil
//                }
//                return .none
//            case .goToPasswordCreationButtonTapped:
//                return .send(.navigate(.goToPasswordCreation(state)))
//            case .binding, .createUserButtonTapped, .signUpSuccessfully,
//                 .signUpFailure, .navigate:
//                return .none
//            }
//        }
//    }
// }

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
