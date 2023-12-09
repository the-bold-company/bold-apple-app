//
//  LandingPage.swift
//
//
//  Created by Hien Tran on 18/11/2023.
//

import ComposableArchitecture
import CoreUI
import Home
import SwiftUI

public struct LandingPage: View {
    enum Route: String {
        case login
        case signup
    }

    @ObserveInjection private var iO

    let store: StoreOf<LandingFeature>

    @State var route: Route?

    public init(store: StoreOf<LandingFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            WithViewStore(store, observe: { $0 }) { _ in
                VStack {
                    Spacer()

                    Image(systemName: "globe")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)

                    Spacer().frame(height: 20)

                    Text("Centralize your personal finance all in one place")
                        .typography(.titleSection)
                        .multilineTextAlignment(.center)
                        .padding()

                    Spacer()

                    HStack(alignment: .center) {
                        Group {
                            NavigationLink(value: Route.login) {
                                Text("Log in")
                            }

                            NavigationLink(value: Route.signup) {
                                Text("Sign up")
                            }
                        }
                        .fireButtonStyle()
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .login:
                    LoginPage()
                case .signup:
                    EmailRegistrationPage(
                        store: Store(
                            initialState: .init(),
                            reducer: { RegisterReducer() }
                        )
                    )
                }
            }
        }
        .enableInjection()
    }
}
