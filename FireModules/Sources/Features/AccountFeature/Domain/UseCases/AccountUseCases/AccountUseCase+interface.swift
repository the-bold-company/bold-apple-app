import ComposableArchitecture

public struct AccountUseCase: Sendable {
    public var createAccount: @Sendable (_ input: CreateAccountInput) -> Effect<CreateAccountOutput>
    public var getAccountList: @Sendable (_ input: GetAccountListInput) -> Effect<GetAccountListOutput>
}
