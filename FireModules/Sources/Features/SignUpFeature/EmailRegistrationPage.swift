import AuthenticationUseCase
import Combine
import ComposableArchitecture
import CoreUI
import Networking
import SwiftUI
import SwiftUIIntrospect

#if DEBUG
    import DevSettingsUseCase
#endif

@ViewAction(for: EmailSignUpReducer.self)
public struct EmailRegistrationPage: View {
    @ObserveInjection var iO

    public let store: StoreOf<EmailSignUpReducer>
    @ObservedObject private var viewStore: ViewStore<ViewState, EmailSignUpReducer.Action>

    public init(store: StoreOf<EmailSignUpReducer>) {
        self.store = store
        self.viewStore = .init(store, observe: \.viewState)
    }

    struct ViewState: Equatable {
        @BindingViewState var email: String
        var emailValidationError: String?
        var emailVerificationError: String?
        var isEmailBeingVerified: Bool
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.isEmailBeingVerified) {
            NavigationStack {
                VStack(alignment: .center) {
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
                    Spacer()
                }
                .padding(16)
                .toolbar(.hidden)
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.password,
                        action: \.destination.password
                    )
                ) { PasswordCreationPage(store: $0) }
            }
        }
        .enableInjection()
    }

    @ViewBuilder private var brandLogo: some View {
        Image(systemName: "b.square")
            .resizable()
            .frame(width: 72, height: 72)
    }

    @ViewBuilder private var errorMessage: some View {
        Group {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text(viewStore.emailVerificationError ?? "")
                    .frame(maxWidth: .infinity)
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
        FireTextField(
            "Nhập Email",
            title: "Email",
            text: viewStore.$email
        )
        .autocapitalization(.none)
        .keyboardType(.emailAddress)
        .textContentType(.emailAddress)
        .autocorrectionDisabled()

        Text(viewStore.emailValidationError ?? " ")
            .typography(.bodyDefault)
            .foregroundColor(.red)
            .frame(maxWidth: .infinity, alignment: .leading)
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
        .fireButtonStyle()
    }

    @ViewBuilder private var logInPrompt: some View {
        Text("Đã có tài khoản? ")
            .foregroundColor(Color.coreui.forestGreen)
            .font(.system(size: 16))
            +
            Text("Đăng nhập ngay")
            .foregroundColor(Color.coreui.forestGreen)
            .font(.system(size: 16))
            .bold()
//                    .onTapGesture(perform: {
//                        //
//                    })
//                    .underline()
    }
}

extension BindingViewStore<EmailSignUpReducer.State> {
    var viewState: EmailRegistrationPage.ViewState {
        // swiftformat:disable redundantSelf
        EmailRegistrationPage.ViewState(
            email: self.$emailText,
            emailValidationError: self.emailValidationError,
            emailVerificationError: self.emailVerificationProgress[case: \.loaded.failure]?.userFriendlyError,
            isEmailBeingVerified: self.emailVerificationProgress.is(\.loading)
        )
        // swiftformat:enable redundantSelf
    }
}

// MARK: Previews

#Preview("Already registered email") {
    NavigationStack {
        EmailRegistrationPage(
            store: Store(
                initialState: .init(),
                reducer: { EmailSignUpReducer() },
                withDependencies: {
                    $0.devSettingsUseCase = mockDevSettingsUseCase()
                    $0.verifyEmailUseCase.verifyExistence = { _ in
                        return Effect.publisher {
                            Just(())
                                .delay(for: .milliseconds(200), scheduler: DispatchQueue.main) // simulate latency
                                .map { _ -> Result<VerifyEmailRegistrationResponse, VerifyEmailRegistrationFailure> in
                                    .failure(.emailAlreadyRegistered)
                                }
                        }
                    }
                }
            )
        )
    }
}

#Preview("Unregistered email") {
    NavigationStack {
        EmailRegistrationPage(
            store: Store(
                initialState: .init(),
                reducer: { EmailSignUpReducer() },
                withDependencies: {
                    $0.devSettingsUseCase = mockDevSettingsUseCase()
                    $0.verifyEmailUseCase.verifyExistence = { _ in
                        return Effect.publisher {
                            Just(())
                                .delay(for: .milliseconds(200), scheduler: DispatchQueue.main) // simulate latency
                                .map { _ -> Result<VerifyEmailRegistrationResponse, VerifyEmailRegistrationFailure> in
                                    .success(.init(message: ""))
                                }
                        }
                    }
                }
            )
        )
    }
}

import AuthAPIService
import AuthAPIServiceInterface

#Preview("Custom mock") {
    NavigationStack {
        EmailRegistrationPage(
            store: Store(
                initialState: .init(),
                reducer: { EmailSignUpReducer() },
                withDependencies: {
                    $0.context = .live
                    $0.devSettingsUseCase = mockDevSettingsUseCase()
                }
            )
        )
    }
}
