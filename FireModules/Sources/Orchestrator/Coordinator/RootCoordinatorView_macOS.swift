#if os(macOS)
import AuthenticationFeature
import ComposableArchitecture
import SwiftUI
import TCAExtensions

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
                    then: EmailSignUpPage.init(store:)
                )
            case .home:
                CaseLet(
                    \RootCoordinator.Destination.State.home,
                    action: RootCoordinator.Destination.Action.home,
                    then: HomePage.init(store:)
                )
            }
        }
    }
}

#Preview {
    RootCoordinatorView(
        store: Store(
            initialState: .init()
        ) { RootCoordinator() }
    )
}

#endif
