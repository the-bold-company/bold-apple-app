#if os(macOS)

import AuthenticationFeature
import ComposableArchitecture
import HomeFeature
import SwiftUI

public struct RootCoordinatorView: View {
    let store: StoreOf<RootCoordinator>

    public init(store: StoreOf<RootCoordinator>) {
        self.store = store
    }

    public var body: some View {
        NavigationStackStore(store.scope(state: \.routes, action: \.routes)) {
            ZStack {}
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: 0xB7F2C0))
        } destination: { store in
            switch store {
            case .logIn:
                CaseLet(
                    \RootCoordinator.Destination.State.logIn,
                    action: RootCoordinator.Destination.Action.logIn,
                    then: LoginPage.init(store:)
                )
            case .signUp:
                CaseLet(
                    \RootCoordinator.Destination.State.signUp,
                    action: RootCoordinator.Destination.Action.signUp,
                    then: EmailRegistrationPage.init(store:)
                )
            case .homeRoute:
                CaseLet(
                    \RootCoordinator.Destination.State.homeRoute,
                    action: RootCoordinator.Destination.Action.homeRoute,
                    then: HomePage.init(store:)
                )
            }
        }
    }
}
#endif
