import AuthenticationUseCase
import ComposableArchitecture
import CoreUI
import DomainEntities
import SwiftUI

public struct ForgotPasswordPage: View {
    @ObserveInjection private var iO

    struct ViewState: Equatable {
        @BindingViewState var email: String
        var isLoading: Bool
        var emailValidationError: String?
        var userFriendlyError: String?
    }

    let store: StoreOf<ForgotPasswordReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, ForgotPasswordReducer.Action>

    public init(store: StoreOf<ForgotPasswordReducer>) {
        self.store = store
        self.viewStore = ViewStore(store, observe: \.viewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.isLoading) {
            NavigationStack {
                VStack(alignment: .center) {
                    Spacing(height: .size24)
                    Text("Đổi mật khẩu").typography(.titleScreen)
                    Spacing(height: .size12)
                    Text("Nhập tài khoản email bạn muốn đổi mật khẩu").typography(.bodyLarge)
                    Spacing(height: .size24)
                    serverErrorToast
                    emailInputField
                    Spacer()
                    actionButtons
                }
                .padding(16)
                .toolbar(.hidden)
                .navigationDestination(
                    store: store.scope(
                        state: \.$destination.createNewPassword,
                        action: \.destination.createNewPassword
                    )
                ) { CreateNewPasswordPage(store: $0) }
            }
            .hideNavigationBar()
            .toolbar(.hidden)
        }
        .enableInjection()
    }

    @ViewBuilder private var emailInputField: some View {
        FireTextField(
            title: "Email",
            text: viewStore.$email
        )
        #if os(iOS)
        .autocapitalization(.none)
        .keyboardType(.emailAddress)
        #endif
        .autocorrectionDisabled()
        Group {
            Spacing(size: .size12)
            Text(viewStore.emailValidationError ?? "")
                .typography(.bodyDefault)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .isHidden(hidden: viewStore.emailValidationError == nil)
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
            .fireButtonStyle(type: .secondary(shape: .roundedCorner))

            Button {
                store.send(.view(.nextButtonTapped))
            } label: {
                Text("Tiếp theo").frame(maxWidth: .infinity)
            }
            .fireButtonStyle()
        }
    }
}

extension BindingViewStore<ForgotPasswordReducer.State> {
    var viewState: ForgotPasswordPage.ViewState {
        // swiftformat:disable redundantSelf
        ForgotPasswordPage.ViewState(
            email: self.$emailText,
            isLoading: self.forgotPasswordConfirmProgress.is(\.loading),
            emailValidationError: self.emailValidationError,
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
                reducer: { ForgotPasswordReducer() },
                withDependencies: {
                    $0.context = .live
                }
            )
        )
    }
}
