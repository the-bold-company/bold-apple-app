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
                resendCountdown()
                Spacer()
                actionButtons
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

    @ViewBuilder private var actionButtons: some View {
        HStack(spacing: 16) {
            Button {
//                store.send(.view(.backButtonTapped))
            } label: {
                Text("Trở về").frame(maxWidth: .infinity)
            }
            .fireButtonStyle(type: .secondary(shape: .roundedCorner))

            Button {
                //
            } label: {
                Text("Cập nhật").frame(maxWidth: .infinity)
            }
            .fireButtonStyle(isActive: viewStore.isOTPValid)
        }
    }
}

extension BindingViewStore<ConfirmationCodeReducer.State> {
    var viewState: ConfirmationCodePage.ViewState {
        // swiftformat:disable redundantSelf
        ConfirmationCodePage.ViewState(
            otp: self.$otpText,
            otpVerifyingProgress: self.otpVerifying,
            isOTPValid: self.otp.isValid
        )
        // swiftformat:enable redundantSelf
    }
}

#Preview {
    ConfirmationCodePage(
        store: .init(
            initialState: .init(email: Email("dev@mouka.ai")),
            reducer: { ConfirmationCodeReducer()._printChanges() },
            withDependencies: {
                $0.mfaUseCase.verifyOTP = { _ in
//                    let mockURL = URL.local.appendingPathComponent("mock/sign-up/sign_up_successful.json")
//                    let mock = try! Data(contentsOf: mockURL)

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
