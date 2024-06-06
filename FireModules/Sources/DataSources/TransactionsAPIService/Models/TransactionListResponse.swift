//
//  TransactionListResponse.swift
//
//
//  Created by Hien Tran on 29/01/2024.
//

import Codextended
import Foundation

public struct TransactionListResponse: Decodable {
    public let transactions: [TransactionRecordResponse]

    public init(from decoder: Decoder) throws {
        self.transactions = try decoder.decode("transactions")
    }
}
