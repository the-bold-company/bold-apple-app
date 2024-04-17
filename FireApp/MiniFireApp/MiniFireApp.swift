import ComposableArchitecture
import Inject
import MiniApp
import SwiftUI

@main
struct MiniFireApp: App {
    @ObserveInjection private var iO

    private static let store = Store(initialState: MiniAppReducer.State()) {
        MiniAppReducer()
    }

    var body: some Scene {
        WindowGroup {
            MiniApp(store: MiniFireApp.store)
                .enableInjection()
        }
    }
}
