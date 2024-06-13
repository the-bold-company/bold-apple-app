import AuthenticationUseCase
import ComposableArchitecture
import TCAExtensions

typealias OTPVerifyingProgress = LoadingProgress<Confirmed, OTPFailure>

@Reducer
public struct ConfirmationCodeReducer {
    public struct State: Equatable {
        @BindingState var otpText: String = ""
        let email: Email

        var otp = OTP.empty
        var otpVerifying: OTPVerifyingProgress = .idle

        public init(email: Email) {
            self.email = email
        }
    }

    @CasePathable
    public enum Action: BindableAction, FeatureAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)
        case binding(BindingAction<State>)

        @CasePathable
        public enum ViewAction {}

        @CasePathable
        public enum DelegateAction {
            case otpVerified(Email)
            case otpFailed(OTPFailure)
        }

        @CasePathable
        public enum LocalAction {
            case verifyOTP(email: String, code: String)
        }
    }

    @Dependency(\.mfaUseCase.verifyOTP) var verifyOTP

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$otpText):
                state.otp.update(state.otpText)

                if let otp = state.otp.getOrNil(), let email = state.email.getOrNil() {
                    return .send(._local(.verifyOTP(email: email, code: otp)))
                }
                return .none
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let ._local(localAction):
                return handleLocalAction(localAction, state: &state)
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            case .binding:
                return .none
            }
        }
    }

    private func handleViewAction(_: Action.ViewAction, state _: inout State) -> Effect<Action> {
        return .none
    }

    private func handleLocalAction(_ action: Action.LocalAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .verifyOTP(email, code):
            state.otpVerifying = .loading
            return verifyOTP(.init(email: email, code: code))
                .map(
                    success: { _ in Action.delegate(.otpVerified(Email(email))) },
                    failure: { Action.delegate(.otpFailed($0)) }
                )
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case .otpVerified:
            state.otpVerifying = .loaded(Confirmed())
            return .none
        case .otpFailed:
            return .none
        }
    }
}
