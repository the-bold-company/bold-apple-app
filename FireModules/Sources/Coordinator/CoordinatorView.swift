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

    @State private var model = SettingsModel()
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
                case .devSettingsRoute:
                    DevSettingsPage(
                        viewModel: .init(
                            settings: model.betaSettings,
                            externalData: .init(),
                            save: { newValue in
                                print("🔥 Save save")
                                model.betaSettings = newValue
                            },
                            dismiss: {}
                        )
                    )
                }
            }
        }
        .task {
            store.send(.onLaunch)
        }
        .gesture(
            LongPressGesture(minimumDuration: 2.0)
                .onEnded { _ in
                    store.send(.routeAction(viewStore.navigationStackCount - 1, action: .devSettingsRoute))
                }
        )
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
