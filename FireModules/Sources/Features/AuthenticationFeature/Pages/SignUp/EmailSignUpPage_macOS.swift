import AuthenticationUseCase
import CasePaths
import Combine
import ComposableArchitecture
import CoreUI
import SwiftUI
import SwiftUIIntrospect
import TCAExtensions

#if DEBUG
import DevSettingsUseCase
#endif

@ViewAction(for: EmailSignUpFeature.self)
public struct EmailSignUpPage: TCAView {
    @ObserveInjection var iO

    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case email
    }

    public let store: StoreOf<EmailSignUpFeature>
    @ObservedObject public private(set) var viewStore: ViewStore<ViewState, EmailSignUpFeature.Action>

    public init(store: StoreOf<EmailSignUpFeature>) {
        self.store = store
        self.viewStore = .init(store, observe: \.viewState)
    }

    public struct ViewState: Equatable {
        @BindingViewState var emailText: String
        var emailValidationError: String?
        var emailVerificationError: String?
        var isFormValid: Bool
    }

    public var body: some View {
        FloatingPanel {
            brandLogo
            Spacing(height: .size24)
            Text("Đăng ký Mouka").typography(.titleScreen)
            Spacing(height: .size24)
            errorMessage
            continueWithGoogle
            divider
            emailInputField
            Spacing(height: .size24)
            nextButton
            Spacing(height: .size24)
            logInPrompt
        }
        .toolbar(.hidden)
        .navigationDestination(
            store: store.scope(
                state: \.$destination.passwordSignUp,
                action: \.destination.passwordSignUp
            )
        ) { PasswordSignUpPage(store: $0) }
    }

    @ViewBuilder private var brandLogo: some View {
        Image(systemName: "leaf")
            .resizable()
            .frame(width: 72, height: 72)
    }

    @ViewBuilder private var errorMessage: some View {
        Group {
            ErrorBadge(errorMessage: viewStore.emailVerificationError)
            Spacing(height: .size12)
        }
        .isHidden(hidden: viewStore.emailVerificationError == nil)
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

    @ViewBuilder private var emailInputField: some View {
        MoukaTextField(
            "Nhập Email",
            title: "Email",
            text: viewStore.$emailText,
            focusedField: $focusedField,
            fieldId: .email,
            error: viewStore.emailValidationError
        )
        #if os(iOS)
        .autocapitalization(.none)
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        #endif
        .autocorrectionDisabled()
    }

    @ViewBuilder private var continueWithGoogle: some View {
        Button {
            send(.nextButtonTapped)
        } label: {
            HStack {
                Image(systemName: "apple.logo")
                Text("Tiếp tục với Google")
            }
            .frame(maxWidth: .infinity)
        }
        .fireButtonStyle(type: .secondary(shape: .roundedCorner))
    }

    @ViewBuilder private var nextButton: some View {
        Button {
            send(.nextButtonTapped)
        } label: {
            Text("Đăng ký")
                .frame(maxWidth: .infinity)
        }
        .moukaButtonStyle(disabled: !viewStore.isFormValid)
    }

    @ViewBuilder private var logInPrompt: some View {
        HStack {
            Text("Đã có tài khoản?")
                .typography(.bodyDefault)
                .foregroundColor(Color.coreui.forestGreen)

            Button {
                send(.logInButtonTapped)
            } label: {
                Text("Đăng nhập ngay")
            }
            .moukaButtonStyle(.tertiary)
        }
    }
}

extension BindingViewStore<EmailSignUpFeature.State> {
    var viewState: EmailSignUpPage.ViewState {
        // swiftformat:disable redundantSelf
        EmailSignUpPage.ViewState(
            emailText: self.$emailText,
            emailValidationError: self.emailValidationError,
            emailVerificationError: self.emailVerificationProgress[case: \.loaded.failure]?.userFriendlyError,
            isFormValid: self.emailValidated.is(\.valid)
        )
        // swiftformat:enable redundantSelf
    }
}

// MARK: Previews

import AuthAPIService

#Preview("Already registered email") {
    NavigationStack {
        EmailSignUpPage(
            store: Store(
                initialState: .init(),
                reducer: { EmailSignUpFeature() },
                withDependencies: {
                    $0.authAPIService = .directMock(verifyEmailExistenceMock: """
                    {
                      "message": "Execute successfully",
                      "data": {
                        "isExisted": false,
                        "isExternalEmail": false
                      }
                    }
                    """)
                }
            )
        )
    }
    .frame(minWidth: 500, minHeight: 800)
    .preferredColorScheme(.light)
}
