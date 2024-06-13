import ComposableArchitecture

public typealias SignUpUseCaseOutput = Result<SignUpResponse, SignUpFailure>

public struct SignUpUseCase: Sendable {
    public var signUp: @Sendable (_ request: SignUpRequest) -> Effect<SignUpUseCaseOutput>
}

public extension SignUpUseCase {
    static var noop: Self {
        .init(
            signUp: { _ in fatalError() }
        )
    }
}
