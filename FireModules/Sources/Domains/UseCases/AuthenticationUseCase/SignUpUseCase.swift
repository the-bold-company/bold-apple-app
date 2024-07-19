import ComposableArchitecture

public struct SignUpUseCase: Sendable {
    public var signUp: @Sendable (_ request: SignUpInput) -> Effect<SignUpOutput>
}
