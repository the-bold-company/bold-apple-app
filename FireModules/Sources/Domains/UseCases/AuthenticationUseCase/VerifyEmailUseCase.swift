import ComposableArchitecture

public typealias VerifyEmailRegistrationOutput = Effect<Result<VerifyEmailRegistrationResponse, VerifyEmailRegistrationFailure>>

public struct VerifyEmailUseCase: Sendable {
    public var verifyExistence: @Sendable (_ request: VerifyEmailRegistrationRequest) -> VerifyEmailRegistrationOutput
}

public extension VerifyEmailUseCase {
    static var noop: Self {
        .init(
            verifyExistence: { _ in fatalError() }
        )
    }
}
