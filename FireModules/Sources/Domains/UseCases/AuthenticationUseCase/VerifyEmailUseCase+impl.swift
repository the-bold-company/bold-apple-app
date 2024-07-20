import AuthAPIServiceInterface
import ComposableArchitecture

public extension VerifyEmailUseCase {
    static func live() -> Self { common }
    static func test() -> Self { common }
    static func preview() -> Self { common }

    static var common: Self {
        @Dependency(\.authAPIService) var authAPIService
        return VerifyEmailUseCase(
            verifyExistence: { request in
                authAPIService.verifyEmailExistence(request.email)
                    .mapResult(
                        success: { response in
                            if response.isExisted {
                                return VerifyEmailOutput.failure(.emailAlreadyRegistered)
                            } else {
                                return VerifyEmailOutput.success(.init())
                            }

                        },
                        failure: { VerifyEmailOutput.failure(.genericError($0)) }
                    )
            }
        )
    }
}
