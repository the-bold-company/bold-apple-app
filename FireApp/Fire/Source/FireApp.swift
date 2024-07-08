import App
import ComposableArchitecture
import SwiftUI

@main
struct FireApp: App {
    var body: some Scene {
        WindowGroup {
            MoukaApp()
                .preferredColorScheme(.light)
        }
    }
}
