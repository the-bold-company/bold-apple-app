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
        NavigationStackStore(store.scope(state: \.routes, action: \.routes)) {
            EmptyView()
        } destination: { state in
            switch state {
            case .registerEmail:
                CaseLet(
                    /AppReducer.Route.State.registerEmail,
                    action: AppReducer.Route.Action.registerEmail
                ) { RegisterEmailPage(store: $0) }
//                RegisterEmailPage(store: Store(initialState: .init(), reducer: {
//                    EmailRegister()
//                }))
//            case .registerPassword:
//                CaseLet(
//                    /RootFeature.Path.State.registerPassword,
//                    action: RootFeature.Path.Action.registerPassword
//                ) { RegisterPasswordPage(store: $0) }
            case .landingRoute:
                CaseLet(
                    /AppReducer.Route.State.landingRoute,
                    action: AppReducer.Route.Action.landingRoute
                ) { LandingPage(store: $0) }
            case .loginRoute:
                LoginPage()
            }
        }
        .task {
            store.send(.onLaunch)
        }
        .enableInjection()
    }
}
