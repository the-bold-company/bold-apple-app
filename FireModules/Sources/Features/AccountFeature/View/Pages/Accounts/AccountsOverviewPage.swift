import ComposableArchitecture
import SwiftUI

public struct AccountsOverviewPage: View {
    let store: StoreOf<AccountsOverviewFeature>

    public init(store: StoreOf<AccountsOverviewFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("🌮 Account overview")
    }
}
