import AuthenticationUseCase
import ComposableArchitecture
import TCAExtensions

@Reducer
public struct ConfirmationCodeReducer {
    public struct State: Equatable {
        @BindingState var otp: String = ""
        var isOtpValid: Bool = false

        public init() {}
    }

    @CasePathable
    public enum Action: BindableAction, FeatureAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)
        case binding(BindingAction<State>)

        public enum ViewAction {
            case sendOTPButtonTapped
        }

        public enum DelegateAction {}
        public enum LocalAction {}
    }

    let otpValidator = OTPValidator(length: 6)

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$otp):
                state.isOtpValid = otpValidator.validate(state.otp).isValid
                return .none
            case let .view(viewAction):
                switch viewAction {
                case .sendOTPButtonTapped:
                    return .none
                }
            case .binding:
                return .none
            }
        }
    }
}
