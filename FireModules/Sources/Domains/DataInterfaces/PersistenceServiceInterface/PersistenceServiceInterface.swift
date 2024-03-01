import DomainEntities

public protocol PersistenceServiceInterface {
    func saveFund(_ fund: FundEntity) async throws
    func saveFunds(_ funds: [FundEntity]) async throws
    func fetchFundList() async throws -> [FundEntity]
}
