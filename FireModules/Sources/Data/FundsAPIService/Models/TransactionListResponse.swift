//
//  TransactionListResponse.swift
//
//
//  Created by Hien Tran on 02/02/2024.
//

import Codextended
import DomainEntities
import Foundation

public struct TransactionListResponse: Decodable {
    public let transactions: [TransactionItemResponse]

    public init(from decoder: Decoder) throws {
        self.transactions = try decoder.decode("allTransactions")
    }
}

public extension TransactionListResponse {
    func asPaginationEntity() -> PaginationEntity<TransactionEntity> {
        return PaginationEntity(
            currentPage: 0,
            items: transactions.map { $0.asTransactionEntity() }
        )
    }
}
