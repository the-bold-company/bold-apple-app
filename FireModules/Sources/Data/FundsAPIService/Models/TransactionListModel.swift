//
//  TransactionListModel.swift
//
//
//  Created by Hien Tran on 02/02/2024.
//

import Codextended
import Foundation

public struct TransactionListModel: Decodable {
    public let transactions: [TransactionModel]

    public init(from decoder: Decoder) throws {
        self.transactions = try decoder.decode("allTransactions")
    }
}

public extension TransactionListModel {
    func asPaginationEntity() -> PaginationEntity<TransactionEntity> {
        return PaginationEntity(
            currentPage: 0,
            items: transactions.map { $0.asTransactionEntity() }
        )
    }
}
