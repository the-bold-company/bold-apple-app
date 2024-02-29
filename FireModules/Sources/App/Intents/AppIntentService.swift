//
//  AppIntentService.swift
//
//
//  Created by Hien Tran on 15/02/2024.
//

@_exported import AppIntents
import DomainEntities
import Foundation
import PersistenceService
import TransactionsAPIService

public struct AppIntentService {
    public init() {}
    let persistenceService = PersistenceService()
    let transactionService = TransactionsAPIService()

    public func fetchFunds() async throws -> [FundEntity] {
        return try await persistenceService.fetchFundList()
    }

    public func makeTransaction(
        sourceFundId: UUID,
        destinationFundId: UUID?,
        amount: Decimal
    ) async -> Result<TransactionEntity, DomainError> {
        do {
            let res = try await transactionService.recordTransaction(
                sourceFundId: sourceFundId,
                amount: amount,
                destinationFundId: destinationFundId,
                description: nil,
                type: .inout
            )
            return .success(res)
        } catch {
            return .failure(error.eraseToDomainError())
        }
    }
}
