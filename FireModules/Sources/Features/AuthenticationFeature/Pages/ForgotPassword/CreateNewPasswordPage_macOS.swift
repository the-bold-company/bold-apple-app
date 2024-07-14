#if os(macOS)
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

public struct CreateNewPasswordPage: View {
    @ObserveInjection var iO
    @FocusState private var focusedField: FocusedField?

    enum FocusedField: Hashable {
        case newPassword
    }

    struct ViewState: Equatable {
        @BindingViewState var password: String
        var passwordValidated: PasswordValidated
        var isFormValid: Bool
    }

    let store: StoreOf<CreateNewPasswordFeature>
    @ObservedObject var viewStore: ViewStore<ViewState, CreateNewPasswordFeature.Action>

    public init(store: StoreOf<CreateNewPasswordFeature>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.viewState)
    }

    public var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Tạo mật khẩu mới").typography(.titleScreen)
                Spacing(height: .size24)
                passwordInputField
                Spacing(height: .size40)
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
                state: \.$destination.otp,
                action: \._local.destination.otp
            )
        ) { ConfirmationCodePage(store: $0) }
        .enableInjection()
    }

    @ViewBuilder private var passwordInputField: some View {
        MoukaSecureTextField(
            "Nhập mật khẩu ",
            title: "Mật khẩu",
            text: viewStore.$password,
            focusedField: $focusedField,
            fieldId: .newPassword
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
            Button {
                store.send(.view(.backButtonTapped))
            } label: {
                Text("Trở về").frame(maxWidth: .infinity)
            }
            .moukaButtonStyle(.secondary)

            Button {
                store.send(.view(.nextButtonTapped))
            } label: {
                Text("Cập nhật").frame(maxWidth: .infinity)
            }
            .moukaButtonStyle(disabled: !viewStore.isFormValid)
        }
    }
}

private extension BindingViewStore<CreateNewPasswordFeature.State> {
    var viewState: CreateNewPasswordPage.ViewState {
        // swiftformat:disable redundantSelf
        CreateNewPasswordPage.ViewState(
            password: self.$passwordText,
            passwordValidated: self.password.validateAll(),
            isFormValid: self.password.isValid
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    NavigationStack {
        CreateNewPasswordPage(
            store: Store(
                initialState: .init(email: Email("dev@mouka.com")),
                reducer: { CreateNewPasswordFeature() },
                withDependencies: {
                    $0.context = .live
                }
            )
        )
        .preferredColorScheme(.light)
    }
}
#endif
