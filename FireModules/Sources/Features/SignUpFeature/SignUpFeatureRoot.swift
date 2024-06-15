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
                    CaseLet(
                        /Destination.State.logIn,
                        action: Destination.Action.logIn,
                        then: LoginPage.init(store:)
                    )
                case .forgotPassword:
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: Previews

import AuthenticationUseCase
import Combine
import DevSettingsUseCase
import Networking
import Utilities

#Preview {
    SignUpFeatureRoot(
        store: .init(
            initialState: .init(routes: [Route.root(.signUp(.init()), embedInNavigationView: true)]),
            reducer: { SignUpFeatureCoordinator() },
            withDependencies: {
                $0.devSettingsUseCase = mockDevSettingsUseCase()
                $0.signUpUseCase = mockSignUpUseCase()
                $0.mfaUseCase = mockMFAUseCase()
                $0.verifyEmailUseCase = mockVerifyingEmailUseCase()
            }
        )
    )
}

#Preview("Custom dependencies") {
    SignUpFeatureRoot(
        store: .init(
            initialState: .init(routes: [Route.root(.signUp(.init()), embedInNavigationView: true)]),
            reducer: {
                SignUpFeatureCoordinator()
            },
            withDependencies: {
                $0.context = .live
                $0.devSettingsUseCase = mockDevSettingsUseCase()
            }
        )
    )
}

// MARK: Helpers

func mockMFAUseCase() -> MFAUseCase {
    var mock = MFAUseCase.noop
    mock.verifyOTP = { _ in
        return Effect.publisher {
            Just("")
                .delay(for: .milliseconds(200), scheduler: DispatchQueue.main)
                .map { _ in
                    Result<OTPResponse, OTPFailure>.success(.init())
                }
        }
    }
    return mock
}

func mockSignUpUseCase() -> SignUpUseCase {
    var mock = SignUpUseCase.noop
    mock.signUp = { _ in
        let mockURL = URL.local(backward: 6).appendingPathComponent("mock/auth/sign-up/response.json")
        let mock = try! Data(contentsOf: mockURL)

        return Effect.publisher {
            Just(mock)
                .delay(for: .milliseconds(200), scheduler: DispatchQueue.main) // simulate latency
                .map { try! $0.decoded() as API.v1.Response<EmptyDataResponse> }
                .map { _ in
                    Result<SignUpResponse, SignUpFailure>.success(.init())
                }
        }
    }
    return mock
}

func mockVerifyingEmailUseCase() -> VerifyEmailUseCase {
    var mock = VerifyEmailUseCase.noop
    mock.verifyExistence = { _ in
        let mockURL = URL.local(backward: 6).appendingPathComponent("mock/auth/check-email/response.json")
        let mock = try! Data(contentsOf: mockURL)

        return Effect.publisher {
            Just(mock)
                .delay(for: .milliseconds(200), scheduler: DispatchQueue.main) // simulate latency
                .map { try! $0.decoded() as API.v1.Response<String> }
                .map { res in
                    Result<VerifyEmailRegistrationResponse, VerifyEmailRegistrationFailure>.success(.init(message: res.message))
                }
        }
    }
    return mock
}

func mockDevSettingsUseCase() -> DevSettingsUseCase {
    var mockSettings = DevSettings()
    mockSettings.credentials.username = "hien2@yopmail.com"
    mockSettings.credentials.password = "Qwerty@123"
    return DevSettingsUseCase.mock(initialDevSettings: mockSettings)
}
