import ComposableArchitecture

public struct VerifyEmailUseCase: Sendable {
    public var verifyExistence: @Sendable (_ request: VerifyEmailInput) -> Effect<VerifyEmailOutput>
}
