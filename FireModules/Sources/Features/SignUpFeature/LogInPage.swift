import AuthenticationUseCase
import Combine
import ComposableArchitecture
import CoreUI
import SwiftUI

public struct LoginPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        @BindingViewState var email: String
        @BindingViewState var password: String
        var emailError: String?
        var passwordError: String?
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
        LoadingOverlay(loading: viewStore.isLoading) {
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
                Spacer()
            }
            .padding(16)
        }
        .hideNavigationBar()
        .enableInjection()
    }

    @ViewBuilder private var brandLogo: some View {
        Image(systemName: "b.square")
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
        .fireButtonStyle(type: .secondary(shape: .roundedCorner))
    }

    @ViewBuilder private var divider: some View {
        Spacing(height: .size16)
        ZStack {
            Divider()
                .background(Color.gray)
            Text("Hoặc")
                .padding(.horizontal, 16)
                .background(Color.white)
        }
        Spacing(height: .size16)
    }

    @ViewBuilder
    private var inputFields: some View {
        FireTextField(
            title: "Email",
            text: viewStore.$email
        )
        Group {
            Spacing(size: .size12)
            Text(viewStore.emailError ?? "")
                .typography(.bodyDefault)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .isHidden(hidden: viewStore.emailError == nil)

        Spacing(height: .size24)

        ZStack(alignment: .topTrailing) {
            FireSecureTextField(
                title: "Mật khẩu",
                text: viewStore.$password
            )

            Text("Quên mật khẩu?")
                .typography(.bodyDefaultBold)
                .foregroundColor(.coreui.forestGreen)
                .onTapGesture {
                    store.send(.view(.forgotPasswordButtonTapped))
                }
        }
        .frame(maxWidth: .infinity)

        Group {
            Spacing(size: .size12)
            Text(viewStore.passwordError ?? "")
                .typography(.bodyDefault)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .isHidden(hidden: viewStore.passwordError == nil)
    }

    @ViewBuilder
    private var loginButton: some View {
        Button {
            viewStore.send(.view(.logInButtonTapped))
        } label: {
            Text("Đăng nhập")
                .frame(maxWidth: .infinity)
        }
        .fireButtonStyle()
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
            emailError: self.emailError,
            passwordError: self.passwordError,
            serverError: self.serverError,
            isLoading: self.logInProgress.is(\.loading)
        )
        // swiftformat:enable redundantSelf
    }
}

// MARK: Previews

import AuthAPIService
import AuthAPIServiceInterface

#Preview("Custom mock") {
    NavigationStack {
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
    }
}
