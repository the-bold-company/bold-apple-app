import App
import ComposableArchitecture
import SwiftUI

@main
struct FireApp: App {
    static let store = Store(
        initialState: AppReducer.State(),
        reducer: { AppReducer() }
    )

    var body: some Scene {
        WindowGroup {
            AppView(store: FireApp.store)
        }
    }
}
