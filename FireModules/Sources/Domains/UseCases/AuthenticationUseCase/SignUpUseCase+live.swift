import AuthAPIServiceInterface
import ComposableArchitecture

public extension SignUpUseCase {
    static var live: Self {
        @Dependency(\.authAPIService) var authAPIService
        return SignUpUseCase(
            signUp: { request in
                authAPIService.signUp(request.email, request.password)
                    .mapResult(
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
