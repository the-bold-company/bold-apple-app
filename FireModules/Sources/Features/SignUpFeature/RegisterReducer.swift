import AuthenticationUseCase
import ComposableArchitecture
import DomainEntities
import Foundation
import TCAExtensions
import Utilities

@Reducer
public struct RegisterReducer {
    let signUpUseCase: SignUpUseCase

    public init(signUpUseCase: SignUpUseCase) {
        self.signUpUseCase = signUpUseCase
    }

    public struct State: Equatable {
        public var emailSignUp: EmailSignUpReducer.State = .init()
        public init() {}
    }

    public enum Action: FeatureAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)

        public enum ViewAction {}

        public enum DelegateAction {}

        @CasePathable
        public enum LocalAction {
            case emailSignUp(EmailSignUpReducer.Action)
        }
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.emailSignUp, action: /Action._local .. /Action.LocalAction.emailSignUp) {
            EmailSignUpReducer()
        }
    }
}
