import ComposableArchitecture

public typealias ForgotPasswordOutput = Effect<Result<ForgotPasswordResponse, ForgotPasswordFailure>> // TODO: Move this to `AuthenticationLogic.swift`

public struct ForgotPasswordUseCase: Sendable {
    public var forgotPassword: @Sendable (_ request: ForgotPasswordRequest) -> ForgotPasswordOutput
}

public extension ForgotPasswordUseCase {
    static let noop = Self(
        forgotPassword: { _ in fatalError() }
    )
}
