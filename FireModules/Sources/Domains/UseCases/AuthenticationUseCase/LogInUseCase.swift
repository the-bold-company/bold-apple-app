import ComposableArchitecture

public typealias LoginUseCaseOutput = Result<LogInResponse, LogInFailure>

public struct LogInUseCase: Sendable {
    public var logInAsync: @Sendable (_ request: LogInRequest) async -> LoginUseCaseOutput
    public var logIn: @Sendable (_ request: LogInRequest) -> Effect<LoginUseCaseOutput>
}

public extension LogInUseCase {
    static var noop: Self {
        .init(
            logInAsync: { _ in fatalError() },
            logIn: { _ in fatalError() }
        )
    }
}
