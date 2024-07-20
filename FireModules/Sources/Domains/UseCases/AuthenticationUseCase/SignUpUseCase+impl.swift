import AuthAPIServiceInterface
import ComposableArchitecture

public extension SignUpUseCase {
    static func live() -> Self { common }
    static func test() -> Self { common }
    static func preview() -> Self { common }

    private static var common: Self {
        @Dependency(\.authAPIService) var authAPIService
        return SignUpUseCase(
            signUp: { request in
                let emailValidationError = request.email.getErrorOrNil()
                let passwordValidationError = request.password.getErrorOrNil()

                if emailValidationError != nil || passwordValidationError != nil {
                    return Effect.send(.failure(.invalidInputs(request)))
                }

                return authAPIService.signUp(request.email.getOrCrash(), request.password.getOrCrash())
                    .mapToUseCaseLogic(
                        success: { _ in SignUpResponse() },
                        failure: { SignUpFailure.genericError($0.eraseToDomainError()) }
                    )
            }
        )
    }
}
