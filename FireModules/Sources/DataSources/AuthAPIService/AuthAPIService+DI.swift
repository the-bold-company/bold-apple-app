import AuthAPIServiceInterface
import Dependencies
import Utilities

extension AuthAPIServiceKey: DependencyKey {
    public static let liveValue = AuthAPIService.live

    // IMportant: For mocking purpose only. Comment out this when done. Do not commit this to production
//    public static let liveValue = AuthAPIService.local(
//        logInResponseMockURL: .local(backward: 6).appendingPathComponent("mock/auth/log-in/response.json"),
//        signUpResponseMockURL: .local(backward: 6).appendingPathComponent("mock/auth/sign-up/response.json"),
//        confirmOTPMockURL: .local(backward: 6).appendingPathComponent("mock/auth/confirm-sign-up/response.json"),
//        verifyEmailExistenceMockURL: .local(backward: 6).appendingPathComponent("mock/auth/check-email/response.json")
//    )
}
