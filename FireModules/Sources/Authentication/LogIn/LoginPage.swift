import Combine
import CoreUI
import Home
import SwiftUI

public struct LoginPage: View {
    @Environment(\.dismiss) private var dismiss
    @ObserveInjection private var iO

    @StateObject private var viewModel = LoginViewModel()

    @State private var isLoading = false
    @State private var isAuthenticated = false
    @State private var errorMessage: String?

    public init() {}

    public var body: some View {
        NavigationView {
            LoadingOverlay(loading: isLoading) {
                VStack(alignment: .leading) {
                    closeButton
                    Spacing(height: .size40)
                    Text("Log in").typography(.titleScreen)
                    Spacing(height: .size32)
                    inputFields
                    Spacing(height: .size24)
                    loginButton
                    errorText
                    Spacer()

                    NavigationLink(destination: HomePage(), isActive: $isAuthenticated, label: {
                        EmptyView()
                    })
                }
                .padding()
            }
            .onChange(of: viewModel.logInState) { newState in
                switch newState {
                case .pristine:
                    errorMessage = nil
                    isLoading = false
                case .loading:
                    isLoading = true
                    errorMessage = nil
                case let .loaded(res):
                    switch res {
                    case .success:
                        isAuthenticated = true
                    case let .failure(err):
                        isAuthenticated = false
                        errorMessage = err.errorDescription
                    }
                    isLoading = false
                }
            }
        }
        .navigationBarHidden(true)
        .enableInjection()
    }

    @ViewBuilder
    private var closeButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark")
                .foregroundColor(Color.coreui.forestGreen)
                .padding(.all(10))
                .background(Color.coreui.forestGreen.opacity(0.14))
                .clipShape(Circle())
        }
    }

    @ViewBuilder
    private var inputFields: some View {
        FireTextField(
            title: "Your email",
            text: $viewModel.email
        )

        Spacing(height: .size16)

        FireSecureTextField(
            title: "Your password",
            text: $viewModel.password
        )
    }

    @ViewBuilder
    private var loginButton: some View {
        Button {
            viewModel.onLoginButtonTapped()
        } label: {
            Text("Log in")
                .frame(maxWidth: .infinity)
        }
        .fireButtonStyle()
        .disabled(!viewModel.isFormValid)
    }

    @ViewBuilder
    private var errorText: some View {
        Spacing(height: .size8)
        Text(errorMessage ?? "").typography(.titleScreen)
    }
}
