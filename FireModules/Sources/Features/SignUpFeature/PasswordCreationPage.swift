//
//  PasswordCreationPage.swift
//
//
//  Created by Hien Tran on 02/12/2023.
//

import AuthenticationUseCase
import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct PasswordCreationPage: View {
    @ObserveInjection var iO

    struct ViewState: Equatable {
        @BindingViewState var password: String
        var passwordValidationError: String?
        var accountCreationState: LoadingProgress<AuthenticatedUserEntity, AuthenticationLogic.SignUp.Failure>
    }

    let store: StoreOf<PasswordSignUpReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, PasswordSignUpReducer.Action>

    public init(store: StoreOf<PasswordSignUpReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.passwordCreationViewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.accountCreationState.isLoading) {
            VStack(alignment: .leading) {
                DismissButton()
                Spacing(height: .size40)
                Text("Create your password").typography(.titleScreen)
                Spacing(height: .size32)
                FireSecureTextField(
                    title: "Choose a password",
                    text: viewStore.$password
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()

                Text(viewStore.passwordValidationError ?? "")
                    .font(.custom(FontFamily.Inter.regular, size: 10))
                    .foregroundColor(.coreui.sentimentNegative)

                Spacer()

                Text(viewStore.accountCreationState.failureReason ?? "")
                    .typography(.bodyDefault)
                    .foregroundColor(.coreui.sentimentNegative)

                Button {
                    viewStore.send(.view(.nextButtonTapped))
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .fireButtonStyle(isActive: viewStore.passwordValidationError == nil)
                .disabled(viewStore.passwordValidationError != nil)
            }
            .padding()
            .navigationBarHidden(true)
        }
        .enableInjection()
    }
}

extension BindingViewStore<PasswordSignUpReducer.State> {
    var passwordCreationViewState: PasswordCreationPage.ViewState {
        // swiftformat:disable redundantSelf
        PasswordCreationPage.ViewState(
            password: self.$password,
            passwordValidationError: self.passwordValidationError,
            accountCreationState: self.accountCreationState
        )
        // swiftformat:enable redundantSelf
    }
}
