import AuthenticationUseCase
import CasePaths
import ComposableArchitecture
import TCAExtensions

@CasePathable
public enum OTPChallenge: Equatable {
    case signUpOTP(Email)
    case resetPasswordOTP(Email, Password)

    public func challenge(withCode code: OTP) -> MFAOutput {
        @Dependency(\.mfaUseCase.validateMFA) var validateMFA

        switch self {
        case let .signUpOTP(email):
            return validateMFA(.signUpOTP(email: email, code: code))
        case let .resetPasswordOTP(email, password):
            return validateMFA(.resetPasswordOTP(email: email, password: password, code: code))
        }
    }
}

@Reducer
public struct ConfirmationCodeReducer {
    public struct State: Equatable {
        @BindingState var otpText: String = ""

        var otp = OTP.empty
        var otpVerifying: LoadingProgress<Confirmed, MFAFailure> = .idle
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
        public enum ViewAction {
            case verifyOTP
        }

        @CasePathable
        public enum DelegateAction {
            case otpVerified(OTPChallenge)
            case otpFailed(MFAFailure)
        }

        @CasePathable
        public enum LocalAction {}
    }

    @Dependency(\.mainQueue) var mainQueue

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$otpText):
                state.otp.update(state.otpText)

                if state.otpVerifying.is(\.loaded.failure) {
                    state.otpVerifying = .idle
                }
                return .none
            case let .view(viewAction):
                return handleViewAction(viewAction, state: &state)
            case let .delegate(delegateAction):
                return handleDelegateAction(delegateAction, state: &state)
            case .binding:
                return .none
            }
        }
    }

    private func handleViewAction(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
        switch action {
        case .verifyOTP:
            state.otpVerifying = .loading
            enum CancelId { case validateOTP }
            let challenge = state.challenge
            return challenge.challenge(withCode: state.otp)
                .debounce(id: CancelId.validateOTP, for: .milliseconds(300), scheduler: mainQueue)
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
            state.otpText = ""
            return .none
        case let .otpFailed(reason):
            state.otpVerifying = .loaded(.failure(reason))
            return .none
        }
    }
}

extension MFAFailure {
    var userFriendlyError: String? {
        switch self {
        case .genericError, .inputInvalid:
            return "Có lỗi xảy ra. Vui lòng thử lại."
        case .codeMismatch:
            return "Dãy số bạn điền không đúng. Bạn hãy thử lại nhé!"
        }
    }
}
