#if os(iOS)
import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct SignUpFeatureRoot: View {
    let store: StoreOf<SignUpFeatureCoordinator>

    public init(store: StoreOf<SignUpFeatureCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.self, action: \._local)) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .signUp:
                    CaseLet(
                        /Destination.State.signUp,
                        action: Destination.Action.signUp,
                        then: EmailRegistrationPage.init(store:)
                    )
                case .otp:
                    CaseLet(
                        /Destination.State.otp,
                        action: Destination.Action.otp,
                        then: ConfirmationCodePage.init(store:)
                    )
                case .logIn:
                    CaseLet(
                        /Destination.State.logIn,
                        action: Destination.Action.logIn,
                        then: LoginPage.init(store:)
                    )
                case .forgotPassword:
                    CaseLet(
                        /Destination.State.forgotPassword,
                        action: Destination.Action.forgotPassword,
                        then: ForgotPasswordPage.init(store:)
                    )
                }
            }
        }
        .hideNavigationBar()
    }
}

// MARK: Previews

#Preview("Custom dependencies") {
    SignUpFeatureRoot(
        store: .init(
            initialState: .init(routes: [Route.root(.logIn(.init()), embedInNavigationView: true)]),
//            initialState: .init(routes: [Route.root(.signUp(.init()), embedInNavigationView: true)]),
            reducer: {
                SignUpFeatureCoordinator()
            },
            withDependencies: {
                $0.context = .live
                $0.devSettingsUseCase = mockDevSettingsUseCase()
            }
        )
    )
}
#endif
