import ComposableArchitecture
import Coordinator
import SwiftUI
import TCACoordinators

public struct MoukaApp: View {
    let store = Store(initialState: .init()) {
        RootCoordinator()
    }

    public init() {}

    public var body: some View {
        #if os(macOS)
        RootCoordinatorView(store: store)
            .frame(minWidth: 500, minHeight: 500) // Add this on the host app to constraint the minimum size of the app window on desktop
        #elseif os(iOS)
        CoordinatorView(
            store: Store(
                initialState: Coordinator.State.unAuthenticatedInitialState,
                reducer: { Coordinator() }
            )
        )
        #endif
    }
}
