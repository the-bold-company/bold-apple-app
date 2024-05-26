public protocol LogInUseCase {
    func logIn(_ request: AuthenticationLogic.LogIn.Request) async -> Result<AuthenticationLogic.LogIn.Response, AuthenticationLogic.LogIn.Failure>
}

public protocol SignUpUseCase {
    func signUp(_ request: AuthenticationLogic.SignUp.Request) async -> Result<AuthenticationLogic.SignUp.Response, AuthenticationLogic.SignUp.Failure>
}
