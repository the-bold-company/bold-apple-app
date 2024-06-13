import AuthenticationUseCase
import ComposableArchitecture
import DevSettingsUseCase
import Factory
import Foundation
import TCAExtensions
import Utilities

@Reducer
public struct LoginReducer {
    private let logInUseCase: LogInUseCase

    public init(logInUseCase: LogInUseCase) {
        self.logInUseCase = logInUseCase
    }

    public struct State: Equatable {
        public init() {
            #if DEBUG
                @Injected(\LogInFeatureContainer.devSettingsUseCase) var devSettings: DevSettingsUseCase!

                self.email = devSettings.credentials.username
                self.password = devSettings.credentials.password
            #endif
        }

        @BindingState var email: String = ""
        @BindingState var password: String = ""

        var areInputsValid: Bool {
            return email.isNotEmpty && password.isNotEmpty
        }

        var logInInProgress = false
        var loginError: String?
    }

    public enum Action: BindableAction, FeatureAction {
//        case delegate(Delegate)
        case binding(BindingAction<State>)
//        case navigate(Route)

//        case logInSuccesfully(AuthenticationLogic.LogIn.Response)
//        case logInFailure(AuthenticationLogic.LogIn.Failure)

        case view(ViewAction)
        case delegate(DelegateAction)
        case _local(LocalAction)

        public enum DelegateAction {
            case userLoggedIn(AuthenticatedUserEntity)
            case logInFailed(AuthenticationLogic.LogIn.Failure)
        }

        public enum ViewAction {
            case logInButtonTapped
        }

        public enum LocalAction {
//            case userLoggedIn(AuthenticatedUserEntity)
//            case logInFailed(AuthenticationLogic.LogIn.Failure)
        }

//        public enum Route {
//            case goToHome
//        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
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
        case .logInButtonTapped:
            guard state.areInputsValid else { return .none }

            state.logInInProgress = true

            return logInUseCase.logIn(.init(email: state.email, password: state.password))
                .map(
                    success: { Action.delegate(.userLoggedIn($0.user)) },
                    failure: { Action.delegate(.logInFailed($0)) }
                )

            // Old implementation, keep for future reference
            //                return .run { [email = state.email, password = state.password] send in
            //                    let result = await logInUseCase.logIn(.init(email: email, password: password))
            //
            //                    switch result {
            //                    case let .success(response):
            //                        await send(.logInSuccesfully(response))
            //                    case let .failure(error):
            //                        await send(.logInFailure(error))
            //                    }
            //                }
        }
    }

    private func handleDelegateAction(_ action: Action.DelegateAction, state: inout State) -> Effect<Action> {
        switch action {
        case let .userLoggedIn(authenticatedUserEntity):
            state.logInInProgress = false
            return .none
        case let .logInFailed(error):
            state.loginError = error.failureReason
            state.logInInProgress = false
            return .none
        }
    }
}
