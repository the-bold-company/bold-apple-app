import AuthenticationUseCase
import ComposableArchitecture
import DevSettingsUseCase
import Factory
import Foundation
import Utilities

@Reducer
public struct LoginReducer {
    let logInUseCase: LogInUseCase

    public init(logInUseCase: LogInUseCase) {
        self.logInUseCase = logInUseCase
    }

    public struct State: Equatable {
        public init() {
            // TODO: Add if DEBUG handler for dev setting
            @Injected(\LogInFeatureContainer.devSettingsUseCase) var devSettings: DevSettingsUseCase!

            self.email = devSettings.credentials.username
            self.password = devSettings.credentials.password
        }

        @BindingState var email: String = ""
        @BindingState var password: String = ""

        var areInputsValid: Bool {
            return email.isNotEmpty && password.isNotEmpty
        }

        var logInInProgress = false
        var loginError: String?
    }

    public enum Action: BindableAction {
        case delegate(Delegate)
        case binding(BindingAction<State>)
        case navigate(Route)

        case logInSuccesfully(AuthenticationLogic.LogIn.Response)
        case logInFailure(AuthenticationLogic.LogIn.Failure)

        public enum Route {
            case goToHome
        }

        public enum Delegate {
            case logInButtonTapped
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .delegate(.logInButtonTapped):
                guard state.areInputsValid else { return .none }

                state.logInInProgress = true

                return .run { [email = state.email, password = state.password] send in
                    let result = await logInUseCase.logIn(.init(email: email, password: password))

                    switch result {
                    case let .success(response):
                        await send(.logInSuccesfully(response))
                    case let .failure(error):
                        await send(.logInFailure(error))
                    }
                }
            case .logInSuccesfully:
                state.logInInProgress = false
                return .send(.navigate(.goToHome))
            case let .logInFailure(error):
                state.loginError = error.failureReason
                state.logInInProgress = false
                return .none
            case .navigate, .binding:
                return .none
            }
        }
    }
}
