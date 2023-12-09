//
//  EmailRegistrationPage.swift
//
//
//  Created by Hien Tran on 29/11/2023.
//

import ComposableArchitecture
import CoreUI
import SwiftUI
import SwiftUIIntrospect

public struct EmailRegistrationPage: View {
    enum Route: String {
        case passwordCreation
    }

    @ObserveInjection var iO
    let store: StoreOf<RegisterReducer>

    public init(store: StoreOf<RegisterReducer>) {
        self.store = store
    }

    struct ViewState: Equatable {
        @BindingViewState var email: String
        var emailValidationError: String?
    }

    public var body: some View {
        WithViewStore(store, observe: \.viewState) { viewStore in
            VStack(alignment: .leading) {
                DismissButton()
                Spacing(height: .size40)
                Text("Enter your email address").typography(.titleScreen)
                Spacing(height: .size32)
                FireTextField(
                    title: "Your email",
                    text: viewStore.$email
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()

                Text(viewStore.emailValidationError ?? "")

                Spacing(height: .size24)

                Spacer()
                Text("By registering, you accept our ")
                    .foregroundColor(Color.coreui.forestGreen)
                    .font(.system(size: 16))
                    +
                    Text("Terms of Use")
                    .foregroundColor(Color.coreui.forestGreen)
                    .font(.system(size: 16))
                    .bold()
                    .underline()
                    +
                    Text(" and ")
                    .foregroundColor(Color.coreui.forestGreen)
                    .font(.system(size: 16))
                    +
                    Text("Privacy Policy")
                    .foregroundColor(Color.coreui.forestGreen)
                    .font(.system(size: 16))
                    .bold()
                    .underline()

                NavigationLink(
                    value: viewStore.emailValidationError == nil
                        ? Route.passwordCreation
                        : nil
                ) {
                    Text("Continue")
                }
                .fireButtonStyle()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .passwordCreation:
                RegisterPasswordPage(store: store)
            }
        }
        .enableInjection()
    }
}

extension BindingViewStore<RegisterReducer.State> {
    var viewState: EmailRegistrationPage.ViewState {
        // swiftformat:disable redundantSelf
        EmailRegistrationPage.ViewState(
            email: self.$email,
            emailValidationError: self.emailValidationError
        )
        // swiftformat:enable redundantSelf
    }
}
