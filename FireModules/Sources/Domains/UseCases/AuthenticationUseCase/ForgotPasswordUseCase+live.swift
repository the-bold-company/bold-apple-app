import AuthAPIServiceInterface
import ComposableArchitecture

public extension ForgotPasswordUseCase {
    static func live() -> Self {
        @Dependency(\.authAPIService) var authAPIService
        return ForgotPasswordUseCase(
            forgotPassword: { request in
                authAPIService.forgotPassword(request.email)
                    .mapToUseCaseLogic(
                        success: { AuthenticationLogic.ForgotPassword.Response(message: $0.message) },
                        failure: { AuthenticationLogic.ForgotPassword.Failure(domainError: $0) }
                    )
            }
        )
    }
}
