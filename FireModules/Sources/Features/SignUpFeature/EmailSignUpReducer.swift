import ComposableArchitecture
import TCAExtensions

@Reducer
public struct EmailSignUpReducer {
    public init() {}

    public struct State: Equatable {
        @BindingState var email: String = ""
        var password: String = ""

        var emailValidationError: String?

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
            case nextButtonTapped
        }

        @CasePathable
        public enum DelegateAction {}

        @CasePathable
        public enum LocalAction {}
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .view(viewAction):
                switch viewAction {
                case .nextButtonTapped:
                    state.destination = .password(.init(email: state.email))
                    return .none
                }
            case let .destination(destinationAction):
//                switch destinationAction {
//
//                case .dismiss:
//                    return .none
//                case let .presented(act):
//                    switch act {
//
//                    case .password(_):
//                        return .none
//                    }
//                }
                return .none
            case .binding(\.$email):
                if state.email.count <= 5 {
                    state.emailValidationError = "Email invalid"
                } else {
                    state.emailValidationError = nil
                }
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
