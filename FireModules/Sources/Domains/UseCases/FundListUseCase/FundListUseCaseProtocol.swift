// sourcery: AutoMockable
public protocol FundListUseCaseProtocol {
    func getFiatFundList() async -> Result<[FundEntity], DomainError>
}
