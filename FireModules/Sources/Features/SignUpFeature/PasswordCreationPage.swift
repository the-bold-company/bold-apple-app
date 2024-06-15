//
//  PasswordCreationPage.swift
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

public struct PasswordCreationPage: View {
    @ObserveInjection var iO

    struct ViewState: Equatable {
        @BindingViewState var password: String
        var passwordValidated: PasswordValidated
        var signUpProgress: SignUpProgress
        var isFormValid: Bool
    }

    let store: StoreOf<PasswordSignUpReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, PasswordSignUpReducer.Action>

    public init(store: StoreOf<PasswordSignUpReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.passwordCreationViewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.signUpProgress.isLoading) {
            VStack(alignment: .center) {
                Spacing(height: .size24)
                Text("Tạo mật khẩu").typography(.titleScreen)
                Spacing(height: .size24)
                passwordInputField
                Spacer()
                actionButtons
            }
            .padding(16)
            .navigationBarHidden(true)
        }
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

private extension BindingViewStore<PasswordSignUpReducer.State> {
    var passwordCreationViewState: PasswordCreationPage.ViewState {
        // swiftformat:disable redundantSelf
        PasswordCreationPage.ViewState(
            password: self.$passwordText,
            passwordValidated: self.passwordValidated,
            signUpProgress: self.signUpProgress,
            isFormValid: self.password.isValid
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    NavigationStack {
        PasswordCreationPage(
            store: Store(
                initialState: .init(email: Email("dev@mouka.com")),
                reducer: { PasswordSignUpReducer() },
                withDependencies: {
                    $0.signUpUseCase.signUp = { _ in
                        let mockURL = URL.local(backward: 6).appendingPathComponent("mock/auth/sign-up/response.json")
                        let mock = try! Data(contentsOf: mockURL)

                        return Effect.publisher {
                            Just(mock)
                                .delay(for: .milliseconds(200), scheduler: DispatchQueue.main) // simulate latency
                                .map { try! $0.decoded() as API.v1.Response<EmptyDataResponse> }
                                .map { _ in
                                    Result<AuthenticationLogic.SignUp.Response, AuthenticationLogic.SignUp.Failure>.success(.init())
                                }
                        }
                    }

                    $0.devSettingsUseCase = mockDevSettingsUseCase()
                }
            )
        )
    }
}
