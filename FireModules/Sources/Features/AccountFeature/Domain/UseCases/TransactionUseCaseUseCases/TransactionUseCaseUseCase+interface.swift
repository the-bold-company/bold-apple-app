import ComposableArchitecture

public struct TransactionUseCase: Sendable {
    public var createTransaction: @Sendable (_ input: CreateTransactionInput) -> Effect<CreateTransactionOutput>
}
