//
//  LandingPage.swift
//
//
//  Created by Hien Tran on 18/11/2023.
//

import CoreUI
import Home
import SwiftUI

enum Route: String {
    case login
    case signup
}

public struct LandingPage: View {
    @ObserveInjection private var iO

    @State var route: Route?

    public init() {}

    public var body: some View {
        NavigationView {
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
                            route = .login
                        }

                        Button("Sign up") {
                            route = .signup
                        }
                    }
                    .fireButtonStyle()
                }

                NavigationLink(destination: LoginPage(), tag: Route.login, selection: $route) { EmptyView() }
                NavigationLink(destination: SignupPage(), tag: Route.signup, selection: $route) { EmptyView() }
            }
            .padding()
        }
        .enableInjection()
    }
}
