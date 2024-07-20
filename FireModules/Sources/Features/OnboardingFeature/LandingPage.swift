//
//  LandingPage.swift
//
//
//  Created by Hien Tran on 18/11/2023.
//

import ComposableArchitecture
import CoreUI
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
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                        Button {
                            viewStore.send(.loginButtonTapped)
                        } label: {
                            Text("Log in")
                        }

                        Button {
                            viewStore.send(.signUpButtonTapped)
                        } label: {
                            Text("Sign up")
                        }
                    }
                    .fireButtonStyle()
                }
            }
            .padding()
        }
        .hideNavigationBar()
        .enableInjection()
    }
}
