// sourcery: AutoMockable
public protocol TransactionListUseCaseProtocol {
    func getInOutTransactions() async -> Result<[TransactionEntity], DomainError>
}
