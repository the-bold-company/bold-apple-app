import ComposableArchitecture

public typealias LoginUseCaseInput = AuthenticationLogic.LogIn.Request
public typealias LoginUseCaseOutput = Result<AuthenticationLogic.LogIn.Response, AuthenticationLogic.LogIn.Failure>

public struct LogInUseCase: Sendable {
    public var logInAsync: @Sendable (_ request: LoginUseCaseInput) async -> LoginUseCaseOutput
    public var logIn: @Sendable (_ request: LoginUseCaseInput) -> Effect<LoginUseCaseOutput>
}

public extension LogInUseCase {
    static var test: Self {
        .init(
            logInAsync: { _ in fatalError() },
            logIn: { _ in fatalError() }
        )
    }
}
