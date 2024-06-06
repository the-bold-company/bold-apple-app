import ComposableArchitecture

public typealias LoginDomainOutput = Result<AuthenticationLogic.LogIn.Response, AuthenticationLogic.LogIn.Failure>
public typealias SignUpDomainOutput = Result<AuthenticationLogic.SignUp.Response, AuthenticationLogic.SignUp.Failure>

public protocol LogInUseCase {
    func logInAsync(_ request: AuthenticationLogic.LogIn.Request) async -> LoginDomainOutput
    func logIn(_ request: AuthenticationLogic.LogIn.Request) -> Effect<LoginDomainOutput>
}

public protocol SignUpUseCase {
    func signUp(_ request: AuthenticationLogic.SignUp.Request) async -> SignUpDomainOutput
}
