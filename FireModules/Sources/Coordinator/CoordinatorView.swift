//
//  CoordinatorView.swift
//
//
//  Created by Hien Tran on 10/12/2023.
//

import FundFeature
import HomeFeature
import LogInFeature
import OnboardingFeature
import SettingsFeature
import SharedModels
import SignUpFeature
import SwiftUI
import TCACoordinators

public struct CoordinatorView: View {
    let store: StoreOf<Coordinator>

    @ObservedObject var viewStore: ViewStore<ViewState, Coordinator.Action>

    struct ViewState: Equatable {
        var navigationStackCount: Int
    }

    public init(store: StoreOf<Coordinator>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
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
                case .fundCreationRoute:
                    CaseLet(
                        /Navigation.State.fundCreationRoute,
                        action: Navigation.Action.fundCreationRoute
                    ) { FundCreationPage(store: $0) }
                case .fundDetailsRoute:
                    CaseLet(
                        /Navigation.State.fundDetailsRoute,
                        action: Navigation.Action.fundDetailsRoute
                    ) { FundDetailsPage(store: $0) }
                case .secretDevSettingsRoute:
                    fatalError("This is use to invoke the dev settings using a secret gesture. It isn't a valid route, and it shouldn't go here")
                case .devSettingsRoute:
                    CaseLet(
                        /Navigation.State.devSettingsRoute,
                        action: Navigation.Action.devSettingsRoute
                    ) { DevSettingsPage(store: $0) }
                }
            }
        }
        .task {
            store.send(.onLaunch)
        }
        .onShake {
            print("Device shaken!")
            store.send(.routeAction(viewStore.navigationStackCount - 1, action: .secretDevSettingsRoute))
        }
        .enableInjection()
    }
}

extension BindingViewStore<Coordinator.State> {
    var viewState: CoordinatorView.ViewState {
        // swiftformat:disable redundantSelf
        CoordinatorView.ViewState(
            navigationStackCount: self.routes.count
        )
        // swiftformat:enable redundantSelf
    }
}
