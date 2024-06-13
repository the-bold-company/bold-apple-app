import ComposableArchitecture

public typealias OTPUseCaseOutput = Effect<Result<OTPResponse, OTPFailure>>

public struct MFAUseCase: Sendable {
    public var verifyOTP: @Sendable (_ request: OTPRequest) -> OTPUseCaseOutput
}

public extension MFAUseCase {
    static var noop: Self {
        .init(
            verifyOTP: { _ in fatalError() }
        )
    }
}
