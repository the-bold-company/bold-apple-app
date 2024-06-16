import ComposableArchitecture

public typealias ForgotPasswordOutput = Effect<Result<ForgotPasswordResponse, ForgotPasswordFailure>>

public struct ForgotPasswordUseCase: Sendable {
    public var forgotPassword: @Sendable (_ request: ForgotPasswordRequest) -> ForgotPasswordOutput
}

public extension ForgotPasswordUseCase {
    static let noop = Self(
        forgotPassword: { _ in fatalError() }
    )
}
