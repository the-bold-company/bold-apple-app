import AuthenticationUseCase
import Combine
import ComposableArchitecture
import DevSettingsUseCase
import Foundation
import Networking
import Utilities

// MARK: Helpers

// func mockMFAUseCase() -> MFAUseCase {
//    var mock = MFAUseCase.noop
//    mock.verifyOTP = { _ in
//        return Effect.publisher {
//            Just("")
//                .delay(for: .milliseconds(200), scheduler: DispatchQueue.main)
//                .map { _ in
//                    Result<OTPResponse, OTPFailure>.success(.init())
//                }
//        }
//    }
//    return mock
// }

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
