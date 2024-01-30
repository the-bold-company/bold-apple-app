//
//  TransactionsService.swift
//
//
//  Created by Hien Tran on 28/01/2024.
//

import Dependencies
import Foundation
@_exported import Networking
@_exported import SharedModels

public extension DependencyValues {
    var transactionSerivce: TransactionsService {
        get { self[TransactionsService.self] }
        set { self[TransactionsService.self] = newValue }
    }
}

extension TransactionsService: DependencyKey {
    public static var liveValue = TransactionsService()
}

public struct TransactionsService {
    let client = MoyaClient<TransactionsAPI>()

    public init() {}

    public func recordTransaction(
        sourceFundId: UUID,
        amount: Decimal,
        destinationFundId: UUID?,
        description: String?,
        type: TransactionType
    ) async throws -> TransactionEntity {
        return try await client
            .requestPublisher(.record(
                sourceFundId: sourceFundId.uuidString.lowercased(),
                amount: amount,
                destinationFundId: destinationFundId?.uuidString.lowercased(),
                description: description,
                type: type.rawValue
            ))
            .mapToResponse(TransactionRecordResponse.self)
            .map { $0.asTransactionEntity() }
            .eraseToAnyPublisher()
            .async()
    }

    public func getTransactionLists() async throws -> [TransactionEntity] {
        return try await client
            .requestPublisher(.transactionList)
            .mapToResponse(TransactionListResponse.self)
            .map(\.transactions)
            .map { transactions in
                transactions.map { $0.asTransactionEntity() }
            }
            .eraseToAnyPublisher()
            .async()
    }
}
