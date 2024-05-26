import Foundation
import InvestmentAPIServiceInterface

public struct InvestmentUseCase: InvestmentUseCaseInterface {
    private let investmentAPIService: InvestmentAPIServiceInterface

    public init(investmentAPIService: InvestmentAPIServiceInterface) {
        self.investmentAPIService = investmentAPIService
    }

    public func createPortfolio(name: String) async -> DomainResult<InvestmentPortfolioEntity> {
        do {
            let portfolio = try await investmentAPIService.createPortfolio(name: name)
            return .success(portfolio)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }

    public func getPortfolioList() async -> DomainResult<[InvestmentPortfolioEntity]> {
        do {
            let portfolios = try await investmentAPIService.getPortfolioList()
            return .success(portfolios)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }

    public func recordTransaction(
        amount: Decimal,
        portfolioId: ID,
        type: String,
        currency: String,
        notes: String?
    ) async -> DomainResult<InvestmentTransactionEntity> {
        do {
            let transaction = try await investmentAPIService.recordTransaction(
                amount: amount,
                portfolioId: portfolioId.dynamodbCompartibleUUIDString,
                type: type,
                currency: currency,
                notes: notes
            )
            return .success(transaction)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }

    public func getPortfolioDetails(id: String) async -> DomainResult<InvestmentPortfolioEntity> {
        do {
            let portfolio = try await investmentAPIService.getPortfolioDetails(id: id)
            return .success(portfolio)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }

    public func getTransactionHistory(portfolioId: ID) async -> DomainResult<[InvestmentTransactionEntity]> {
        return await autoCatch {
            return try await investmentAPIService.getTransactionHistory(portfolioId: portfolioId.dynamodbCompartibleUUIDString)
        }
    }
}
