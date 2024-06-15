import AuthAPIServiceInterface
import ComposableArchitecture

public extension SignUpUseCase {
    static func live() -> Self {
        @Dependency(\.authAPIService) var authAPIService
        return SignUpUseCase(
            signUp: { request in
                authAPIService.signUp(request.email, request.password)
                    .mapToUseCaseLogic(
                        success: { _ in
                            SignUpResponse()
                        },
                        failure: {
                            SignUpFailure.genericError($0.eraseToDomainError())
                        }
                    )
            }
        )
    }
}
