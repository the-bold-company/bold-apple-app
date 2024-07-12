import AuthAPIServiceInterface
import ComposableArchitecture

public extension ForgotPasswordUseCase {
    static func live() -> Self {
        @Dependency(\.authAPIService) var authAPIService
        return ForgotPasswordUseCase(
            forgotPassword: { request in
                let emailValidationError = request.email.getErrorOrNil()

                if let emailValidationError {
                    return Effect.send(.failure(.emailInvalid(emailValidationError)))
                }

                return authAPIService.forgotPassword(request.email.getOrCrash())
                    .mapToUseCaseLogic(
                        success: { AuthenticationLogic.ForgotPassword.Response(message: $0.message) },
                        failure: { AuthenticationLogic.ForgotPassword.Failure(domainError: $0) }
                    )
            }
        )
    }
}
