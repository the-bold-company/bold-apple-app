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
        var otpVerifyingProgress: LoadingProgress<Confirmed, OTPFailure>
        var isOTPValid: Bool
        var errorText: String?
    }

    private let store: StoreOf<ConfirmationCodeReducer>
    @ObservedObject var viewStore: ViewStore<ViewState, ConfirmationCodeReducer.Action>

    public init(store: StoreOf<ConfirmationCodeReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: \.viewState)
    }

    public var body: some View {
        LoadingOverlay(loading: viewStore.otpVerifyingProgress.isLoading) {
            VStack(alignment: .center) {
                Spacing(height: .size24)
                Text("Xác nhận email").typography(.titleScreen)
                Spacing(height: .size12)
                Text("Điền vào ô sau dãy số Boldpanel vừa gửi bạn qua email ")
                    .font(.system(size: 16))
                    .foregroundColor(Color.coreui.forestGreen)
                    +
                    Text(verbatim: "nhiytran.ad@gmai.com")
                    .font(.system(size: 16))
                    .bold()
                    + Text(". ").font(.system(size: 16))
                    + Text("Thay đổi")
                    .font(.system(size: 16))
                    .foregroundColor(Color.coreui.brightGreen)
                    .bold()
                otpInput
                errorMessage
                Spacing(size: .size40)
                resendCountdown()
                Spacer()
            }
            .padding(16)
            .navigationBarHidden(true)
        }
        .enableInjection()
    }

    @ViewBuilder private var otpInput: some View {
        FireOTPField(
            text: viewStore.$otp,
            slotsCount: 6
        )
    }

    @ViewBuilder private var errorMessage: some View {
        Group {
            Spacing(size: .size12)
            Text(viewStore.errorText ?? "")
                .typography(.bodyDefault)
                .foregroundColor(.red)
        }
        .isHidden(hidden: viewStore.errorText == nil)
    }

    @ViewBuilder private func resendCountdown() -> some View {
//        Text("Gửi lại sau ")
//            .font(.system(size: 16))
//            .foregroundColor(Color(uiColor: .lightGray))
//            +
//            Text(verbatim: "60s")
//                .font(.system(size: 16))
//                .bold()

        Text("Bạn không nhận được? ")
            .font(.system(size: 16))
            .foregroundColor(Color(uiColor: .lightGray))
            + Text("Gửi lại")
            .font(.system(size: 16))
            .foregroundColor(Color.coreui.brightGreen)
            .bold()
    }
}

extension BindingViewStore<ConfirmationCodeReducer.State> {
    var viewState: ConfirmationCodePage.ViewState {
        // swiftformat:disable redundantSelf
        ConfirmationCodePage.ViewState(
            otp: self.$otpText,
            otpVerifyingProgress: self.otpVerifying,
            isOTPValid: self.otp.isValid,
            errorText: self.errorText
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview("OTP Confirmed") {
    ConfirmationCodePage(
        store: .init(
            initialState: .init(challenge: .signUpOTP(Email("dev@mouka.ai"))),
            reducer: { ConfirmationCodeReducer() },
            withDependencies: {
                $0.devSettingsUseCase = mockDevSettingsUseCase()
                $0.mfaUseCase.verifyOTP = { _ in
                    return Effect.publisher {
                        Just("")
                            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                            .map { _ in
                                Result<OTPResponse, OTPFailure>.success(.init())
                            }
                    }
                }
            }
        )
    )
}

#Preview("OTP invalid") {
    ConfirmationCodePage(
        store: .init(
            initialState: .init(challenge: .signUpOTP(Email("dev@mouka.ai"))),
            reducer: { ConfirmationCodeReducer() },
            withDependencies: {
                $0.devSettingsUseCase = mockDevSettingsUseCase()
                $0.mfaUseCase.verifyOTP = { _ in
                    return Effect.publisher {
                        Just("")
                            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                            .map { _ in
                                Result<OTPResponse, OTPFailure>.failure(.codeMismatch(DomainError.custom(description: "OTP mismatch")))
                            }
                    }
                }
            }
        )
    )
}

#Preview("Custom mock") {
    ConfirmationCodePage(
        store: .init(
            initialState: .init(challenge: .resetPasswordOTP(Email("dev@mouka.ai"), Password("Qwerty@123"))),
            reducer: { ConfirmationCodeReducer() },
            withDependencies: {
                $0.context = .live
                $0.devSettingsUseCase = mockDevSettingsUseCase()
            }
        )
    )
}
