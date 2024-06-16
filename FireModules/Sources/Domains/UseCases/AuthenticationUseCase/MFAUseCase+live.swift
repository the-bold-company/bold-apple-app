import AuthAPIServiceInterface
import ComposableArchitecture

public extension MFAUseCase {
    static var live: Self {
        @Dependency(\.authAPIService) var authAPIService
        return MFAUseCase(
            verifyOTP: { request in
                guard case let .signUpOTP(email, otp) = request else { fatalError() }
                return authAPIService.confirmOTP(email, otp)
                    .mapToUseCaseLogic(
                        success: { _ in
                            OTPResponse()
                        },
                        failure: {
                            OTPFailure(domainError: $0)
                        }
                    )
            },
            confirmOTPResetPassword: { request in
                guard case let .resetPasswordOTP(email, password, otp) = request else { fatalError() }
                return authAPIService.confirmOTPForgotPassword(email, password, otp)
                    .mapToUseCaseLogic(
                        success: { _ in
                            OTPResponse()
                        },
                        failure: {
                            OTPFailure(domainError: $0)
                        }
                    )
            }
        )
    }
}
