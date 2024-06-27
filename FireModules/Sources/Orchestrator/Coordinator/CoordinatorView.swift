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
                        /Coordinator.Destination.State.landingRoute,
                        action: Coordinator.Destination.Action.landingRoute
                    ) { LandingPage(store: $0) }
                case .authentication:
                    CaseLet(
                        /Coordinator.Destination.State.authentication,
                        action: Coordinator.Destination.Action.authentication,
                        then: SignUpFeatureRoot.init(store:)
                    )
                case .homeRoute:
                    CaseLet(
                        /Coordinator.Destination.State.homeRoute,
                        action: Coordinator.Destination.Action.homeRoute
                    ) { HomePage(store: $0) }
                case .secretDevSettingsRoute:
                    fatalError("This is use to invoke the dev settings using a secret gesture. It isn't a valid route, and it shouldn't go here")
                case .devSettingsRoute:
                    CaseLet(
                        /Coordinator.Destination.State.devSettingsRoute,
                        action: Coordinator.Destination.Action.devSettingsRoute
                    ) { DevSettingsPage(store: $0) }
                }
            }
            .toolbar(.hidden)
        }
        .task {
            store.send(.onLaunch)
        }
        #if os(iOS)
        .onShake {
            store.send(.routeAction(viewStore.navigationStackCount - 1, action: .secretDevSettingsRoute))
        }
        #endif
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
