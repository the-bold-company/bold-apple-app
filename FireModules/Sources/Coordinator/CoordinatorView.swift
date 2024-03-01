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
import RecordTransactionFeature
import SettingsFeature
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
                        /Destination.State.landingRoute,
                        action: Destination.Action.landingRoute
                    ) { LandingPage(store: $0) }
                case .emailRegistrationRoute:
                    CaseLet(
                        /Destination.State.emailRegistrationRoute,
                        action: Destination.Action.emailRegistrationRoute
                    ) { EmailRegistrationPage(store: $0) }
                case .passwordCreationRoute:
                    CaseLet(
                        /Destination.State.passwordCreationRoute,
                        action: Destination.Action.passwordCreationRoute
                    ) { PasswordCreationPage(store: $0) }
                case .loginRoute:
                    CaseLet(
                        /Destination.State.loginRoute,
                        action: Destination.Action.loginRoute
                    ) { LoginPage(store: $0) }
                case .homeRoute:
                    CaseLet(
                        /Destination.State.homeRoute,
                        action: Destination.Action.homeRoute
                    ) { HomePage(store: $0) }
                case .secretDevSettingsRoute:
                    fatalError("This is use to invoke the dev settings using a secret gesture. It isn't a valid route, and it shouldn't go here")
                case .devSettingsRoute:
                    CaseLet(
                        /Destination.State.devSettingsRoute,
                        action: Destination.Action.devSettingsRoute
                    ) { DevSettingsPage(store: $0) }
                }
            }
        }
        .task {
            store.send(.onLaunch)
        }
        .onShake {
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
