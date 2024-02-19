//
//  AppIntentService.swift
//
//
//  Created by Hien Tran on 15/02/2024.
//

@_exported import AppIntents
import Dependencies
import Foundation
import PersistentService
import SharedModels
import TransactionsService

public struct AppIntentService {
    public init() {}
    let persistenceService = PersistentService()

    @Dependency(\.transactionSerivce) var transactionService

    public func fetchFunds() async throws -> [FundEntity] {
        return try await persistenceService.fetchFundList()
    }

    public func makeTransaction(
        sourceFundId: UUID,
        destinationFundId: UUID?,
        amount: Decimal
    ) async -> Result<TransactionEntity, NetworkError> {
        do {
            let res = try await transactionService.recordTransaction(
                sourceFundId: sourceFundId,
                amount: amount,
                destinationFundId: destinationFundId,
                description: nil,
                type: .inout
            )

            return .success(res)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(NetworkError.unknown(error))
        }
    }
}
