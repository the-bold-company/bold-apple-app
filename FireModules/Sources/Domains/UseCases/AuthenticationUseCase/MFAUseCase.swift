import ComposableArchitecture

public typealias OTPUseCaseOutput = Effect<Result<OTPResponse, OTPFailure>>

public struct MFAUseCase: Sendable {
    // TODO: Merge this two in to 1 single function
    /*
     switch request {
     case let .signUpOTP(email, code):
         return authAPIService.confirmOTP(email, otp)
             .mapToUseCaseLogic(
                 success: { _ in
                     OTPResponse()
                 },
                 failure: {
                     OTPFailure(domainError: $0)
                 }
             )
     case let .resetPasswordOTP(email, password, code):
         return authAPIService.confirmOTPForgotPassword(email, password, otp)
             .mapToUseCaseLogic(
                 success: { _ in
                     OTPResponse()
                 },
                 failure: {
                     OTPFailure(domainError: $0)
                 }
             )
     }
     */
    public var verifyOTP: @Sendable (_ request: OTPRequest) -> OTPUseCaseOutput
    public var confirmOTPResetPassword: @Sendable (_ request: OTPRequest) -> OTPUseCaseOutput
}

public extension MFAUseCase {
    static var noop: Self {
        .init(
            verifyOTP: { _ in fatalError() },
            confirmOTPResetPassword: { _ in fatalError() }
        )
    }
}
