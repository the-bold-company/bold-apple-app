#if os(macOS)
import AuthenticationUseCase
import Combine
import ComposableArchitecture
import CoreUI
import SwiftUI

public struct LoginPage: View {
    @ObserveInjection private var iO

    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case email
        case password
    }

    struct ViewState: Equatable {
        @BindingViewState var email: String
        @BindingViewState var password: String
        var emailValidationError: String?
        var passwordValidationError: String?
        var serverError: String?
        var isLoading: Bool
    }

    let store: StoreOf<LoginReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, LoginReducer.Action>

    public init(store: StoreOf<LoginReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.viewState)
    }

    public var body: some View {
        ZStack {
            VStack(alignment: .center) {
                brandLogo
                Spacing(height: .size24)
                Text("Đăng nhập vào mouka").typography(.titleScreen)
                Spacing(height: .size24)
                errorMessage
                continueWithGoogle
                divider
                inputFields
                Spacing(height: .size24)
                loginButton
                Spacing(height: .size24)
                signUpPrompt
            }
            .frame(width: 400)
            .padding(.all, 40)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
            .padding(.horizontal, 40)
        }
        .padding()
        .background(Color(hex: 0xB7F2C0))
        .enableInjection()
    }

    @ViewBuilder private var brandLogo: some View {
        Image(systemName: "leaf")
            .resizable()
            .frame(width: 72, height: 72)
    }

    @ViewBuilder private var continueWithGoogle: some View {
        Button {
//            viewStore.send(.view(.nextButtonTapped))
        } label: {
            HStack {
                Image(systemName: "apple.logo")
                Text("Tiếp tục với Google")
            }
            .frame(maxWidth: .infinity)
        }
        .moukaButtonStyle(.secondary)
    }

    @ViewBuilder private var divider: some View {
        Spacing(height: .size16)
        HStack(spacing: 16) {
            VStack {
                Divider().background(Color(hex: 0xEBEBF0))
            }

            Text("Hoặc")
                .foregroundStyle(Color(hex: 0x6B7280))

            VStack {
                Divider().background(Color(hex: 0xEBEBF0))
            }
        }
        Spacing(height: .size16)
    }

    @ViewBuilder
    private var inputFields: some View {
        MoukaTextField(
            title: "Email",
            text: viewStore.$email,
            focusedField: $focusedField,
            fieldId: .email,
            error: viewStore.emailValidationError
        )

        Spacing(height: .size24)

        ZStack(alignment: .topTrailing) {
            MoukaSecureTextField(
                title: "Mật khẩu",
                text: viewStore.$password,
                focusedField: $focusedField,
                fieldId: .password,
                error: viewStore.passwordValidationError
            )

            Text("Quên mật khẩu?")
                .typography(.bodyDefaultBold)
                .foregroundColor(.coreui.forestGreen)
                .onTapGesture {
                    store.send(.view(.forgotPasswordButtonTapped))
                }
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var loginButton: some View {
        Button {
            viewStore.send(.view(.logInButtonTapped))
        } label: {
            Text("Đăng nhập")
                .frame(maxWidth: .infinity)
        }
        .moukaButtonStyle(.primary, disabled: viewStore.emailValidationError == nil || viewStore.passwordValidationError == nil)
    }

    @ViewBuilder private var errorMessage: some View {
        Group {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.coreui.sentimentNegative)
                Text(viewStore.serverError ?? "")
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

            Spacing(height: .size12)
        }
        .isHidden(hidden: viewStore.serverError == nil)
    }

    @ViewBuilder private var signUpPrompt: some View {
        Group {
            Text("Chưa có tài khoản? ")
                .foregroundColor(Color.coreui.forestGreen)
                .font(.system(size: 16))
                +
                Text("Đăng ký miễn phí")
                .foregroundColor(Color.coreui.forestGreen)
                .font(.system(size: 16))
                .bold()
        }
        .onTapGesture {
            store.send(.view(.signUpButtonTapped))
        }
    }
}

extension BindingViewStore<LoginReducer.State> {
    var viewState: LoginPage.ViewState {
        // swiftformat:disable redundantSelf
        LoginPage.ViewState(
            email: self.$emailText,
            password: self.$passwordText,
            emailValidationError: self.emailValidationError,
            passwordValidationError: self.passwordValidationError,
            serverError: self.serverError,
            isLoading: self.logInProgress.is(\.loading)
        )
        // swiftformat:enable redundantSelf
    }
}

// MARK: Previews

// import AuthAPIService
// import AuthAPIServiceInterface

#Preview("Custom mock") {
    LoginPage(
        store: Store(
            initialState: .init(),
            reducer: { LoginReducer() },
            withDependencies: {
                $0.context = .live
                $0.devSettingsUseCase = mockDevSettingsUseCase()
            }
        )
    )
    .previewLayout(.fixed(width: 3000, height: 2000))
}
#endif
