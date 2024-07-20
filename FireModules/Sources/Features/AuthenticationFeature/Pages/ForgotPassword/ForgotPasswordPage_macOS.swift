#if os(macOS)
import AuthenticationUseCase
import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct ForgotPasswordPage: View {
    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case email
    }

    struct ViewState: Equatable {
        @BindingViewState var email: String
        var isLoading: Bool
        var userFriendlyError: String?
    }

    let store: StoreOf<ForgotPasswordFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, ForgotPasswordFeature.Action>

    public init(store: StoreOf<ForgotPasswordFeature>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Đổi mật khẩu").typography(.titleScreen)
                Spacing(height: .size12)
                Text("Nhập tài khoản email bạn muốn đổi mật khẩu")
                    .typography(.bodyDefault)
                    .foregroundStyle(Color(hex: 0x6B7280))
                Spacing(height: .size24)
                serverErrorToast
                emailInputField
                Spacing(height: .size24)
                actionButtons
            }
            .frame(width: 400)
            .padding(.all, 40)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(hex: 0xB7F2C0))
        .hideNavigationBar()
        .toolbar(.hidden)
        .navigationDestination(
            store: store.scope(
                state: \.$destination.createNewPassword,
                action: \.destination.createNewPassword
            )
        ) { CreateNewPasswordPage(store: $0) }
    }

    @ViewBuilder private var emailInputField: some View {
        MoukaTextField(
            title: "Email",
            text: viewStore.$email,
            focusedField: $focusedField,
            fieldId: .email
        )
        #if os(iOS)
        .autocapitalization(.none)
        .keyboardType(.emailAddress)
        #endif
        .autocorrectionDisabled()
    }

    @ViewBuilder private var serverErrorToast: some View {
        Group {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.coreui.sentimentNegative)
                Text(viewStore.userFriendlyError ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.red.opacity(0.1))
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.red, lineWidth: 1)
            }

            Spacing(height: .size24)
        }
        .isHidden(hidden: viewStore.userFriendlyError == nil)
    }

    @ViewBuilder private var actionButtons: some View {
        HStack(spacing: 16) {
            Button {
                store.send(.view(.backButtonTapped))
            } label: {
                Text("Trở về").frame(maxWidth: .infinity)
            }
            .moukaButtonStyle(.secondary)

            Button {
                store.send(.view(.nextButtonTapped))
            } label: {
                Text("Tiếp theo").frame(maxWidth: .infinity)
            }
            .moukaButtonStyle(disabled: viewStore.email.isEmpty)
        }
    }
}

extension BindingViewStore<ForgotPasswordFeature.State> {
    var viewState: ForgotPasswordPage.ViewState {
        // swiftformat:disable redundantSelf
        ForgotPasswordPage.ViewState(
            email: self.$emailText,
            isLoading: self.forgotPasswordConfirmProgress.is(\.loading),
            userFriendlyError: self.forgotPasswordConfirmProgress[case: \.loaded.failure]?.userFriendlyError
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordPage(
            store: Store(
                initialState: .init(email: Email("dev@mouka.com")),
                reducer: { ForgotPasswordFeature() }
//                withDependencies: {
//                    $0.authAPIService = .directMock(forgotPasswordMock: """
//                    {
//                      "message": "Execute successfully"
//                    }
//                    """)

//                    $0.authAPIService = .directMock(forgotPasswordMock: """
//                    {
//                      "message": "Username/client id combination not found.",
//                      "code": 13002
//                    }
//                    """)
//                }
            )
        )
        .preferredColorScheme(.light)
    }
}
#endif
