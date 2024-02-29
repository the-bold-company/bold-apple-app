import Foundation
import FundsAPIServiceInterface

public struct FundDetailsUseCase: FundDetailsUseCaseProtocol {
    let fundsAPIService: FundsAPIServiceProtocol

    public init(fundsAPIService: FundsAPIServiceProtocol) {
        self.fundsAPIService = fundsAPIService
    }

    public func loadFundDetails(id: UUID) async -> Result<FundEntity, DomainError> {
        do {
            let loadedFund = try await fundsAPIService.getFundDetails(fundId: id.serverCompartibleUUID)
            return .success(loadedFund)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }

    public func deleteFund(id: UUID) async -> Result<UUID, DomainError> {
        do {
            let deletedFundId = try await fundsAPIService.deleteFund(fundId: id.serverCompartibleUUID)
            return .success(deletedFundId)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }

    public func loadTransactionHistory(fundId: UUID, order: SortOrder) async -> Result<PaginationEntity<TransactionEntity>, DomainError> {
        do {
            let pagination = try await fundsAPIService.getTransactions(fundId: fundId.serverCompartibleUUID, ascendingOrder: order == .ascending)
            return .success(pagination)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
