import ComposableArchitecture
import Coordinator
import Inject
import SwiftUI
import TCACoordinators

public struct AppView: View {
    @ObserveInjection private var iO

    let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: \.isAuthenticated) { authenticated in
            CoordinatorView(
                store: Store(
                    initialState: authenticated.state
                        ? Coordinator.State.authenticatedInitialState
                        : Coordinator.State.unAuthenticatedInitialState,
                    reducer: { Coordinator() }
                )
            )
            .task {
                store.send(.onLaunch)
            }
        }
        .enableInjection()
    }
}
