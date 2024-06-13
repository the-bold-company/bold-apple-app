import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct SignUpFeatureRoot: View {
    let store: StoreOf<SignUpFeatureCoordinator>

    public init(store: StoreOf<SignUpFeatureCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.self, action: \._local)) { screen in
            SwitchStore(screen) { screen in
                switch screen {
                case .signUp:
                    CaseLet(
                        /Destination.State.signUp,
                        action: Destination.Action.signUp,
                        then: EmailRegistrationPage.init(store:)
                    )
                case .otp:
                    CaseLet(
                        /Destination.State.otp,
                        action: Destination.Action.otp,
                        then: ConfirmationCodePage.init(store:)
                    )
                case .logIn:
                    EmptyView()
                case .forgotPassword:
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

import AuthenticationUseCase
import Combine
import Networking
import Utilities

#Preview {
    SignUpFeatureRoot(
        store: .init(
            initialState: .init(routes: [Route.root(.signUp(.init()), embedInNavigationView: true)]),
            reducer: {
                SignUpFeatureCoordinator()
                    .dependency(\.signUpUseCase, mockSignUpUseCase())
                    .dependency(\.mfaUseCase, mockMFAUseCase())
            }
        )
    )
}

private func mockMFAUseCase() -> MFAUseCase {
    var mock = MFAUseCase.noop
    mock.verifyOTP = { _ in
        return Effect.publisher {
            Just("")
                .delay(for: .seconds(1), scheduler: DispatchQueue.main)
                .map { _ in
                    Result<OTPResponse, OTPFailure>.success(.init())
                }
        }
    }
    return mock
}

private func mockSignUpUseCase() -> SignUpUseCase {
    var mock = SignUpUseCase.noop
    mock.signUp = { _ in
        let mockURL = URL.local(backward: 6).appendingPathComponent("mock/sign-up/sign_up_successful.json")
        let mock = try! Data(contentsOf: mockURL)

        return Effect.publisher {
            Just(mock)
                .delay(for: .seconds(1), scheduler: DispatchQueue.main) // simulate latency
                .map { try! $0.decoded() as API.v1.Response<EmptyDataResponse> }
                .map { _ in
                    Result<SignUpResponse, SignUpFailure>.success(.init())
                }
        }
    }
    return mock
}
