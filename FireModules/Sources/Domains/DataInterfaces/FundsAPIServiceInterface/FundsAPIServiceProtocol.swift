import DomainEntities
import Foundation

public protocol FundsAPIServiceProtocol {
    func createFund(
        name: String,
        balance: Decimal,
        fundType: FundType,
        currency: String,
        description: String?
    ) async throws -> FundEntity

    func listFunds() async throws -> [FundEntity]

    func getFundDetails(fundId: String) async throws -> FundEntity

    func deleteFund(fundId: String) async throws -> UUID

    func getTransactions(fundId: String, ascendingOrder: Bool) async throws -> PaginationEntity<TransactionEntity>
}
