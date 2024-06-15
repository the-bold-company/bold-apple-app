import AuthAPIServiceInterface
import ComposableArchitecture

public extension VerifyEmailUseCase {
    static var live: Self {
        @Dependency(\.authAPIService) var authAPIService
        return VerifyEmailUseCase(
            verifyExistence: { request in
                authAPIService.verifyEmailExistence(request.email)
                    .mapResult(
                        success: { _ -> Result<VerifyEmailRegistrationResponse, VerifyEmailRegistrationFailure> in
                            return .failure(.emailAlreadyRegistered)
                        },
                        failure: { error -> Result<VerifyEmailRegistrationResponse, VerifyEmailRegistrationFailure> in
                            if let code = error.errorCode, code == 14002 {
                                return .success(.init(message: error.failureReason ?? "Email does not exist in system"))
                            } else {
                                return .failure(.genericError(error))
                            }
                        }
                    )
            }
        )
    }
}
