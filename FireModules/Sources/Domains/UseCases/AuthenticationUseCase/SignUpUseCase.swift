import ComposableArchitecture

public typealias SignUpUseCaseInput = AuthenticationLogic.SignUp.Request
public typealias SignUpUseCaseOutput = Result<AuthenticationLogic.SignUp.Response, AuthenticationLogic.SignUp.Failure>

public struct SignUpUseCase: Sendable {
    public var signUp: @Sendable (_ request: SignUpUseCaseInput) -> Effect<SignUpUseCaseOutput>
}

public extension SignUpUseCase {
    static var noop: Self {
        .init(
            signUp: { _ in fatalError() }
        )
    }
}
