import ComposableArchitecture
import Coordinator
import SwiftUI
import TCACoordinators

public struct AppView: View {
    public init() {}

    public var body: some View {
        CoordinatorView(
            store: Store(
                initialState: Coordinator.State.authenticatedInitialState,
                reducer: { Coordinator() }
            )
        )
    }
}
