//
//  TransactionRecordResponse.swift
//
//
//  Created by Hien Tran on 28/01/2024.
//

import Codextended
import DomainEntities
import Foundation

public struct TransactionRecordResponse: Decodable {
    public let id: String
    public let timestamp: Int
    public let sourceFundId: String
    public let destinationFundId: String?
    public let amount: Decimal
    public let type: String
    public let userId: String
    public let currency: String
    public let description: String?

    public init(from decoder: Decoder) throws {
        self.id = try decoder.decode("transactionId")
        self.timestamp = try decoder.decode("timestamp")
        self.sourceFundId = try decoder.decode("sourceFundId")
        self.destinationFundId = try decoder.decodeIfPresent("destinationFundId")
        self.amount = try decoder.decode("amount")
        self.type = try decoder.decode("type")
        self.userId = try decoder.decode("userId")
        self.currency = try decoder.decode("currency")
        self.description = try decoder.decodeIfPresent("description")
    }
}

public extension TransactionRecordResponse {
    func asTransactionEntity() -> TransactionEntity {
        return TransactionEntity(
            id: id,
            timestamp: timestamp,
            sourceFundId: sourceFundId,
            destinationFundId: destinationFundId,
            amount: amount,
            type: type,
            userId: userId,
            currency: currency,
            description: description
        )
    }
}
