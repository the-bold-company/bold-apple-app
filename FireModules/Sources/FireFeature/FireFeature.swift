import Authentication
import ComposableArchitecture
import CoreUI
import Home
import SwiftUI

public struct AppView: View {
    @ObserveInjection private var iO

    let store: StoreOf<AppReducer>

    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: \.isAuthenticated) { authenticated in
            if authenticated.state {
                HomePage()
            } else {
                LandingPage(
                    store: Store(
                        initialState: .init(),
                        reducer: { LandingFeature() }
                    )
                )
            }
        }
        .task {
            store.send(.onLaunch)
        }
        .enableInjection()
    }
}
