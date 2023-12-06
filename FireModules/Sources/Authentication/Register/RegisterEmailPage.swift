//
//  RegisterEmailPage.swift
//
//
//  Created by Hien Tran on 29/11/2023.
//

import ComposableArchitecture
import CoreUI
import SwiftUI
import SwiftUIIntrospect

public struct RegisterEmailPage: View {
    @ObserveInjection var iO
    let store: StoreOf<EmailRegister>

    public init(store: StoreOf<EmailRegister>) {
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

                Button {
//                    viewStore.send(.proceedNextStep)
//                    viewStore.send(.loginButtonTapped)
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .fireButtonStyle()
                .disabled(viewStore.emailValidationError != nil)

                Spacer()
                Text("By registering, you accept our ")
                    .foregroundColor(Color.coreui.forestGreen)
                    .font(.system(size: 16))
                    +
                    Text("Terms of Use")
                    .foregroundColor(Color.coreui.forestGreen)
                    .bold()
                    .underline()
                    +
                    Text(" and ")
                    .foregroundColor(Color.coreui.forestGreen)
                    .font(.system(size: 16))
                    +
                    Text("Privacy Policy")
                    .foregroundColor(Color.coreui.forestGreen)
                    .bold()
                    .underline()
            }
            .padding()
            .navigationBarHidden(true)
        }
//        ._printChanges("🌮")
        .enableInjection()
    }
}

extension BindingViewStore<EmailRegister.State> {
    var viewState: RegisterEmailPage.ViewState {
        // swiftformat:disable redundantSelf
        RegisterEmailPage.ViewState(
            email: self.$email,
            emailValidationError: self.emailValidationError
        )
        // swiftformat:enable redundantSelf
    }
}
