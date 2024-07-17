import AuthAPIServiceInterface
import ComposableArchitecture

public extension MFAUseCase {
    static func live() -> Self {
        MFAUseCase(
            validateMFA: common.validateMFA
        )
    }

    static func preview() -> Self {
        MFAUseCase(
            validateMFA: common.validateMFA
        )
    }

    static func test() -> Self {
        MFAUseCase(
            validateMFA: common.validateMFA
        )
    }

    private static var common: Self {
        @Dependency(\.authAPIService) var authAPIService

        return MFAUseCase(
            validateMFA: { input in
                if let (email, otp) = input[case: \.signUpOTP] {
                    guard email.isValid, otp.isValid else {
                        return Effect.send(.failure(.inputInvalid(input)))
                    }

                    return authAPIService.confirmOTP(email.getOrCrash(), otp.getOrCrash())
                        .mapToUseCaseLogic(
                            success: { _ in MFAResponse() },
                            failure: { MFAFailure(domainError: $0) }
                        )
                } else if let (email, password, otp) = input[case: \.resetPasswordOTP] {
                    guard email.isValid, password.isValid, otp.isValid else {
                        return Effect.send(.failure(.inputInvalid(input)))
                    }

                    return authAPIService.confirmOTPForgotPassword(email.getOrCrash(), password.getOrCrash(), otp.getOrCrash())
                        .mapToUseCaseLogic(
                            success: { _ in MFAResponse() },
                            failure: { MFAFailure(domainError: $0) }
                        )
                } else {
                    // This is just to satisfy the compiler. This shouldn't be executed
                    return Effect.send(.failure(.genericError(.custom(description: "Something's wrong"))))
                }
            }
        )
    }
}
