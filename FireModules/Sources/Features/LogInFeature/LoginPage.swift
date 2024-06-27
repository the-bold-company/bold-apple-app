import ComposableArchitecture
import CoreUI
import SwiftUI
// import KZFileWatchers

public struct LoginPage: View {
    @ObserveInjection private var iO

//    private let fw = FileWatcher.Local(
//        path: URL.local
//            .appendingPathComponent("mock/login_successful_error_invalid_credentials.json")
//            .path(percentEncoded: false),
//        refreshInterval: 5/60
//    )

    struct ViewState: Equatable {
        @BindingViewState var email: String
        @BindingViewState var password: String
        var areInputsValid: Bool
        var logInError: String?
        var logInInProgress: Bool
    }

    let store: StoreOf<LoginReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, LoginReducer.Action>

    public init(store: StoreOf<LoginReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.viewState)
//        watchFileChanged()
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.logInInProgress) {
            VStack(alignment: .leading) {
                DismissButton()
                Spacing(height: .size40)
                Text("Log in").typography(.titleScreen)
                Spacing(height: .size32)
                inputFields
                Spacing(height: .size24)
                loginButton
                errorText
                Spacer()
            }
            .padding()
        }
        .hideNavigationBar()
        .enableInjection()
    }

    @ViewBuilder
    private var inputFields: some View {
        FireTextField(
            title: "Your email",
            text: viewStore.$email
        )

        Spacing(height: .size16)

        FireSecureTextField(
            title: "Your password",
            text: viewStore.$password
        )
    }

    @ViewBuilder
    private var loginButton: some View {
        Button {
            viewStore.send(.view(.logInButtonTapped))
        } label: {
            Text("Log in")
                .frame(maxWidth: .infinity)
        }
        .fireButtonStyle()
        .disabled(!viewStore.areInputsValid)
    }

    @ViewBuilder
    private var errorText: some View {
        Spacing(height: .size8)
        Text(viewStore.logInError ?? "")
            .typography(.bodyDefault)
            .foregroundColor(.coreui.sentimentNegative)
    }

//    private func watchFileChanged() {
//        try! fw.start(closure: { change in
//            switch change {
//            case .noChanges: break
//            case .updated:
//                viewStore.send(.delegate(.logInButtonTapped))
//            }
//
//        })
//    }
}

extension BindingViewStore<LoginReducer.State> {
    var viewState: LoginPage.ViewState {
        // swiftformat:disable redundantSelf
        LoginPage.ViewState(
            email: self.$email,
            password: self.$password,
            areInputsValid: self.areInputsValid,
            logInError: self.loginError,
            logInInProgress: self.logInInProgress
        )
        // swiftformat:enable redundantSelf
    }
}

// private extension URL {
//    static var local: URL {
//        var path = #file.components(separatedBy: "/")
//        path.removeLast(6)
//        let json = path.joined(separator: "/")
//        return URL(fileURLWithPath: json)
//    }
// }
