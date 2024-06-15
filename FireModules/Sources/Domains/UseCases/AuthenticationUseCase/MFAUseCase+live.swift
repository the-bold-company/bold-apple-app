import AuthAPIServiceInterface
import ComposableArchitecture

public extension MFAUseCase {
    static var live: Self {
        @Dependency(\.authAPIService) var authAPIService
        return MFAUseCase(
            verifyOTP: { request in
                authAPIService.confirmOTP(request.email, request.code)
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
