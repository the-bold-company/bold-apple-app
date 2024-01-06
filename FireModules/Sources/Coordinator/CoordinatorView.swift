//
//  CoordinatorView.swift
//
//
//  Created by Hien Tran on 10/12/2023.
//

import HomeFeature
import Inject
import LogInFeature
import OnboardingFeature
import SignUpFeature
import SwiftUI
import TCACoordinators

public struct CoordinatorView: View {
    @ObserveInjection private var iO

    let store: StoreOf<Coordinator>

    public init(store: StoreOf<Coordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .landingRoute:
                    CaseLet(
                        /Navigation.State.landingRoute,
                        action: Navigation.Action.landingRoute
                    ) { LandingPage(store: $0) }
                case .emailRegistrationRoute:
                    CaseLet(
                        /Navigation.State.emailRegistrationRoute,
                        action: Navigation.Action.emailRegistrationRoute
                    ) { EmailRegistrationPage(store: $0) }
                case .passwordCreationRoute:
                    CaseLet(
                        /Navigation.State.passwordCreationRoute,
                        action: Navigation.Action.passwordCreationRoute
                    ) { PasswordCreationPage(store: $0) }
                case .loginRoute:
                    CaseLet(
                        /Navigation.State.loginRoute,
                        action: Navigation.Action.loginRoute
                    ) { LoginPage(store: $0) }
                case .homeRoute:
                    CaseLet(
                        /Navigation.State.homeRoute,
                        action: Navigation.Action.homeRoute
                    ) { HomePage(store: $0) }
                }
            }
        }
        .task {
            store.send(.onLaunch)
        }
        .enableInjection()
    }
}

#Preview {
    CoordinatorView(
        store: Store(
            initialState: Coordinator.State.unAuthenticatedInitialState,
            reducer: { Coordinator() }
        )
    )
}
