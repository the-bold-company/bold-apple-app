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
        var passwordValidated: [Validated<String, PasswordValidationError>]
        var accountCreationState: LoadingProgress<AuthenticatedUserEntity, AuthenticationLogic.SignUp.Failure>

        var isFormValid: Bool {
            !passwordValidated.isEmpty && passwordValidated.reduce(true) { $0 && $1.isValid }
        }
    }

    let store: StoreOf<PasswordSignUpReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, PasswordSignUpReducer.Action>

    public init(store: StoreOf<PasswordSignUpReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.passwordCreationViewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.accountCreationState.isLoading) {
            VStack(alignment: .center) {
                Spacing(height: .size24)
                Text("Tạo mật khẩu").typography(.titleScreen)
                Spacing(height: .size24)
                passwordInputField
                Spacer()
                actionButtons
            }
            .padding(16)
            .navigationBarHidden(true)
        }
        .enableInjection()
    }

    @ViewBuilder private var passwordInputField: some View {
        FireSecureTextField(
            "Nhập mật khẩu ",
            title: "Mật khẩu",
            text: viewStore.$password
        )
        .autocapitalization(.none)
        .keyboardType(.alphabet)
        .textContentType(.password)
        .autocorrectionDisabled()
        Spacing(height: .size24)
        Text("Hãy đảm bảo mật khẩu của bạn:")
            .typography(.bodyLargeBold)
            .frame(maxWidth: .infinity, alignment: .leading)
        Spacing(height: .size8)
        VStack(spacing: 4) {
            ForEach(PasswordValidationError.allCases, id: \.rawValue) { rule in
                HStack {
                    !viewStore.passwordValidated.isEmpty
                        && viewStore.passwordValidated[rule.rawValue].isValid

                        ? AnyView(
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .foregroundColor(Color.coreui.brightGreen)
                                .frame(width: 16, height: 16)
                        )
                        : AnyView(
                            Text("•")
                                .foregroundColor(.gray)
                                .frame(width: 16, height: 16)
                        )
                    Text(rule.ruleDescription)
                        .typography(.bodyLarge)
                        .foregroundColor(
                            !viewStore.passwordValidated.isEmpty
                                && viewStore.passwordValidated[rule.rawValue].isValid
                                ? .black
                                : .gray
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    @ViewBuilder private var actionButtons: some View {
        HStack(spacing: 16) {
            Button {
                store.send(.view(.backButtonTapped))
            } label: {
                Text("Trở về").frame(maxWidth: .infinity)
            }
            .fireButtonStyle(type: .secondary(shape: .roundedCorner))

            Button {
                //
            } label: {
                Text("Cập nhật").frame(maxWidth: .infinity)
            }
            .fireButtonStyle(isActive: viewStore.isFormValid)
        }
    }
}

extension BindingViewStore<PasswordSignUpReducer.State> {
    var passwordCreationViewState: PasswordCreationPage.ViewState {
        // swiftformat:disable redundantSelf
        PasswordCreationPage.ViewState(
            password: self.$password,
            passwordValidated: self.passwordValidated,
            accountCreationState: self.accountCreationState
        )
        // swiftformat:enable redundantSelf
    }
}
