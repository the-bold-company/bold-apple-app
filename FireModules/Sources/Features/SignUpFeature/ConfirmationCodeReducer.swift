import AuthenticationUseCase
import ComposableArchitecture
import TCAExtensions

typealias OTPVerifyingProgress = LoadingProgress<Confirmed, OTPFailure>

public enum OTPChallenge: Equatable {
    case signUpOTP(Email)
    case resetPasswordOTP(Email, Password)

    func validate() -> Self? {
        switch self {
        case let .signUpOTP(email):
            return email.isValid ? self : nil
        case let .resetPasswordOTP(email, password):
            return email.isValid && password.isValid
                ? self
                : nil
        }
    }

    func challenge(withCode code: String) -> OTPUseCaseOutput {
        @Dependency(\.mfaUseCase) var mfaUseCase

        switch self {
        case let .signUpOTP(email):
            return mfaUseCase.verifyOTP(.signUpOTP(email: email.getOrCrash(), code: code))
        case let .resetPasswordOTP(email, password):
            return mfaUseCase.confirmOTPResetPassword(.resetPasswordOTP(
                email: email.getOrCrash(),
                password: password.getOrCrash(),
                code: code
            ))
        }
    }
}

@Reducer
public struct ConfirmationCodeReducer {
    public struct State: Equatable {
        @BindingState var otpText: String = ""

        var otp = OTP.empty
        var otpVerifying: OTPVerifyingProgress = .idle
        let challenge: OTPChallenge

        public init(challenge: OTPChallenge) {
            self.challenge = challenge
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
            case otpVerified(OTPChallenge)
            case otpFailed(OTPFailure)
        }

        @CasePathable
        public enum LocalAction {
            case verifyOTP(OTPChallenge, OTP)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$otpText):
                state.otp.update(state.otpText)

                if let otp = state.otp.getSelfOrNil(), let challenge = state.challenge.validate() {
                    return .send(._local(.verifyOTP(challenge, otp)))
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
        case let .verifyOTP(challenge, code):
            state.otpVerifying = .loading
            return challenge.challenge(withCode: code.otpString)
                .map(
                    success: { _ in Action.delegate(.otpVerified(challenge)) },
                    failure: { Action.delegate(.otpFailed($0)) }
                )
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case .otpVerified:
            state.otpVerifying = .loaded(.success(Confirmed()))
            return .none
        case let .otpFailed(reason):
            state.otpVerifying = .loaded(.failure(reason))
            state.otpText = ""
            return .none
        }
    }
}

extension OTPFailure {
    var userFriendlyError: String? {
        switch self {
        case .genericError:
            return "Có lỗi xảy ra. Vui lòng thử lại."
        case .codeMismatch:
            return "Dãy số bạn điền không đúng. Bạn hãy thử lại nhé!"
        }
    }
}
