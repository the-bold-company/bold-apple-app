import ComposableArchitecture
import SwiftUI

public struct TransactionsOverviewPage: View {
    let store: StoreOf<TransactionsOverviewFeature>

    public init(store: StoreOf<TransactionsOverviewFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("🌮 transactions")
            .navigationTitle("Giao dịch")
    }
}

#Preview {
    MenuSideBarWrapper(
        featureOneBuilder: {
            TransactionsOverviewPage(
                store: Store(initialState: .init()) {
                    TransactionsOverviewFeature()
                }
            )
        }
    )
    .preferredColorScheme(.light)
}
