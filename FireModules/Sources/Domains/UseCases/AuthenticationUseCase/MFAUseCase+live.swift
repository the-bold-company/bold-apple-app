import AuthAPIServiceInterface
import ComposableArchitecture

public extension MFAUseCase {
    static var live: Self {
        @Dependency(\.authAPIService) var authAPIService
        return MFAUseCase(
            verifyOTP: { request in
                authAPIService.confirmOTP(request.email, request.code)
                    .mapResult(
                        success: { _ in
                            OTPResponse()
                        },
                        failure: {
                            OTPFailure.genericError($0.eraseToDomainError())
                        }
                    )
            }
        )
    }
}
