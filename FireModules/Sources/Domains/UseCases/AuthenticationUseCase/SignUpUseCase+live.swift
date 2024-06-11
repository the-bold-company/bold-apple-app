import AuthAPIServiceInterface
import ComposableArchitecture

public extension SignUpUseCase {
    static var live: Self {
        @Dependency(\.authAPIService) var authAPIService
        return SignUpUseCase(
            signUp: { request in
                authAPIService.signUp(email: request.email, password: request.password)
                    .mapResult(
                        success: { _ in
                            AuthenticationLogic.SignUp.Response()
                        },
                        failure: {
                            AuthenticationLogic.SignUp.Failure.genericError($0.eraseToDomainError())
                        }
                    )
            }
        )
    }
}
