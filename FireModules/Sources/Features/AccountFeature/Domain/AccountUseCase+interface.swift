import ComposableArchitecture

public struct AccountUseCase: Sendable {
    public var createAccount: @Sendable (_ input: CreateAccountInput) -> Effect<CreateAccountOutput>
}
