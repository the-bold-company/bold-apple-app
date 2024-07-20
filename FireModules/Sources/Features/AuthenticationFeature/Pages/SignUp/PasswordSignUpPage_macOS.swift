//
//  PasswordSignUpPage_macOS.swift
//
//
//  Created by Hien Tran on 02/12/2023.
//

import AuthenticationUseCase
import Combine
import ComposableArchitecture
import CoreUI
import DomainEntities
import Networking
import SwiftUI

#if DEBUG
import DevSettingsUseCase
#endif

public struct PasswordSignUpPage: View {
    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case password
    }

    struct ViewState: Equatable {
        @BindingViewState var passwordText: String
        var passwordValidated: PasswordValidated
        var isFormValid: Bool
        var serverError: String?
        var isLoading: Bool
    }

    let store: StoreOf<PasswordSignUpReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, PasswordSignUpReducer.Action>

    public init(store: StoreOf<PasswordSignUpReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.passwordCreationViewState)
    }

    public var body: some View {
        FloatingPanel {
            Text("Tạo mật khẩu").typography(.titleScreen)
            Spacing(height: .size24)
            errorBadge
            passwordInputField
            Spacing(height: .size40)
            actionButtons
        }
        .toolbar(.hidden)
        .navigationDestination(
            store: store.scope(
                state: \.$destination.otp,
                action: \.destination.otp
            )
        ) { ConfirmationCodePage(store: $0) }
    }

    @ViewBuilder private var errorBadge: some View {
        Group {
            ErrorBadge(errorMessage: viewStore.serverError)
            Spacing(height: .size12)
        }
        .isHidden(hidden: viewStore.serverError == nil)
    }

    @ViewBuilder private var passwordInputField: some View {
        MoukaSecureTextField(
            "Nhập mật khẩu ",
            title: "Mật khẩu",
            text: viewStore.$passwordText,
            focusedField: $focusedField,
            fieldId: .password
        )
        #if os(iOS)
        .autocapitalization(.none)
        .keyboardType(.alphabet)
        #endif
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
                    viewStore.passwordValidated[rule.rawValue].isValid
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
                            viewStore.passwordValidated[rule.rawValue].isValid
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
            MoukaButton.secondary(
                action: { store.send(.view(.backButtonTapped)) },
                label: { Text("Trở về") }
            )

            MoukaButton.primary(
                disabled: !viewStore.isFormValid,
                loading: viewStore.isLoading,
                action: { store.send(.view(.nextButtonTapped)) },
                label: { Text("Cập nhật") }
            )
        }
    }
}

private extension BindingViewStore<PasswordSignUpReducer.State> {
    var passwordCreationViewState: PasswordSignUpPage.ViewState {
        // swiftformat:disable redundantSelf
        PasswordSignUpPage.ViewState(
            passwordText: self.$passwordText,
            passwordValidated: self.password.validateAll(),
            isFormValid: self.password.isValid,
            serverError: self.signUpProgress[case: \.loaded.failure]?.userFriendlyError,
            isLoading: self.signUpProgress.is(\.loading)
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    NavigationStack {
        PasswordSignUpPage(
            store: Store(
                initialState: .init(email: Email("dev@mouka.com")),
                reducer: { PasswordSignUpReducer() },
                withDependencies: {
                    $0.authAPIService = .directMock(signUpResponseMock: """
                    {
                      "message": "Execute successfully"
                    }
                    """)

                    $0.devSettingsUseCase = mockDevSettingsUseCase()
                }
            )
        )
    }
    .frame(minWidth: 500, minHeight: 800)
    .preferredColorScheme(.light)
}
