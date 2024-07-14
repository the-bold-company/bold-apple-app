#if os(macOS)
import AuthenticationUseCase
import Combine
import ComposableArchitecture
import CoreUI
import SwiftUI

public struct LoginPage: View {
    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case email
        case password
    }

    struct ViewState: Equatable {
        @BindingViewState var email: String
        @BindingViewState var password: String
        var isFormValid: Bool
        var emailValidationError: String?
        var passwordValidationError: String?
        var serverError: String?
        var isLoading: Bool
    }

    let store: StoreOf<LogInFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, LogInFeature.Action>

    @State private var text = ""

    public init(store: StoreOf<LogInFeature>) {
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
//                inputFields
                MOTPField(text: $text)
                Text("Count: \(text.count)")
                TextField("", text: $text)
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(hex: 0xB7F2C0))
        .navigationDestination(
            store: store.scope(
                state: \.$destination.forgotPassword,
                action: \._local.destination.forgotPassword
            )
        ) { ForgotPasswordPage(store: $0) }
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

            Button {
                store.send(.view(.forgotPasswordButtonTapped))
            } label: {
                Text("Quên mật khẩu?")
            }
            .moukaButtonStyle(.tertiary)
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
        .moukaButtonStyle(.primary, disabled: !viewStore.isFormValid)
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
//            store.send(.view(.signUpButtonTapped))
        }
    }
}

extension BindingViewStore<LogInFeature.State> {
    var viewState: LoginPage.ViewState {
        // swiftformat:disable redundantSelf
        LoginPage.ViewState(
            email: self.$emailText,
            password: self.$passwordText,
            isFormValid: self.emailValidated.is(\.valid) && self.passwordValidated.is(\.valid),
            emailValidationError: self.emailValidated.userFriendlyError,
            passwordValidationError: self.passwordValidated.userFriendlyError,
            serverError: self.serverError,
            isLoading: self.logInProgress.is(\.loading)
        )
        // swiftformat:enable redundantSelf
    }
}
#endif

public struct MOTPField: View {
    @Binding private var text: String
    @FocusState private var focusedField: FocusedField?
    @ObserveInjection var iO

    @State private var val = ""

    public init(
        text: Binding<String>
    ) {
        self._text = text
    }

    enum FocusedField: Hashable {
        case zero
        case one
        case two
        case three
        case four
        case five
    }

    public var body: some View {
        HStack(spacing: 12) {
            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 0 {
                            let index = text.index(text.startIndex, offsetBy: 0)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
                        if text.count == 0 {
                            text = value
                            focusedField = .one
                        }
                        print("zero: \(value)")
//                        else if text.count == 1 {
//                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 1)..<text.endIndex, with: value)
//                            focusedField = .one
//                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .zero
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: val,
                text: Binding(
                    get: {
                        if text.count > 1 {
                            let index = text.index(text.startIndex, offsetBy: 1)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
                        print("one: \(value)")
                        if text.count == 1 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 1) ..< text.endIndex, with: value)
//                            focusedField = value.isEmpty ? .zero : .two
//                            if !value.isEmpty {
//                                focusedField = .two
//                            }
                        } else if text.count == 2 {
                            focusedField = value.isEmpty ? .zero : .two
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .one
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 2 {
                            let index = text.index(text.startIndex, offsetBy: 2)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
//                        print("two: \(value)")
                        if text.count == 2 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 2) ..< text.endIndex, with: value)
                            if !value.isEmpty {
                                focusedField = .three
                            }
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .two
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 3 {
                            let index = text.index(text.startIndex, offsetBy: 3)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in

//                        print("three: \(value)")

                        if text.count == 3 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 3) ..< text.endIndex, with: value)
                            if !value.isEmpty {
                                focusedField = .four
                            }
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .three
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 4 {
                            let index = text.index(text.startIndex, offsetBy: 4)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
//                        print("four: \(value)")
                        if text.count == 4 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 4) ..< text.endIndex, with: value)
                            if !value.isEmpty {
                                focusedField = .five
                            }
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .four
            )
            .frame(width: 48, height: 62)

            MoukaOTPTextField(
                title: "",
                text: Binding(
                    get: {
                        if text.count > 5 {
                            let index = text.index(text.startIndex, offsetBy: 5)
                            return String(text[index])
                        } else {
                            return ""
                        }
                    },
                    set: { value in
//                        print("five: \(value)")
                        if text.count == 5 {
                            text = text.replacingCharacters(in: text.index(text.startIndex, offsetBy: 5) ..< text.endIndex, with: value)
//                            if !value.isEmpty {
//                                focusedField = .six
//                            }
                        }
                    }
                ),
                focusedField: $focusedField,
                fieldId: .five
            )
            .frame(width: 48, height: 62)
        }
        .frame(height: 62)
        .enableInjection()
    }
}

private struct Wrapper: View {
    enum Field: Hashable {
        case one
        case password
        case username
    }

    @FocusState var focusedField: Field?

    @State var text: String = ""

    var body: some View {
        VStack {
            MoukaOTPTextField(
                "",
                title: "Email",
                text: $text,
                focusedField: $focusedField,
                fieldId: .one
            )

//            .focused($focusedField, equals: .one)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        LoginPage(
            store: Store(
                initialState: .init(),
                reducer: { LogInFeature() }
            )
        )
        .preferredColorScheme(.light)
    }
}
