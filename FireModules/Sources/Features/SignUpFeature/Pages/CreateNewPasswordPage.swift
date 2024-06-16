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

    struct ViewState: Equatable {
        @BindingViewState var password: String
        var passwordValidated: PasswordValidated
        var isFormValid: Bool
    }

    let store: StoreOf<CreateNewPasswordReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, CreateNewPasswordReducer.Action>

    public init(store: StoreOf<CreateNewPasswordReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.viewState)
    }

    public var body: some View {
        VStack(alignment: .center) {
            Spacing(height: .size24)
            Text("Tạo mật khẩu mới").typography(.titleScreen)
            Spacing(height: .size24)
            passwordInputField
            Spacer()
            actionButtons
        }
        .padding(16)
        .navigationBarHidden(true)
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
            .fireButtonStyle(type: .secondary(shape: .roundedCorner))

            Button {
                store.send(.view(.nextButtonTapped))
            } label: {
                Text("Cập nhật").frame(maxWidth: .infinity)
            }
            .fireButtonStyle(isActive: viewStore.isFormValid)
        }
    }
}

private extension BindingViewStore<CreateNewPasswordReducer.State> {
    var viewState: CreateNewPasswordPage.ViewState {
        // swiftformat:disable redundantSelf
        CreateNewPasswordPage.ViewState(
            password: self.$passwordText,
            passwordValidated: self.passwordValidated,
            isFormValid: self.password.isValid
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview("Mock API") {
    NavigationStack {
        CreateNewPasswordPage(
            store: Store(
                initialState: .init(email: Email("dev@mouka.com")),
                reducer: { CreateNewPasswordReducer() },
                withDependencies: {
                    $0.context = .live
                }
            )
        )
    }
}
