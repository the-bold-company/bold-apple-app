import TransactionsAPIServiceInterface

public struct TransactionListUseCase: TransactionListUseCaseProtocol {
    let transactionsAPIService: TransactionsAPIServiceProtocol

    public init(transactionsAPIService: TransactionsAPIServiceProtocol) {
        self.transactionsAPIService = transactionsAPIService
    }

    public func getInOutTransactions() async -> Result<[TransactionEntity], DomainError> {
        do {
            let transactions = try await transactionsAPIService.getTransactionLists()
            return .success(transactions)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
