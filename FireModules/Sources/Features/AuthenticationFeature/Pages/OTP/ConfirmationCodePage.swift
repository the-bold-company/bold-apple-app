#if os(macOS)
import AuthenticationUseCase
import Combine
import ComposableArchitecture
import CoreUI
import DomainEntities
import Foundation
import SwiftUI

public struct ConfirmationCodePage: View {
    @ObserveInjection var iO

    struct ViewState: Equatable {
        @BindingViewState var otp: String
        var email: String
        var isLoading: Bool
        var userFriendlyError: String?
    }

    private let store: StoreOf<ConfirmationCodeReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, ConfirmationCodeReducer.Action>

    public init(store: StoreOf<ConfirmationCodeReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.viewState)
    }

    public var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("Xác nhận email").typography(.titleScreen)
                Spacing(height: .size12)
                instruction
                Spacing(size: .size40)
                otpInput
                Spacing(size: .size40)
                if viewStore.isLoading {
                    ProgressView()
                } else {
                    resendCountdown
                }
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
        .enableInjection()
    }

    @ViewBuilder private var instruction: some View {
        Text("Điền vào ô sau dãy số Mouka vừa gửi bạn qua email ")
            .typography(.bodyLarge)
            .foregroundColor(Color.coreui.forestGreen)
            + Text(viewStore.email)
            .typography(.bodyLargeBold)
            + Text(". ").font(.system(size: 16))
            + Text("Thay đổi")
            .typography(.bodyLargeBold)
            .foregroundColor(Color.coreui.matureGreen)
    }

    @ViewBuilder private var otpInput: some View {
        MoukaOTPField(
            text: viewStore.$otp,
            error: viewStore.userFriendlyError,
            onCommit: { viewStore.send(.view(.verifyOTP)) }
        )
        .disabled(viewStore.isLoading)
    }

    @ViewBuilder private var resendCountdown: some View {
//        Text("Gửi lại sau ")
//            .font(.system(size: 16))
//            .foregroundColor(Color(uiColor: .lightGray))
//            +
//            Text(verbatim: "60s")
//                .font(.system(size: 16))
//                .bold()

        Text("Bạn không nhận được? ")
            .font(.system(size: 16))
            + Text("Gửi lại")
            .font(.system(size: 16))
            .foregroundColor(Color.coreui.matureGreen)
            .bold()
    }
}

extension BindingViewStore<ConfirmationCodeReducer.State> {
    var viewState: ConfirmationCodePage.ViewState {
        // swiftformat:disable redundantSelf
        ConfirmationCodePage.ViewState(
            otp: self.$otpText,
            email: self.challenge[case: \.signUpOTP]?.getOrNil()
                ?? self.challenge[case: \.resetPasswordOTP]?.0.getOrNil()
                ?? "",
            isLoading: self.otpVerifying.is(\.loading),
            userFriendlyError: self.otpVerifying[case: \.loaded.failure]?.userFriendlyError
        )
        // swiftformat:enable redundantSelf
    }
}

import AuthAPIService

#Preview("Sign up") {
    ConfirmationCodePage(
        store: .init(
            initialState: .init(challenge: .signUpOTP(Email("dev@mouka.ai"))),
            reducer: { ConfirmationCodeReducer() },
            withDependencies: {
                $0.authAPIService = .directMock(confirmSignUpOTPMock: """
                {
                  "message": "Invalid confirmation code",
                  "code": 14001
                }
                """)
            }
        )
    )
    .preferredColorScheme(.light)
}

#Preview("Reset password") {
    ConfirmationCodePage(
        store: .init(
            initialState: .init(challenge: .resetPasswordOTP(Email("dev@mouka.ai"), Password("Qwerty@123"))),
            reducer: { ConfirmationCodeReducer() },
            withDependencies: {
                $0.authAPIService = .directMock(confirmForgotPasswordOTPMock: """
                {
                  "message": "Execute successfully"
                }
                """)
            }
        )
    )
    .preferredColorScheme(.light)
}
#endif
