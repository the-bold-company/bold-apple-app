import AuthAPIServiceInterface
import ComposableArchitecture
import DomainUtilities
import KeychainServiceInterface

public extension LogInUseCase {
    static func live() -> Self {
        @Dependency(\.authAPIService) var authAPIService
        return LogInUseCase(
            logInAsync: { request in
                let emailValidationError = request.email.getErrorOrNil()
                let passwordValidationError = request.password.getErrorOrNil()

                if emailValidationError != nil || passwordValidationError != nil {
                    return .failure(.invalidInputs(emailValidationError, passwordValidationError))
                }

                do {
                    let successfulLogIn = try await authAPIService.logInAsync(request.email.getOrCrash(), request.password.getOrCrash())

//                    try keychainService.setCredentials(
//                        accessToken: successfulLogIn.1.accessToken,
//                        refreshToken: successfulLogIn.1.refreshToken
//                    )
                    return .success(AuthenticationLogic.LogIn.Response(user: successfulLogIn.0))
                } catch let error as DomainError {
                    return .failure(AuthenticationLogic.LogIn.Failure(domainError: error))
                } catch {
                    return .failure(AuthenticationLogic.LogIn.Failure.genericError(error.eraseToDomainError()))
                }
            },
            logIn: { request in
                let emailValidationError = request.email.getErrorOrNil()
                let passwordValidationError = request.password.getErrorOrNil()

                if emailValidationError != nil || passwordValidationError != nil {
                    return Effect.send(.failure(.invalidInputs(emailValidationError, passwordValidationError)))
                }

                return authAPIService.logIn(request.email.getOrCrash(), request.password.getOrCrash())
                    .mapToUseCaseLogic(
                        success: { AuthenticationLogic.LogIn.Response(user: $0.0) },
                        failure: { AuthenticationLogic.LogIn.Failure(domainError: $0) },
                        actionOnSuccess: { _ in
//                            try keychainService.setCredentials(
//                                accessToken: response.1.accessToken,
//                                refreshToken: response.1.refreshToken
//                            )
                        },
                        catch: { AuthenticationLogic.LogIn.Failure(domainError: $0.eraseToDomainError()) }
                    )
            }
        )
    }
}
