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
    @ObserveInjection var iO

    let store: StoreOf<EmailSignUpReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, EmailSignUpReducer.Action>

    public init(store: StoreOf<EmailSignUpReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.emailRegistrationViewState)
    }

    struct ViewState: Equatable {
        @BindingViewState var email: String
        var emailValidationError: String?
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                DismissButton()
                Spacing(height: .size40)
                Text("Enter your email address").typography(.titleScreen)
                Spacing(height: .size32)

                continueWithGoogle

                Divider()

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

                Button {
                    viewStore.send(.view(.nextButtonTapped))
                } label: {
                    Text("Continue")
                }
                .fireButtonStyle()
            }
            .padding()
            .navigationBarHidden(true)
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.password,
                    action: \.destination.password
                )
            ) { PasswordCreationPage(store: $0) }
        }
        .enableInjection()
    }

    @ViewBuilder
    private var continueWithGoogle: some View {
        Button {
//            viewStore.send(.view(.nextButtonTapped))
        } label: {
            HStack {
                Image(systemName: "apple.logo")
                Text("Tiếp tục với Google")
            }
            .frame(maxWidth: .infinity)
        }
        .fireButtonStyle(type: .secondary(shape: .roundedCorner))
    }
}

extension BindingViewStore<EmailSignUpReducer.State> {
    var emailRegistrationViewState: EmailRegistrationPage.ViewState {
        // swiftformat:disable redundantSelf
        EmailRegistrationPage.ViewState(
            email: self.$email,
            emailValidationError: self.emailValidationError
        )
        // swiftformat:enable redundantSelf
    }
}
