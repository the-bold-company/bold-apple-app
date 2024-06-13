import ComposableArchitecture
import CoreUI
import SwiftUI
import SwiftUIIntrospect

public struct EmailRegistrationPage: View {
    @ObserveInjection var iO

    let store: StoreOf<EmailSignUpReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, EmailSignUpReducer.Action>

    public init(store: StoreOf<EmailSignUpReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.emailRegistrationViewState)
    }

    struct ViewState: Equatable {
        @BindingViewState var email: String
        var emailValidationError: String?
    }

    public var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                brandLogo
                Spacing(height: .size24)
                Text("Đăng ký Mouka").typography(.titleScreen)
                Spacing(height: .size24)
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
            .navigationBarHidden(true)
            .navigationDestination(
                store: store.scope(
                    state: \.$destination.password,
                    action: \.destination.password
                )
            ) { PasswordCreationPage(store: $0) }
        }
        .enableInjection()
    }

    @ViewBuilder private var brandLogo: some View {
        Image(systemName: "b.square")
            .resizable()
            .frame(width: 72, height: 72)
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

    @ViewBuilder private var nextButton: some View {
        Button {
            viewStore.send(.view(.nextButtonTapped))
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
    var emailRegistrationViewState: EmailRegistrationPage.ViewState {
        // swiftformat:disable redundantSelf
        EmailRegistrationPage.ViewState(
            email: self.$emailText,
            emailValidationError: self.emailValidationError
        )
        // swiftformat:enable redundantSelf
    }
}
