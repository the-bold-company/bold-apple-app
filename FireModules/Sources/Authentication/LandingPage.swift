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

enum Route: String {
    case login
    case signup
}

public struct LandingPage: View {
    @ObserveInjection private var iO

    let store: StoreOf<LandingFeature>

    @State var route: Route?

    public init(store: StoreOf<LandingFeature>) {
        self.store = store
    }

    public var body: some View {
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
                        Button("Log in") {
//                                route = .login
                            store.send(.loginButtonTapped)
                        }

                        Button("Sign up") {
//                                route = .signup
                            store.send(.signUpButtonTapped)
                        }
                    }
                    .fireButtonStyle()
                }

//                NavigationLink(destination: LoginPage(), tag: Route.login, selection: $route) { EmptyView() }
//                NavigationLink(
//                    destination: RegisterEmailPage(store: Store(initialState: EmailRegister.State(), reducer: {
//                        EmailRegister()
//                    })),
//                    tag: Route.signup,
//                    selection: $route
//                ) { EmptyView() }
            }
            .padding()
            .navigationBarHidden(true)
//            }
        }
        ._printChanges("🌮")
        .enableInjection()
    }
}
